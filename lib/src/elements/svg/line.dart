part of grizzly.vizdom.elements;

abstract class _LineAttrBase implements _Base {
  _LineAttrBase x1(num value) {
    selection.attr('x1', value.toString());
    return this;
  }

  _LineAttrBase y1(num value) {
    selection.attr('y1', value.toString());
    return this;
  }

  _LineAttrBase x2(num value) {
    selection.attr('x2', value.toString());
    return this;
  }

  _LineAttrBase y2(num value) {
    selection.attr('y2', value.toString());
    return this;
  }

  _LineAttrBase start(math.Point<num> center) {
    selection.attr('x1', center.x.toString());
    selection.attr('y1', center.y.toString());
    return this;
  }

  _LineAttrBase end(math.Point<num> center) {
    selection.attr('x2', center.x.toString());
    selection.attr('y2', center.y.toString());
    return this;
  }
}

class LineAttr extends ElementAttr with _Base, _LineAttrBase, _CommonSvgAttr {
  final Selected selection;

  LineAttr(this.selection);

  LineAttr x1(num value) => super.x1(value);

  LineAttr y1(num value) => super.y1(value);

  LineAttr x2(num value) => super.x2(value);

  LineAttr y2(num value) => super.y2(value);

  LineAttr start(math.Point<num> value) => super.start(value);

  LineAttr end(math.Point<num> value) => super.end(value);

  LineAttr stroke(String color) => super.stroke(color);

  LineAttr fill(String color) => super.stroke(color);
}

class LineElement extends Element with _Base {
  final Selected selection;

  LineElement(this.selection);

  LineAttr get attrs => new LineAttr(selection);

  LineElement x1(num value) {
    attrs.x1(value);
    return this;
  }

  LineElement y1(num value) {
    attrs.y1(value);
    return this;
  }

  LineElement x2(num value) {
    attrs.x2(value);
    return this;
  }

  LineElement y2(num value) {
    attrs.y2(value);
    return this;
  }

  LineElement start(math.Point<num> value) {
    attrs.start(value);
    return this;
  }

  LineElement end(math.Point<num> value) {
    attrs.end(value);
    return this;
  }

  LineElement stroke(String color) {
    attrs.stroke(color);
    return this;
  }

  LineElement fill(String color) {
    attrs.fill(color);
    return this;
  }
}

class LineAttrBound<VT> extends ElementAttr
    with _BaseBound<VT>, _LineAttrBase, _CommonSvgAttr
    implements LineAttr {
  final BoundSelection<VT> selection;

  LineAttrBound(this.selection);

  LineAttrBound<VT> x1(num value) => super.x1(value);

  LineAttrBound<VT> x1Bound(num value(BoundItem<VT> b)) {
    selection.attrBound('x1', (BoundItem<VT> b) => value(b).toString());
    return this;
  }

  LineAttrBound<VT> y1(num value) => super.y1(value);

  LineAttrBound<VT> y1Bound(num value(BoundItem<VT> b)) {
    selection.attrBound('y1', (BoundItem<VT> b) => value(b).toString());
    return this;
  }

  LineAttrBound<VT> x2(num value) => super.x2(value);

  LineAttrBound<VT> x2Bound(num value(BoundItem<VT> b)) {
    selection.attrBound('x2', (BoundItem<VT> b) => value(b).toString());
    return this;
  }

  LineAttrBound<VT> y2(num value) => super.y2(value);

  LineAttrBound<VT> y2Bound(num value(BoundItem<VT> b)) {
    selection.attrBound('y2', (BoundItem<VT> b) => value(b).toString());
    return this;
  }

  LineAttrBound<VT> start(math.Point<num> value) => super.start(value);

  LineAttrBound<VT> startBound(math.Point<num> value(BoundItem<VT> b)) {
    selection.attrsMapBound((BoundItem<VT> b) {
      final math.Point<num> map = value(b);
      return {
        'x1': map.x.toString(),
        'y1': map.y.toString(),
      };
    });
    return this;
  }

  LineAttrBound<VT> end(math.Point<num> value) => super.end(value);

  LineAttrBound<VT> endBound(math.Point<num> value(BoundItem<VT> b)) {
    selection.attrsMapBound((BoundItem<VT> b) {
      final math.Point<num> map = value(b);
      return {
        'x2': map.x.toString(),
        'y2': map.y.toString(),
      };
    });
    return this;
  }

  LineAttrBound<VT> stroke(String color) => super.stroke(color);

  LineAttrBound<VT> strokeBound(String color(BoundItem<VT> b)) {
    selection.attrBound('stroke', color);
    return this;
  }

  LineAttrBound<VT> fill(String color) => super.fill(color);

  LineAttrBound<VT> fillBound(String color(BoundItem<VT> b)) {
    selection.attrBound('fill', color);
    return this;
  }
}

class LineElementBound<VT> extends Element
    with _BaseBound<VT>
    implements LineElement {
  final BoundSelection<VT> selection;

  LineElementBound(this.selection);

  LineAttrBound<VT> get attrs => new LineAttrBound<VT>(selection);

  LineElementBound<VT> x1(num value) {
    attrs.x1(value);
    return this;
  }

  LineElementBound<VT> x1Bound(num value(BoundItem<VT> b)) {
    attrs.x1Bound(value);
    return this;
  }

  LineElementBound<VT> y1(num value) {
    attrs.y1(value);
    return this;
  }

  LineElementBound<VT> y1Bound(num value(BoundItem<VT> b)) {
    attrs.y1Bound(value);
    return this;
  }

  LineElementBound<VT> x2(num value) {
    attrs.x2(value);
    return this;
  }

  LineElementBound<VT> x2Bound(num value(BoundItem<VT> b)) {
    attrs.x2Bound(value);
    return this;
  }

  LineElementBound<VT> y2(num value) {
    attrs.y2(value);
    return this;
  }

  LineElementBound<VT> y2Bound(num value(BoundItem<VT> b)) {
    attrs.y2Bound(value);
    return this;
  }

  LineElementBound<VT> start(math.Point<num> value) {
    attrs.start(value);
    return this;
  }

  LineElementBound<VT> startBound(math.Point<num> value(BoundItem<VT> b)) {
    attrs.startBound(value);
    return this;
  }

  LineElementBound<VT> end(math.Point<num> value) {
    attrs.end(value);
    return this;
  }

  LineElementBound<VT> endBound(math.Point<num> value(BoundItem<VT> b)) {
    attrs.endBound(value);
    return this;
  }

  LineElementBound<VT> stroke(String color) {
    attrs.stroke(color);
    return this;
  }

  LineElementBound<VT> strokeBound(String color(BoundItem<VT> b)) {
    attrs.strokeBound(color);
    return this;
  }

  LineElementBound<VT> fill(String color) {
    attrs.fill(color);
    return this;
  }

  LineElementBound<VT> fillBound(String color(BoundItem<VT> b)) {
    attrs.fillBound(color);
    return this;
  }
}
