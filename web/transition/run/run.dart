// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' hide Selection;
import 'package:grizzly_vizdom/grizzly_vizdom.dart';
import 'package:animation_builder/animation_builder.dart';

void main() {
  final anim = new AnimationBuilder().duration(2000).fillForwards()
    ..createAt(0.0).backgroundColor('green')
    ..createAt(1.0).backgroundColor('red');

  select('#root')
      .selectAll('div')
      .style('display', 'inline-block')
      .transition('anim1')
      /* .animate([
    {
      'backgroundColor': 'blue',
    },
    {
      'backgroundColor': 'red',
    }
  ], {
    'duration': 20000,
    'fill': 'forwards'
  });*/
      .animateWithBuilder(anim);
}
