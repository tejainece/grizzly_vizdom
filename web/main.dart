// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' hide Selection;
import 'package:vizzie_dom/vizzie_dom.dart';

void main() {
  selectedTest();
  bindingTest();
}

void selectedTest() {
  /* TODO
  final Selected head = select('#selected-tst')
      .setStyle('background-color', 'red')
      .selectAll('div')
      .setStyle('background-color', 'green');
  head.append('div').setStyle('background-color', 'blue');
  */
}

void bindingTest() {
  final data = <int>[10, 20, 30, 40];

  final Selection head =
      select('#binding-tst').style('height', '${(data.length * 7) + 2}px');

  final Binding<int> dataSel = head.selectAll('div').bind<int>(data);
  final BoundSelection modSelEnter = dataSel.enter('div').styles({
    'height': '5px',
    'background-color': 'blue',
    'border': '1px solid black',
    'margin': '2px 0px',
    'box-sizing': 'border-box'
  }).styleBound('width', (BoundElement<int> b) => '${b.data}px');
}
