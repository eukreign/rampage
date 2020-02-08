// Copyright (c) 2019 the Rampage Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'package:rampage_browser_interop/browser_interop.dart' as interop;
import 'package:rampage_html/html.dart';

import 'attribute.dart';
import 'child_node.dart';
import 'document.dart';
import 'node.dart';
import 'parent_node.dart';
import 'slotable.dart';

//-----------------------------------------------------------
// Element
//-----------------------------------------------------------

/// Browser implementation of [Element].
class ElementImpl<T extends interop.Element> extends NodeImpl<T>
    with ParentNodeImpl<T>, ChildNodeImpl<T>, SlotableImpl<T>
    implements Element {
  /// Creates an instance of [ElementImpl] from the [jsObject].
  ElementImpl.fromJsObject(T jsObject)
      : attributes = AttributeMap.fromJsObject(jsObject),
        super.fromJsObject(jsObject);

  @override
  String get tagName => jsObject.tagName;
  @override
  String get className => jsObject.className;
  @override
  set className(String value) => jsObject.className = value;

  @override
  String get id => jsObject.id;
  @override
  set id(String value) {
    jsObject.id = value;
  }

  @override
  final Map<String, String> attributes;

  @override
  String get slot => jsObject.slot;
  @override
  set slot(String value) {
    jsObject.slot = value;
  }

  @override
  ShadowRoot get shadowRoot {
    final value = jsObject.shadowRoot;

    return value != null ? ShadowRootImpl.safeFromJsObject(value) : null;
  }

  @override
  ShadowRoot attachShadow() => ShadowRootImpl.fromJsObject(
        jsObject.attachShadow(interop.ShadowRootInit(
          mode: 'open',
        )),
      );
}

//-----------------------------------------------------------
// HtmlElement
//-----------------------------------------------------------

/// Browser implementation of [HtmlElement].
class HtmlElementImpl<T extends interop.HtmlElement> extends ElementImpl<T>
    implements HtmlElement {
  /// Creates an instance of [HtmlElementImpl] from the [jsObject].
  HtmlElementImpl.fromJsObject(T jsObject) : super.fromJsObject(jsObject);

  @override
  String get innerText => jsObject.innerText;
  @override
  set innerText(String value) {
    jsObject.innerText = value;
  }
}

//-----------------------------------------------------------
// SlotElement
//-----------------------------------------------------------

/// Browser implementation of [SlotElement].
class SlotElementImpl extends HtmlElementImpl<interop.SlotElement>
    implements SlotElement {
  /// Create an instance of [SlotElementImpl].
  factory SlotElementImpl() => SlotElementImpl.fromJsObject(
        interop.window.document.createElement('slot') as interop.SlotElement,
      );

  /// Create an instance of [SlotElementImpl] from the [jsObject]
  SlotElementImpl.fromJsObject(interop.SlotElement jsObject)
      : super.fromJsObject(jsObject);

  /// Create an instance of [SlotElementImpl] from the [jsObject].
  ///
  /// This constructor should be used when its unclear if the [jsObject] has
  /// already been wrapped.
  factory SlotElementImpl.safeFromJsObject(interop.SlotElement jsObject) =>
      jsObject.dartObject as SlotElementImpl ??
      SlotElementImpl.fromJsObject(jsObject);

  @override
  String get name => jsObject.name;
  @override
  set name(String value) {
    jsObject.name = value;
  }

  @override
  Iterable<Element> assignedElements({bool flatten = false}) sync* {
    final assigned = jsObject.assignedElements(
      interop.AssignedNodeOptions(flatten: flatten),
    );

    for (final element in assigned) {
      yield safeElementFromJsObject(element);
    }
  }
}

//-----------------------------------------------------------
// TemplateElement
//-----------------------------------------------------------

