part of grizzly.vizdom.selection;

/// Encapsulates binding on a [Selection]
class Binding<VT> {
  /// Groups in selection
  final UnmodifiableListView<UnmodifiableListView<Element>> groups;

  /// Parents of each group in selection
  final UnmodifiableListView<Element> parents;

  final List<List<EnterNode>> _enter;

  List<List<Element>> _entered;

  final List<List<Element>> _exit;

  final List<List<Element>> _update;

  /// Labels of data bound to the selection
  final UnmodifiableListView<String> labels;

  /// The data bound to the selection
  final UnmodifiableListView<VT> data;

  Binding._(this.groups, this.parents, this.data, this.labels, this._enter,
      this._exit, this._update);

  factory Binding._indexed(
      UnmodifiableListView<UnmodifiableListView<Element>> groups,
      UnmodifiableListView<Element> parents,
      List<VT> data) {
    final enters = new List<List<EnterNode>>.filled(groups.length, null);
    final exits = new List<List<Element>>.filled(groups.length, null);
    final updates = new List<List<Element>>.filled(groups.length, null);

    for (int j = 0; j < groups.length; j++) {
      final List<Element> group = groups[j];
      final Element parent = parents[j];

      final enter = new List<EnterNode>.filled(data.length, null);
      final exit = new List<Element>.filled(group.length, null);
      final update = new List<Element>.filled(data.length, null);

      enters[j] = enter;
      exits[j] = exit;
      updates[j] = update;

      // Non-null nodes => update
      // Null nodes => enter
      // New nodes => enter.
      for (int i = 0; i < data.length; i++) {
        final Element el = i < group.length ? group[i] : null;
        if (el != null) {
          el.dataset['vizzie-label'] = i.toString();
          update[i] = el;
        } else {
          enter[i] = new EnterNode(parent, data[i], i.toString(), i, null);
        }
      }

      // extra nodes => exit
      for (int i = data.length; i < group.length; i++) {
        final Element el = group[i];
        if (el != null) {
          exit[i] = el;
        }
      }

      // Order so that newly entered nodes are inserted in order
      /* Seems like this is not necessary
      {
        int i1 = 0;
        Element next;

        for (int i0 = 0; i0 < data.length; i0++) {
          final EnterNode previous = enter[i0];
          if (previous != null) {
            if (i0 >= i1) {
              if (i0 == (data.length - 1)) break;
              i1 = i0 + 1;
            }
            while (((next = update[i1]) == null) && (++i1 < data.length));
            enter[i0] = previous.cloneWithNext(next);
            if (i1 >= data.length) break;
          }
        }
      }
      */
    }

    final labels =
        new List<String>.generate(data.length, (int i) => i.toString());

    return new Binding<VT>._(groups, parents, _makeImmutableLevel1<VT>(data),
        _makeImmutableLevel1<String>(labels), enters, exits, updates);
  }

  factory Binding._keyed(
      UnmodifiableListView<UnmodifiableListView<Element>> groups,
      UnmodifiableListView<Element> parents,
      List<VT> data,
      LinkedHashSet<String> keys) {
    final enters = new List<List<EnterNode>>.filled(groups.length, null);
    final exits = new List<List<Element>>.filled(groups.length, null);
    final updates = new List<List<Element>>.filled(groups.length, null);

    for (int j = 0; j < groups.length; j++) {
      final nodeKeyMap = <String, Element>{};

      final List<Element> group = groups[j];
      final Element parent = parents[j];

      final enter = new List<EnterNode>.filled(data.length, null);
      final exit = new List<Element>.filled(group.length, null);
      final update = new List<Element>.filled(data.length, null);

      enters[j] = enter;
      exits[j] = exit;
      updates[j] = update;

      // Find keys for existing nodes
      for (int i = 0; i < group.length; i++) {
        final Element el = group[i];
        if (el == null) continue;
        final String key = el.dataset['vizzie-label'];
        if (nodeKeyMap.containsKey(key)) {
          exit[i] = el;
        } else if (!keys.contains(key)) {
          exit[i] = el;
        } else {
          nodeKeyMap[key] = el;
        }
      }

      final Iterator<String> keyIter = keys.iterator;
      keyIter.moveNext();
      for (int i = 0; i < data.length; i++) {
        final String key = keyIter.current;
        if (nodeKeyMap.containsKey(key)) {
          update[i] = nodeKeyMap[key];
          nodeKeyMap.remove(key);
        } else {
          enter[i] = new EnterNode(parent, data[i], key, i, null);
        }
        keyIter.moveNext();
      }
    }

    return new Binding<VT>._(groups, parents, _makeImmutableLevel1<VT>(data),
        _makeImmutableLevel1<String>(keys.toList()), enters, exits, updates);
  }

  /// Returns [BoundSelection] to work on new data items
  BoundSelection<VT> enter(String tag) {
    if (_entered != null) throw new Exception('Already entered!');
    _entered = new List<List<Element>>.filled(_enter.length, null);
    for (int i = 0; i < _enter.length; i++) {
      final List<EnterNode> group = _enter[i];
      _entered[i] = new List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final EnterNode el = group[j];
        if (el == null) continue;

        final Element newEl = _createElement(el.parent, tag);
        newEl.dataset['vizzie-label'] = labels[j];
        el.append(newEl);
        _entered[i][j] = newEl;
      }
    }
    return new BoundSelection<VT>._fromImmutable(
        _makeImmutableLevel2<Element>(_entered),
        this.parents,
        data,
        labels,
        this);
  }

  /// Returns [Selection] to work on old unneeded elements
  Selection exit() => new Selection(_exit, parents);

  /// Returns [Selection] to work on old but needed elements
  BoundSelection<VT> update() => new BoundSelection<VT>._fromImmutable(
      _update, this.parents, data, labels, this);

  /// Merges enter and update selections and returns the merged selection
  ///
  /// Binding must be entered before merging
  BoundSelection<VT> merge() {
    if (_entered == null) throw new Exception('Must be entered before merge!');
    final newGroup = new List<List<Element>>.filled(groups.length, null);
    for (int i = 0; i < groups.length; i++) {
      final List<Element> entered = _entered[i];
      final List<Element> updated = _update[i];
      newGroup[i] = new List<Element>.filled(data.length, null);
      for (int j = 0; j < data.length; j++) {
        newGroup[i][j] = entered[j] ?? updated[j];
      }
    }
    return new BoundSelection<VT>._fromImmutable(
        _makeImmutableLevel2<Element>(newGroup),
        this.parents,
        data,
        labels,
        this);
  }
}

/// Encapsulates the items that needs to be entered in [Binding]
class EnterNode<VT> {
  /// Parent of the entered item
  final Element parent;

  /// Label of the data bound to the item
  final String label;

  /// Data bound to the item
  final VT data;

  /// Index of datum in data bound to the selection
  final int index;

  /// Node before which the entered item shall be inserted
  ///
  /// [next] can be null
  final Node next;

  EnterNode(this.parent, this.data, this.label, this.index, this.next);

  EnterNode cloneWithNext(Element next) =>
      new EnterNode(parent, data, label, index, next);

  void append(Element child) => parent.insertBefore(child, next);
}
