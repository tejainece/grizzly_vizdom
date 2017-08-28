part of grizzly.vizdom.selection;

/// Encapsulates an bound item in [BoundSelection]
///
/// Usually used passed as parameters to bound methods in [BoundSelection]
class BoundItem<VT> {
  /// [Element] of the bound item
  final Element element;

  /// Data bound to the bound item
  final VT data;

  /// Label of the bound data
  final String label;

  /// Index of the item in the group
  final int index;

  BoundItem(this.element, this.data, this.label, this.index);
}

/// A [Selected] that has data bound to it
class BoundSelection<VT> extends Object with SelectedMixin implements Selected {
  /// Groups in selection
  final UnmodifiableListView<UnmodifiableListView<Element>> groups;

  /// Parents of each group in selection
  final UnmodifiableListView<Element> parents;

  /// Iterator over all elements in all groups in the selection
  final UnmodifiableListView<Element> allElements;

  /// Labels of data bound to the selection
  final UnmodifiableListView<String> labels;

  /// The data bound to the selection
  final UnmodifiableListView<VT> data;

  /// The enclosing binding
  final Binding binding;

  BoundSelection._fromImmutable(
      this.groups, this.parents, this.data, this.labels, this.binding)
      : allElements = new UnmodifiableListView(groups.fold<List<Element>>(
            <Element>[],
            (List<Element> list, List<Element> g) =>
                list..addAll(g.where((el) => el != null))));

  /// Sets a constant attribute with name [name], value [value] to all elements
  /// in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided attribute
  /// to them. Null elements are skipped.
  BoundSelection<VT> attr(String name, String value) => super.attr(name, value);

  /// Sets constant attributes with name [name], value [value] to all elements
  /// in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided attributes
  /// to them. Null elements are skipped.
  BoundSelection<VT> attrs(Map<String, String> attrMap) => super.attrs(attrMap);

  /// Sets a constant style with name [name], value [value] and priority
  /// [priority] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided style
  /// to them. Null elements are skipped.
  BoundSelection<VT> style(String name, String value, [String priority]) =>
      super.style(name, value, priority);

  /// Sets constant styles with name [name], value [value] and priority
  /// [priority] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided styles
  /// to them. Null elements are skipped.
  BoundSelection<VT> styles(Map<String, String> styles, [String priority]) =>
      super.styles(styles, priority);

  /// Adds constant classes [classes] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and adds classes
  /// to them. Null elements are skipped.
  BoundSelection<VT> classes(List<String> classes) => super.classes(classes);

  /// Adds constant class [clazz] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and adds class
  /// to them. Null elements are skipped.
  BoundSelection<VT> clazz(String clazz) => super.clazz(clazz);

  BoundSelection<VT> text(textContent) => super.text(textContent);

