// Copyright (c) 2019 the Rampage Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'package:rampage_browser_interop/browser_interop.dart' as interop;
import 'package:rampage_html/html.dart';

import 'element.dart';
import 'js_wrapper.dart';

//-----------------------------------------------------------
// Node
//-----------------------------------------------------------

/// Browser implementation of [Node].
class NodeImpl<T extends interop.Node> extends JsWrapper<T> implements Node {
  /// Create an instance of [NodeImpl] from the [jsObject].
  NodeImpl.fromJsObject(T jsObject) : super.fromJsObject(jsObject);

  @override
  bool get isConnected => jsObject.isConnected;
}

//-----------------------------------------------------------
// ParentNode
//-----------------------------------------------------------

/// Browser implementation of [ParentNode].
mixin ParentNodeImpl<T extends interop.ParentNode> on NodeImpl<T>
    implements ParentNode {
  @override
  T querySelector<T extends Element>(String selectors) =>
      safeElementFromJsObject<T>(jsObject.querySelector(selectors));

  @override
  Iterable<T> querySelectorAll<T extends Element>(String selectors) sync* {
    final result = jsObject.querySelectorAll(selectors);
    final count = result.length;

    for (var i = 0; i < count; ++i) {
      yield safeElementFromJsObject<T>(result.item(i) as interop.Element);
    }
  }
}
