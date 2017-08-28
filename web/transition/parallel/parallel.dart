// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' hide Selection;
import 'package:grizzly_vizdom/grizzly_vizdom.dart';
import 'package:animation_builder/animation_builder.dart';

AnimationBuilder bgColor(String start, String end, int duration,
    {int delay: 0, String fill: 'forwards', int iterations: 1}) {
  return new AnimationBuilder().duration(duration).delay(delay).fillForwards()
    ..createAt(0.0).backgroundColor(start)
    ..createAt(1.0).backgroundColor(end);
}

AnimationBuilder translateX(num start, num end, int duration,
    {int delay: 0, String fill: 'forwards', int iterations: 1}) {
  return new AnimationBuilder().duration(duration).delay(delay).fillForwards()
    ..createAt(0.0).translateX(start)
    ..createAt(1.0).translateX(end);
}

void main() {
  final animColor = bgColor('blue', 'red', 20000);
  final animTranslateX = translateX(0, 1000, 20000);

  select('#root')
      .selectAll('div')
      .style('display', 'inline-block')
      .transition('animColor')
      .animateWithBuilder(animColor)
      .transition('animTranslateX')
      .animateWithBuilder(animTranslateX);
}