  BoundSelection<VT> attrBound(String name, String value(BoundItem<VT> b)) {
    final Namespaced attrName = Namespaced.parse(name);

    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        final String v = value(new BoundItem<VT>(el, data[j], labels[j], j));
        if (attrName.hasSpace)
          el.setAttributeNS(attrName.space, attrName.local, v);
        else
          el.setAttribute(attrName.local, v);
      }
    }
    return this;
  }

  BoundSelection<VT> attrsBound(Map<String, BoundStringFunc<VT>> attrBindings) {
    final attrSpaces = <String, Namespaced>{};
    attrBindings.forEach((String n, _) {
      final Namespaced attrName = Namespaced.parse(n);
      attrSpaces[n] = attrName;
    });
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        attrBindings.forEach((String name, BoundStringFunc<VT> value) {
          final String v = value(new BoundItem<VT>(el, data[j], labels[j], j));
          final Namespaced attrName = attrSpaces[name];
          if (attrName.hasSpace)
            el.setAttributeNS(attrName.space, attrName.local, v);
          else
            el.setAttribute(attrName.local, v);
        });
      }
    }
    return this;
  }

  BoundSelection<VT> styleBound(String name, String value(BoundItem<VT> b),
      [String priority]) {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        el.style.setProperty(name,
            value(new BoundItem<VT>(el, data[j], labels[j], j)), priority);
      }
    }
    return this;
  }

  BoundSelection<VT> stylesBound(Map<String, BoundStringFunc<VT>> styleBindings,
      [String priority]) {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        styleBindings.forEach((String name, BoundStringFunc<VT> value) =>
            el.style.setProperty(name,
                value(new BoundItem<VT>(el, data[j], labels[j], j)), priority));
      }
    }
    return this;
  }

  BoundSelection<VT> textBound(dynamic value(BoundItem<VT> b),
      [String priority]) {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        el.text =
            value(new BoundItem<VT>(el, data[j], labels[j], j)).toString();
      }
    }
    return this;
  }

  BoundSelection<VT> select(String select) {
    final newGroup = new List<List<Element>>.filled(groups.length, null);
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      newGroup[i] = new List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        el.dataset['vizzie-label'] = labels[i];
        newGroup[i][j] = el.querySelector(select);
      }
    }
    return new BoundSelection._fromImmutable(
        _makeImmutableLevel2<Element>(newGroup),
        this.parents,
        data,
        labels,
        binding);
  }

  BindableSelection selectAll(String select) {
    final newGroup = <List<Element>>[];
    final newParents = <Element>[];

    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        newGroup.add(el.querySelectorAll(select));
        newParents.add(el);
      }
    }
    return new BindableSelection(newGroup, newParents);
  }

  BoundSelection<UT> unwind<UT>(UT unwinder(VT value, int i)) {
    final newData = <UT>[];
    for (int i = 0; i < data.length; i++) {
      newData[i] = unwinder(data[i], i);
    }
    return new BoundSelection<UT>._fromImmutable(this.groups, this.parents,
        _makeImmutableLevel1<UT>(newData), labels, binding);
  }

  /* TODO
  Binding<UT> unwindKeyed<UT>(Datum<UT> unwinder(VT value, int i)) {
    final newData = <UT>[];
    final newKeys = new LinkedHashSet();
    for (int i = 0; i < data.length; i++) {
      final Datum<UT> datum = unwinder(data[i], i);
      if (newKeys.contains(datum.label)) newData[i] = datum.data;
      newKeys.add(datum.label);
    }
    return bindKeyed<UT>(newData, newKeys);
  }
  */

  BoundSelection<VT> append(String tag) {
    final newGroup = new List<List<Element>>.filled(groups.length, null);
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      newGroup[i] = new List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        final Element newEl = _createElement(tag);
        newEl.dataset['vizzie-label'] = labels[i];
        el.append(newEl);
        newGroup[i][j] = newEl;
      }
    }
    return new BoundSelection<VT>._fromImmutable(
        _makeImmutableLevel2<Element>(newGroup),
        this.parents,
        data,
        labels,
        binding);
  }

  BoundSelection<VT> appendBound(Element creator(BoundItem<VT> b)) {
    final newGroup = new List<List<Element>>.filled(groups.length, null);
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      newGroup[i] = new List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        final newEl = creator(new BoundItem(null, data[j], labels[j], j));
        newEl.dataset['vizzie-label'] = labels[i];
        el.append(newEl);
        newGroup[i][j] = newEl;
      }
    }
    return new BoundSelection<VT>._fromImmutable(
        _makeImmutableLevel2<Element>(newGroup),
        this.parents,
        data,
        labels,
        binding);
  }

  BoundSelection<VT> insert(
      String tag, Element before(int index, Element parent, int groupIndex)) {
    final newGroup = new List<List<Element>>.filled(groups.length, null);
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      newGroup[i] = new List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        final Element newEl = _createElement(tag);
        final Element beforeEl = before(j, el, i);
        el.insertBefore(newEl, beforeEl);
        newGroup[i][j] = newEl;
      }
    }
    return new BoundSelection<VT>._fromImmutable(
        _makeImmutableLevel2<Element>(newGroup),
        this.parents,
        data,
        labels,
        binding);
  }

  BoundSelection<VT> remove() {
    allElements.forEach((Element e) => e.remove());
    return this;
  }

  BoundSelection<VT> order() => super.order();

  /// Returns [BoundSelection] to work on new data items
  BoundSelection<VT> enter(String tag) => binding.enter(tag);

  /// Returns [Selection] to work on old data items
  Selection exit() => binding.exit();

  BoundSelection<VT> update() => binding.update();

  BoundSelection<VT> merge() => binding.merge();

  BoundTransition<VT> transition(String name) =>
      new BoundTransition<VT>(this, name);
}
