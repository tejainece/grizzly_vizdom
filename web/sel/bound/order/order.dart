// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:html' hide Selection;
import 'package:grizzly_vizdom/grizzly_vizdom.dart';

void main() {
  select('#root')
      .selectAll('div')
      .bindMap<int>(new LinkedHashMap<String, int>.fromIterable([50, 80, 20],
          key: (int i) => i.toString()))
      .enter('div')
      .styles({
    'margin': '2px',
    'box-sizing': 'border-box',
    'display': 'inline-block',
    'padding': '5px',
    'background-color': '#E6E6E6',
  }).textBound((BoundItem<int> b) => b.data);

  select('#root').selectAll('div').bindMap<int>(
      new LinkedHashMap<String, int>.fromIterable([10, 20, 40, 50, 70, 80, 100],
          key: (int i) => i.toString()))
    ..exit().remove()
    ..enter('div').styles({
      'margin': '2px',
      'box-sizing': 'border-box',
      'display': 'inline-block',
      'padding': '5px',
      'background-color': '#E6E6E6',
    })
    ..merge().textBound((BoundItem<int> b) => b.data)
    .order();
}
