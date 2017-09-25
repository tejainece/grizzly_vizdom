library grizzly.vizdom.elements;

import 'dart:collection';
import 'dart:html' as html;
import 'dart:svg' as svg;
import 'dart:math' as math;
import 'package:grizzly_vizdom/src/selection/selection.dart';

part 'svg/circle.dart';
part 'svg/line.dart';
part 'svg/text.dart';
part 'svg/common_attrs.dart';

abstract class _Base {
  Selected get selection;

  UnmodifiableListView<UnmodifiableListView<html.Element>> get groups =>
      selection.groups;

  UnmodifiableListView<html.Element> get parents => selection.parents;

  UnmodifiableListView<html.Element> get allElements => selection.allElements;
}

abstract class _BaseBound<VT> implements _Base {
  BoundSelection<VT> get selection;

  UnmodifiableListView<UnmodifiableListView<html.Element>> get groups =>
      selection.groups;

  UnmodifiableListView<html.Element> get parents => selection.parents;

  UnmodifiableListView<html.Element> get allElements => selection.allElements;

  /// Labels of data bound to the selection
  UnmodifiableListView<String> get labels => selection.labels;

  /// The data bound to the selection
  UnmodifiableListView<VT> get data => selection.data;

  /// The enclosing binding
  Binding get binding => selection.binding;
}

abstract class ElementAttr {}

abstract class Element {
  ElementAttr get attrs;
}

class AsElement extends Object with _Base {
  final Selected selection;

  AsElement(this.selection);

  LineElement get line => new LineElement(selection);

  CircleElement get circle => new CircleElement(selection);

  TextElement get text => new TextElement(selection);
}

class AsBoundElement<VT> extends Object with _BaseBound<VT> implements AsElement {
  final BoundSelection<VT> selection;

  AsBoundElement(this.selection);

  LineElementBound<VT> get line => new LineElementBound<VT>(selection);

  CircleElementBound<VT> get circle => new CircleElementBound<VT>(selection);

  TextElementBound<VT> get text => new TextElementBound<VT>(selection);
}

