library grizzly.viz.shape.axis;

import 'dart:math' as math;
import 'package:grizzly_viz_scales/grizzly_viz_scales.dart';
import 'package:grizzly_viz_shape/grizzly_viz_shape.dart';
import 'package:grizzly_vizdom/grizzly_vizdom.dart';

class Orientation {
  final int id;

  final String name;

  const Orientation._(this.id, this.name);

  String toString() => name;

  static const Orientation top = const Orientation._(1, 'top');

  static const Orientation right = const Orientation._(1, 'right');

  static const Orientation bottom = const Orientation._(1, 'bottom');

  static const Orientation left = const Orientation._(1, 'left');
}

class AxisProperties {
  final Orientation orient;

  final num tickSizeInner = 6;

  final num tickSizeOuter = 6;

  final num tickPadding = 3;

  final double startRangePad;

  final double endRangePad;

  const AxisProperties(
      {this.orient: Orientation.bottom,
      this.startRangePad: 0.5,
      this.endRangePad: 0.5});

  const AxisProperties.top({this.startRangePad: 0.5, this.endRangePad: 0.5})
      : orient = Orientation.top;

  const AxisProperties.bottom({this.startRangePad: 0.5, this.endRangePad: 0.5})
		  : orient = Orientation.bottom;

  const AxisProperties.left({this.startRangePad: 0.5, this.endRangePad: 0.5})
      : orient = Orientation.left;

  const AxisProperties.right({this.startRangePad: 0.5, this.endRangePad: 0.5})
      : orient = Orientation.right;

  num get spacing => math.max(tickSizeInner, 0) + tickPadding;

  num get k => orient == Orientation.top || orient == Orientation.left ? -1 : 1;

  bool get isHorizontal =>
      orient == Orientation.left || orient == Orientation.right;

  String transform(num v) =>
      orient == Orientation.top || orient == Orientation.bottom
          ? 'translate(${v + 0.5}, 0)'
          : 'translate(0, ${v + 0.5})';
}

/* TODO
class Axis {
  final AxisProperties properties;

  final Scale<dynamic, double> scale;

  Axis(this.scale, {this.properties: const AxisProperties()});

  Axis.top(this.scale, {this.properties: const AxisProperties.top()});

  Axis.right(this.scale, {this.properties: const AxisProperties.right()});

  Axis.bottom(this.scale, {this.properties: const AxisProperties.bottom()});

  Axis.left(this.scale, {this.properties: const AxisProperties.left()});

  render(Selected sel) {
    final num range0 = scale.range.first + properties.startRangePad;
    final num range1 = scale.range.last + properties.endRangePad;

    final tick = sel.selectAll('.tick').bindKeyed<num>(); //TODO order
    final tickExit = tick.exit();

    final tickEnter = tick.enter('g').clazz('tick');
    if (properties.isHorizontal) {
      tickEnter
          .append('line')
          .asLine()
          .x2(properties.k * properties.tickSizeInner)
          .stroke('#000');
    } else {
      tickEnter
          .append('line')
          .asLine()
          .y2(properties.k * properties.tickSizeInner)
          .stroke('#000');
    }
    tickEnter.append("text").asText().fill("#000").x(k * properties.spacing);
    //TODO .attr("dy", orient === top ? "0em" : orient === bottom ? "0.71em" : "0.32em"));

    final tickMerged = tick.merge();
    final tickLine = tickMerged.select('line').asLine();
    final tickText = tickMerged.select('text').asText();

    final Binding<Null> path = sel.selectAll('.domain').bind([null]);
    path.enter('path', '.tick').clazz('domain').asLine().stroke('#000');
    final pathMerged = path.merge();

    //TODO handle transition

    tickExit.remove();

    if (properties.isHorizontal) {
      final pathCtx = new SvgPathBuilder()
          .moveTo(properties.k * properties.tickSizeOuter, range0)
          .h(0.5)
          .v(range1)
          .h(properties.k * properties.tickSizeOuter);
      pathMerged.attr('d', pathCtx.end());
    } else {
      final pathCtx = new SvgPathBuilder()
          .moveTo(range0, properties.k * properties.tickSizeOuter)
          .v(0.5)
          .h(range1)
          .v(properties.k * properties.tickSizeOuter);
      pathMerged.attr('d', pathCtx.end());
    }

    tickMerged
        .attr('opacity', '1')
        .attrBound('transform', (BoundItem<num> b) => position(b).toString());

    if (properties.isHorizontal) {
      tickLine.x2(properties.k * properties.tickSizeInner);
      tickText.x(properties.k * properties.spacing);
    } else {
      tickLine.y2(properties.k * properties.tickSizeInner);
      tickText.y(properties.k * properties.spacing);
    }

    //TODO set text tickText.text(format);

    //TODO
  }
}

class SvgPathBuilder {
  StringBuffer _sb;

  SvgPathBuilder();

  SvgPathBuilder begin() {
    _sb = new StringBuffer();
    return this;
  }

  String end() {
    final ret = _sb.toString();
    _sb = null;
    return ret;
  }

  SvgPathBuilder moveTo(num x, num y) {
    _sb.write('M $x $y');
    return this;
  }

  SvgPathBuilder lineTo(num x, num y) {
    _sb.write('L $x $y');
    return this;
  }

  SvgPathBuilder h(num x) {
    _sb.write('H $x');
    return this;
  }

  SvgPathBuilder v(num y) {
    _sb.write('V $y');
    return this;
  }
}
*/