// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' hide Selection;
import 'package:grizzly_vizdom/grizzly_vizdom.dart';
import 'package:animation_builder/animation_builder.dart';

void main() {
  final anim = new AnimationBuilder().duration(120000).fillForwards()
    ..createAt(0.0).translateX(0)
    ..createAt(1.0).translateX(1000);

  select('#root')
      .selectAll('div')
      .style('background-color', 'red')
      .transition('anim1')
      .animateWithBuilder(anim);

  querySelector('#btn-cancel').onClick.listen((_) {
    select('#root').selectAll('div').transition('anim1').cancel();
  });

  querySelector('#btn-start').onClick.listen((_) {
    select('#root')
        .selectAll('div')
        .transition('anim1')
        .animateWithBuilder(anim);
  });

  querySelector('#btn-reverse').onClick.listen((_) {
    select('#root').selectAll('div').transition('anim1').reverse();
  });

  querySelector('#btn-finish').onClick.listen((_) {
    select('#root').selectAll('div').transition('anim1').finish();
  });

  querySelector('#btn-pause').onClick.listen((_) {
    select('#root').selectAll('div').transition('anim1').pause();
  });

  querySelector('#btn-play').onClick.listen((_) {
    select('#root').selectAll('div').transition('anim1').play();
  });
}
