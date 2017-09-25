part of grizzly.vizdom.elements;

abstract class _TextAttrBase implements _Base {
  _TextAttrBase x(num value) {
    selection.attr('x', value.toString());
    return this;
  }

  _TextAttrBase y(num value) {
    selection.attr('y', value.toString());
    return this;
  }

  _TextAttrBase position(math.Point<num> center) {
    selection.attr('x', center.x.toString());
    selection.attr('y', center.y.toString());
    return this;
  }

  _TextAttrBase text(value) {
    selection.text(value);
    return this;
  }

  _TextAttrBase textAnchorAtStart() {
    selection.attr('text-anchor', 'start');
    return this;
  }

  _TextAttrBase textAnchorAtMiddle() {
    selection.attr('text-anchor', 'middle');
    return this;
  }

  _TextAttrBase textAnchorAtEnd() {
    selection.attr('text-anchor', 'end');
    return this;
  }
}

class TextAttr extends ElementAttr with _Base, _TextAttrBase, _CommonSvgAttr {
  final Selected selection;

  TextAttr(this.selection);

  TextAttr x(num value) => super.x(value);

  TextAttr y(num value) => super.y(value);

  TextAttr position(math.Point<num> value) => super.position(value);

  TextAttr text(value) => super.text(value);

  TextAttr textAnchorAtStart() => super.textAnchorAtStart();

  TextAttr textAnchorAtMiddle() => super.textAnchorAtMiddle();

  TextAttr textAnchorAtEnd() => super.textAnchorAtEnd();

  TextAttr stroke(String color) => super.stroke(color);

  TextAttr fill(String color) => super.stroke(color);
}

class TextElement extends Element with _Base {
  final Selected selection;

  TextElement(this.selection);

  TextAttr get attrs => new TextAttr(selection);

  TextElement x(num value) {
    attrs.x(value);
    return this;
  }

  TextElement y(num value) {
    attrs.y(value);
    return this;
  }

  TextElement position(math.Point<num> value) {
    attrs.position(value);
    return this;
  }

  TextElement text(value) {
    attrs.text(value);
    return this;
  }

  TextElement textAnchorAtStart() {
    attrs.textAnchorAtStart();
    return this;
  }

  TextElement textAnchorAtMiddle() {
    attrs.textAnchorAtMiddle();
    return this;
  }

  TextElement textAnchorAtEnd() {
    attrs.textAnchorAtEnd();
    return this;
  }

  TextElement stroke(String color) {
    attrs.stroke(color);
    return this;
  }

  TextElement fill(String color) {
    attrs.fill(color);
    return this;
  }
}

class TextAttrBound<VT> extends ElementAttr
    with _BaseBound<VT>, _TextAttrBase
    implements TextAttr {
  final BoundSelection<VT> selection;

  TextAttrBound(this.selection);

  TextAttrBound<VT> x(num value) => super.x(value);

  TextAttrBound<VT> xBound(num value(BoundItem<VT> b)) {
    selection.attrBound('x', (BoundItem<VT> b) => value(b).toString());
    return this;
  }

  TextAttrBound<VT> y(num value) => super.y(value);

  TextAttrBound<VT> yBound(num value(BoundItem<VT> b)) {
    selection.attrBound('y', (BoundItem<VT> b) => value(b).toString());
    return this;
  }

  TextAttrBound<VT> position(math.Point<num> value) => super.position(value);

  TextAttrBound<VT> positionBound(math.Point<num> value(BoundItem<VT> b)) {
    selection.attrsMapBound((BoundItem<VT> b) {
      final math.Point<num> map = value(b);
      return {
        'x': map.x.toString(),
        'y': map.y.toString(),
      };
    });
    return this;
  }

  TextAttrBound<VT> text(value) => super.text(value);

  TextAttrBound<VT> textBound(dynamic value(BoundItem<VT> b)) {
    selection.textBound(value);
    return this;
  }

  TextAttrBound<VT> textAnchorAtStart() => super.textAnchorAtStart();

  TextAttrBound<VT> textAnchorAtMiddle() => super.textAnchorAtMiddle();

  TextAttrBound<VT> textAnchorAtEnd() => super.textAnchorAtEnd();

  TextAttrBound<VT> stroke(String color) => super.stroke(color);

  TextAttrBound<VT> strokeBound(String color(BoundItem<VT> b)) {
    selection.attrBound('stroke', color);
    return this;
  }

  TextAttrBound<VT> fill(String color) => super.fill(color);

  TextAttrBound<VT> fillBound(String color(BoundItem<VT> b)) {
    selection.attrBound('fill', color);
    return this;
  }
}

class TextElementBound<VT> extends Element
    with _BaseBound<VT>
    implements TextElement {
  final BoundSelection<VT> selection;

  TextElementBound(this.selection) : attrs = new TextAttrBound<VT>(selection);

  final TextAttrBound<VT> attrs;

  TextElementBound<VT> x(num value) {
    attrs.x(value);
    return this;
  }

  TextElementBound<VT> xBound(num value(BoundItem<VT> b)) {
    attrs.xBound(value);
    return this;
  }

  TextElementBound<VT> y(num value) {
    attrs.y(value);
    return this;
  }

  TextElementBound<VT> yBound(num value(BoundItem<VT> b)) {
    attrs.yBound(value);
    return this;
  }

  TextElementBound<VT> position(math.Point<num> value) {
    attrs.position(value);
    return this;
  }

  TextElementBound<VT> positionBound(math.Point<num> value(BoundItem<VT> b)) {
    attrs.positionBound(value);
    return this;
  }

  TextElementBound<VT> text(value) {
    attrs.text(value);
    return this;
  }

  TextElementBound<VT> textBound(dynamic value(BoundItem<VT> b)) {
    attrs.textBound(value);
    return this;
  }

  TextElementBound<VT> textAnchorAtStart() {
    attrs.textAnchorAtStart();
    return this;
  }

  TextElementBound<VT> textAnchorAtMiddle() {
    attrs.textAnchorAtMiddle();
    return this;
  }

  TextElementBound<VT> textAnchorAtEnd() {
    attrs.textAnchorAtEnd();
    return this;
  }

  TextElementBound<VT> stroke(String color) {
    attrs.stroke(color);
    return this;
  }

  TextElementBound<VT> strokeBound(String color(BoundItem<VT> b)) {
    attrs.strokeBound(color);
    return this;
  }

  TextElementBound<VT> fill(String color) {
    attrs.fill(color);
    return this;
  }

  TextElementBound<VT> fillBound(String color(BoundItem<VT> b)) {
    attrs.fillBound(color);
    return this;
  }
}
