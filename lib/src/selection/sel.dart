part of grizzly.vizdom.selection;

Element _createElement(String tag) {
  final Namespaced name = Namespaced.parse(tag);

  if (!name.hasSpace) return new Element.tag(tag);

  return document.createElementNS(name.space, name.local);
}

abstract class SelectedMixin implements Selected {
  Selected attr(String name, String value) {
    final Namespaced attrName = Namespaced.parse(name);
    allElements.forEach((Element e) {
      if (attrName.hasSpace)
        e.setAttributeNS(attrName.space, attrName.local, value);
      else
        e.setAttribute(attrName.local, value);
    });
    return this;
  }

  Selected attrs(Map<String, String> attrMap) {
    final attrSpaces = <String, Namespaced>{};
    attrMap.forEach((String n, _) {
      final Namespaced attrName = Namespaced.parse(n);
      attrSpaces[n] = attrName;
    });
    allElements
        .forEach((Element e) => attrMap.forEach((String name, String value) {
              final Namespaced attrName = attrSpaces[name];
              if (attrName.hasSpace)
                e.setAttributeNS(attrName.space, attrName.local, value);
              else
                e.setAttribute(attrName.local, value);
            }));
    return this;
  }

  Selected style(String name, String value, [String priority]) {
    allElements
        .forEach((Element e) => e.style.setProperty(name, value, priority));
    return this;
  }

  Selected styles(Map<String, String> styles, [String priority]) {
    allElements.forEach((Element e) => styles.forEach(
        (String name, String value) =>
            e.style.setProperty(name, value, priority)));
    return this;
  }

  Selected classes(List<String> classes) {
    allElements.forEach((Element e) => e.classes.addAll(classes));
    return this;
  }

  Selected clazz(String clazz) {
    allElements.forEach((Element e) => e.classes.add(clazz));
    return this;
  }

  Selected text(textContent) {
    allElements.forEach((Element e) => e.text = textContent.toString());
    return this;
  }

  Selected order() {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      if (group.length <= 1) continue;

      final Iterator<Element> iterator = group.reversed.iterator;
      iterator.moveNext();
      Element next = iterator.current;

      while (iterator.moveNext()) {
        final Element el = iterator.current;
        if (el == null) continue;
        if (el.nextElementSibling != next) el.parent.insertBefore(el, next);
        next = el;
      }
    }
    return this;
  }
}

class Selection extends Object with SelectedMixin implements Selected {
  final UnmodifiableListView<UnmodifiableListView<Element>> groups;

  final UnmodifiableListView<Element> parents;

  final UnmodifiableListView<Element> allElements;

  Selection(List<List<Element>> groups, List<Element> parents)
      : groups = _makeImmutableLevel2<Element>(groups),
        parents = _makeImmutableLevel1<Element>(parents),
        allElements = new UnmodifiableListView(groups.fold<List<Element>>(
            <Element>[],
            (List<Element> list, List<Element> g) =>
                list..addAll(g.where((el) => el != null))));

  Selection._groups(List<List<Element>> groups, this.parents)
      : groups = new UnmodifiableListView<UnmodifiableListView<Element>>(groups
            .map((List<Element> l) => new UnmodifiableListView<Element>(l))
            .toList()),
        allElements = new UnmodifiableListView(groups.fold<List<Element>>(
            <Element>[],
            (List<Element> list, List<Element> g) =>
                list..addAll(g.where((el) => el != null))));

  /// Sets a constant attribute with name [name], value [value] to all elements
  /// in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided attribute
  /// to them. Null elements are skipped.
  Selection attr(String name, String value) => super.attr(name, value);

  /// Sets constant attributes with name [name], value [value] to all elements
  /// in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided attributes
  /// to them. Null elements are skipped.
  Selection attrs(Map<String, String> attrMap) => super.attrs(attrMap);

  /// Sets a constant style with name [name], value [value] and priority
  /// [priority] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided style
  /// to them. Null elements are skipped.
  Selection style(String name, String value, [String priority]) =>
      super.style(name, value, priority);

  /// Sets constant styles with name [name], value [value] and priority
  /// [priority] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided styles
  /// to them. Null elements are skipped.
  Selection styles(Map<String, String> styles, [String priority]) =>
      super.styles(styles, priority);

  /// Adds constant classes [classes] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and adds classes
  /// to them. Null elements are skipped.
  Selection classes(List<String> classes) => super.classes(classes);

  /// Adds constant class [clazz] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and adds class
  /// to them. Null elements are skipped.
  Selection clazz(String clazz) => super.clazz(clazz);

  /// Sets a constant text context of all elements in the selection to [text]
  ///
  /// Iterates over all elements in the selection and sets their text content.
  /// Null elements are skipped.
  Selection text(textContent) => super.text(textContent);

  Selection select(String select) {
    final newGroup = new List<List<Element>>.filled(groups.length, null);
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      newGroup[i] = new List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        newGroup[i][j] = el.querySelector(select);
      }
    }
    return new Selection._groups(newGroup, this.parents);
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

  Selection append(String tag) {
    final newGroup = new List<List<Element>>.filled(groups.length, null);
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      newGroup[i] = new List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        final Element newEl = _createElement(tag);
        el.append(newEl);
        newGroup[i][j] = newEl;
      }
    }
    return new Selection(newGroup, this.parents);
  }

  Selection insert(
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
    return new Selection(newGroup, this.parents);
  }

  Selection remove() {
    allElements.forEach((Element e) => e.remove());
    return this;
  }

  Selection order() => super.order();

  Transition transition(String name) => new Transition(this, name);
}

class SelectionItem {
  final int index;

  final int groupIndex;

  final Element rootParent;

  final Element element;

  SelectionItem(this.index, this.groupIndex, this.rootParent, this.element);
}