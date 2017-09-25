part of grizzly.vizdom.elements;

abstract class _CircleAttrBase implements _Base {
  _CircleAttrBase cx(num value) {
    selection.attr('cx', value.toString());
    return this;
  }

  _CircleAttrBase cy(num value) {
    selection.attr('cy', value.toString());
    return this;
  }

  _CircleAttrBase r(num value) {
    selection.attr('r', value.toString());
    return this;
  }

  _CircleAttrBase center(math.Point<num> center) {
    selection.attr('cx', center.x.toString());
    selection.attr('cy', center.y.toString());
    return this;
  }
}

class CircleAttr extends ElementAttr with _Base, _CircleAttrBase, _CommonSvgAttr {
  final Selected selection;

  CircleAttr(this.selection);

  CircleAttr cx(num value) => super.cx(value);

  CircleAttr cy(num value) => super.cy(value);

  CircleAttr r(num value) => super.r(value);

  CircleAttr center(math.Point<num> value) => super.center(value);

  CircleAttr stroke(String color) => super.stroke(color);

  CircleAttr fill(String color) => super.stroke(color);
}

class CircleElement extends Element with _Base {
  final Selected selection;

  CircleElement(this.selection);

  CircleAttr get attrs => new CircleAttr(selection);

  CircleElement cx(num value) {
    attrs.cx(value);
    return this;
  }

  CircleElement cy(num value) {
    attrs.cy(value);
    return this;
  }

  CircleElement r(num value) {
    attrs.r(value);
    return this;
  }

  CircleElement center(math.Point<num> value) {
    attrs.center(value);
    return this;
  }

  CircleElement stroke(String color) {
    attrs.stroke(color);
    return this;
  }

  CircleElement fill(String color) {
    attrs.fill(color);
    return this;
  }
}

class CircleAttrBound<VT> extends ElementAttr
    with _BaseBound<VT>, _CircleAttrBase
    implements CircleAttr {
  final BoundSelection<VT> selection;

  CircleAttrBound(this.selection);

  CircleAttrBound<VT> cx(num value) => super.cx(value);

  CircleAttrBound<VT> cxBound(num value(BoundItem<VT> b)) {
    selection.attrBound('cx', (BoundItem<VT> b) => value(b).toString());
    return this;
  }

  CircleAttrBound<VT> cy(num value) => super.cy(value);

  CircleAttrBound<VT> cyBound(num value(BoundItem<VT> b)) {
    selection.attrBound('cy', (BoundItem<VT> b) => value(b).toString());
    return this;
  }

  CircleAttrBound<VT> r(num value) => super.r(value);

  CircleAttrBound<VT> rBound(num value(BoundItem<VT> b)) {
    selection.attrBound('r', (BoundItem<VT> b) => value(b).toString());
    return this;
  }

  CircleAttrBound<VT> center(math.Point<num> value) => super.center(value);

  CircleAttrBound<VT> centerBound(math.Point<num> value(BoundItem<VT> b)) {
    selection.attrsMapBound((BoundItem<VT> b) {
      final math.Point<num> map = value(b);
      return {
        'cx': map.x.toString(),
        'cy': map.y.toString(),
      };
    });
    return this;
  }

  CircleAttrBound<VT> stroke(String color) => super.stroke(color);

  CircleAttrBound<VT> strokeBound(String color(BoundItem<VT> b)) {
    selection.attrBound('stroke', color);
    return this;
  }

  CircleAttrBound<VT> fill(String color) => super.fill(color);

  CircleAttrBound<VT> fillBound(String color(BoundItem<VT> b)) {
    selection.attrBound('fill', color);
    return this;
  }
}

class CircleElementBound<VT> extends Element
    with _BaseBound<VT>
    implements CircleElement {
  final BoundSelection<VT> selection;

  CircleElementBound(this.selection)
      : attrs = new CircleAttrBound<VT>(selection);

  final CircleAttrBound<VT> attrs;

  CircleElementBound<VT> cx(num value) {
    attrs.cx(value);
    return this;
  }

  CircleElementBound<VT> cxBound(num value(BoundItem<VT> b)) {
    attrs.cxBound(value);
    return this;
  }

  CircleElementBound<VT> cy(num value) {
    attrs.cy(value);
    return this;
  }

  CircleElementBound<VT> cyBound(num value(BoundItem<VT> b)) {
    attrs.cyBound(value);
    return this;
  }

  CircleElementBound<VT> r(num value) {
    attrs.r(value);
    return this;
  }

  CircleElementBound<VT> rBound(num value(BoundItem<VT> b)) {
    attrs.rBound(value);
    return this;
  }

  CircleElementBound<VT> center(math.Point<num> value) {
    attrs.center(value);
    return this;
  }

  CircleElementBound<VT> centerBound(math.Point<num> value(BoundItem<VT> b)) {
    attrs.centerBound(value);
    return this;
  }

  CircleElementBound<VT> stroke(String color) {
    attrs.stroke(color);
    return this;
  }

  CircleElementBound<VT> strokeBound(String color(BoundItem<VT> b)) {
    attrs.strokeBound(color);
    return this;
  }

  CircleElementBound<VT> fill(String color) {
    attrs.fill(color);
    return this;
  }

  CircleElementBound<VT> fillBound(String color(BoundItem<VT> b)) {
    attrs.fillBound(color);
    return this;
  }
}
