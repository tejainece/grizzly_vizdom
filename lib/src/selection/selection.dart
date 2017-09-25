library grizzly.vizdom.selection;

import 'dart:html';
import 'dart:collection';

import '../elements/elements.dart' as vEl;
import '../namespace/namespace.dart';
import '../transition/transition.dart';

part 'binding.dart';
part 'bound.dart';
part 'sel.dart';

/// Interface class for a selected selection
abstract class Selected {
  /// Groups in selection
  UnmodifiableListView<UnmodifiableListView<Element>> get groups;

  /// Parents of each group in selection
  UnmodifiableListView<Element> get parents;

  /// All non-null elements in selection
  UnmodifiableListView<Element> get allElements;

  /// Sets a constant attribute with name [name], value [value] to all elements
  /// in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided attribute
  /// to them. Null elements are skipped.
  Selected attr(String name, String value);

  /// Sets constant attributes with name [name], value [value] to all elements
  /// in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided attributes
  /// to them. Null elements are skipped.
  Selected attrs(Map<String, String> values);

  /// Sets a constant style with name [name], value [value] and priority
  /// [priority] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided style
  /// to them. Null elements are skipped.
  Selected style(String name, String value, [String priority]);

  /// Sets constant styles with name [name], value [value] and priority
  /// [priority] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided styles
  /// to them. Null elements are skipped.
  Selected styles(Map<String, String> styles, [String priority]);

  Selected classes(List<String> classes);

  Selected clazz(String clazz);

  Selected text(textContent);

  //TODO Selected rmAttr(String name);

  //TODO Selected rmStyle(String name);

  //TODO Selected rmClass(String name);

  //TODO Selected rmClasses(List<String> classes);

  Selected select(String select);

  BindableSelected selectAll(String select);

  Selected append(String tag);

  Selected insert(
      String tag, Element before(int index, Element parent, int groupIndex));

  Selected remove();

  Selected order();

  //TODO Selected replace();  //TODO: must take a function

  TransitionBase transition(String name);

  vEl.AsElement asElement();

  vEl.CircleElement asCircle();

  vEl.TextElement asText();

  vEl.LineElement asLine();
}

abstract class Bindable {
  /// Binds data to current [Selection] and returns update selection
  Binding<VT> bind<VT>(List<VT> values);

  Binding<UT> bindKeyed<UT>(List<UT> values, LinkedHashSet<String> keys);

  Binding<UT> bindMap<UT>(Map<String, UT> maps);
}

abstract class BindableSelected implements Selected, Bindable {}

class BindableSelection extends Selection implements BindableSelected {
  BindableSelection(List<List<Element>> groups, List<Element> parents)
      : super(groups, parents);

  /// Binds data to current [Selection] and returns update selection
  Binding<VT> bind<VT>(List<VT> values) =>
      new Binding<VT>._indexed(groups, parents, values);

  Binding<UT> bindKeyed<UT>(List<UT> values, LinkedHashSet<String> keys) =>
      new Binding._keyed(groups, parents, values, keys);

  Binding<UT> bindMap<UT>(Map<String, UT> map) => new Binding._keyed(groups,
      parents, map.values.toList(), new LinkedHashSet.from(map.keys.toList()));
}

typedef BoundStringFunc<VT> = String Function(BoundItem<VT> b);

class Datum<VT> {
  final VT data;

  final String label;

  Datum(this.data, this.label);
}

Selection select(String selector) => new Selection([
      [querySelector(selector)]
    ], [
      document.documentElement
    ]);

Selection selectAll(String selector) =>
    new Selection([querySelectorAll(selector)], [document.documentElement]);

UnmodifiableListView<UnmodifiableListView<T>> _makeImmutableLevel2<T>(
        List<List<T>> list) =>
    new UnmodifiableListView<UnmodifiableListView<T>>(
        list.map((List<T> l) => new UnmodifiableListView<T>(l)).toList());

UnmodifiableListView<T> _makeImmutableLevel1<T>(List<T> list) =>
    new UnmodifiableListView<T>(list);