/// Browser implementation of [TemplateElement].
class TemplateElementImpl extends HtmlElementImpl<interop.TemplateElement>
    implements TemplateElement {
  /// Create an instance of [SlotElementImpl].
  factory TemplateElementImpl() => TemplateElementImpl.fromJsObject(
        interop.window.document.createElement('template')
            as interop.TemplateElement,
      );

  /// Create an instance of [SlotElementImpl] from the [jsObject]
  TemplateElementImpl.fromJsObject(interop.TemplateElement jsObject)
      : super.fromJsObject(jsObject);

  /// Create an instance of [TemplateElementImpl] from the [jsObject].
  ///
  /// This constructor should be used when its unclear if the [jsObject] has
  /// already been wrapped.
  factory TemplateElementImpl.safeFromJsObject(
          interop.TemplateElement jsObject) =>
      jsObject.dartObject as TemplateElementImpl ??
      TemplateElementImpl.fromJsObject(jsObject);

  @override
  DocumentFragment get content => DocumentFragmentImpl.safeFromJsObject(
        jsObject.content,
      );
}

//-----------------------------------------------------------
// Additional HtmlElements
//-----------------------------------------------------------

/// Browser implementation of [BodyElement].
class BodyElementImpl extends HtmlElementImpl<interop.BodyElement>
    implements BodyElement {
  /// Create an instance of [BodyElementImpl].
  factory BodyElementImpl() => BodyElementImpl.fromJsObject(
        interop.window.document.createElement('body') as interop.BodyElement,
      );

  /// Create an instance of [BodyElementImpl] from the [jsObject]
  BodyElementImpl.fromJsObject(interop.BodyElement jsObject)
      : super.fromJsObject(jsObject);

  /// Create an instance of [BodyElementImpl] from the [jsObject].
  ///
  /// This constructor should be used when its unclear if the [jsObject] has
  /// already been wrapped.
  factory BodyElementImpl.safeFromJsObject(interop.BodyElement jsObject) =>
      jsObject.dartObject as BodyElementImpl ??
      BodyElementImpl.fromJsObject(jsObject);
}

/// Browser implementation of [DivElement].
class DivElementImpl extends HtmlElementImpl<interop.DivElement>
    implements DivElement {
  /// Create an instance of [DivElementImpl].
  factory DivElementImpl() => DivElementImpl.fromJsObject(
        interop.window.document.createElement('div') as interop.DivElement,
      );

  /// Create an instance of [DivElementImpl] from the [jsObject]
  DivElementImpl.fromJsObject(interop.DivElement jsObject)
      : super.fromJsObject(jsObject);

  /// Create an instance of [DivElementImpl] from the [jsObject].
  ///
  /// This constructor should be used when its unclear if the [jsObject] has
  /// already been wrapped.
  factory DivElementImpl.safeFromJsObject(interop.DivElement jsObject) =>
      jsObject.dartObject as DivElementImpl ??
      DivElementImpl.fromJsObject(jsObject);
}

//-----------------------------------------------------------
// Utility
//-----------------------------------------------------------

/// Creates an instance of [T] from the [jsObject].
///
/// Uses the [interop.Element.tagName] to determine the [Element] to construct.
T elementFromJsObject<T extends Element>(interop.Element jsObject) {
  switch (jsObject.tagName) {
    case 'DIV':
      return DivElementImpl.fromJsObject(jsObject as interop.DivElement) as T;
    case 'SLOT':
      return SlotElementImpl.fromJsObject(jsObject as interop.SlotElement) as T;
    case 'TEMPLATE':
      return TemplateElementImpl.fromJsObject(
        jsObject as interop.TemplateElement,
      ) as T;
    case 'BODY':
      return BodyElementImpl.fromJsObject(jsObject as interop.BodyElement) as T;
  }

  assert(false, 'Unknown element');
  return null;
}

/// Creates an instance of [T] from the [jsObject].
///
/// This function should be used when its unclear if the [jsObject] has already
/// has already been wrapped.
T safeElementFromJsObject<T extends Element>(interop.Element jsObject) =>
    jsObject.dartObject as T ?? elementFromJsObject<T>(jsObject);

/// Creates and [Element] from the given [tagName].
Element createElement(String tagName) =>
    safeElementFromJsObject(interop.window.document.createElement(tagName));
