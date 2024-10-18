// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/ctor_args.dart';
import 'package:app/primitive/events.dart';
import 'package:app/primitive/pkey.dart';
import 'package:app/primitive/primitive_base.dart';
import 'package:app/primitive/primitive.dart';
import 'package:app/primitive/command.dart';
import 'package:cbor/cbor.dart';
import 'package:test/test.dart';
import 'test_primitive.dart';
import 'test_primitive_impl.dart';
import 'test_cbor_samples.dart';

void main() {
  test('Fields are initialized properly.', () {
    var parentPrimitive = TestPrimitive();
    var pkey = PKey.addIndex(PKey.empty(), 5);
    var cbor = CborMap({
      CborString('Label'): CborString('Purple'),
    });

    void eventHandler(EventType eventType, PKey pkey, CborMap fieldUpdates) {}

    var ctorArgs = CtorArgs.once(parentPrimitive, eventHandler, cbor, pkey);

    var tpi = TestPrimitiveImpl(ctorArgs);

    expect(tpi.parent, equals(parentPrimitive));
    expect(tpi.pkey.indices, equals(pkey.indices));
    expect(tpi.eventHandler, equals(eventHandler));
    expect(tpi.label, equals('Purple'));
  });

  test('Does notify.', () {
    var parentPrimitive = TestPrimitive();
    var pkey = PKey.addIndex(PKey.empty(), 5);
    var cbor = cborEmpty();

    void eventHandler(EventType eventType, PKey pkey, CborMap fieldUpdates) {}
    var ctorArgs = CtorArgs.once(parentPrimitive, eventHandler, cbor, pkey);
    var tpi = TestPrimitveImplDoesNotify(ctorArgs);
    var listenable1 = tpi.doesNotify();

    expect(listenable1, isNotNull);
    expect(tpi.notifier, isNotNull);

    var wasNotified = false;

    listenable1!.addListener(() => wasNotified = true);

    var listenable2 = tpi.doesNotify(notifyNow: true);

    expect(listenable2, equals(listenable1));
    expect(wasNotified, equals(true));
  });

  test('Does not notify.', () {
    void eventHandler(EventType eventType, PKey pkey, CborMap fieldUpdates) {}

    // Build root primitive
    var root = TestPrimitive();

    // Build Grandma primitive
    var grandmaPkey = PKey.addIndex(PKey.empty(), 0);
    var grandmaArgs =
        CtorArgs.once(root, eventHandler, cborEmpty(), grandmaPkey);
    var grandma = TestPrimitveImplDoesNotify(grandmaArgs);

    // Build Ma primitive
    var maPkey = PKey.addIndex(grandmaPkey, 0);
    var maArgs = CtorArgs.once(grandma, eventHandler, cborEmpty(), maPkey);
    var ma = TestPrimitiveImpl(maArgs);

    // Build kid primitive
    var kidPkey = PKey.addIndex(maPkey, 0);
    var kidArgs = CtorArgs.once(ma, eventHandler, cborEmpty(), kidPkey);
    var kid = TestPrimitiveImpl(kidArgs);

    // Grandma does notify when kid's field gets updated
    var gmaListenable = grandma.doesNotify();
    expect(gmaListenable, isNotNull);

    var gmaNotified = false;
    gmaListenable!.addListener(() => gmaNotified = true);

    // Updating a field of the kid should cause grandma to notify
    var cbor = CborMap({
      CborString('Label'): CborString('Mom'),
    });

    kid.updateFromCbor(cbor);

    expect(gmaNotified, equals(true));
  });

  test('Get parent.', () {
    var parentPrimitive = TestPrimitive();
    var pkey = PKey.addIndex(PKey.empty(), 5);
    void eventHandler(EventType eventType, PKey pkey, CborMap fieldUpdates) {}
    var ctorArgs =
        CtorArgs.once(parentPrimitive, eventHandler, cborEmpty(), pkey);
    var tpi = TestPrimitiveImpl(ctorArgs);

    expect(tpi.getParent(), equals(parentPrimitive));
  });

  test('Locate next descendant.', () {
    var parentPrimitive = TestPrimitive();
    var pkey = PKey.addIndex(PKey.empty(), 5);
    void eventHandler(EventType eventType, PKey pkey, CborMap fieldUpdates) {}
    var ctorArgs =
        CtorArgs.once(parentPrimitive, eventHandler, cborEmpty(), pkey);
    var tpi = TestPrimitveImplWithDescendant(ctorArgs);

    var locator = PKeyLocator(pkey);
    var descendant = tpi.locateNextDescendant(locator);

    expect(descendant, equals(tpi.child));
    expect(locator.located(), isTrue);
  });

  void verify1DPrimitive(List<Primitive> items, int fieldPKeyIndex, int index) {
    var p = items[index];

    expect(p, const TypeMatcher<Command>());
    var pbase = p as PrimitiveBase;
    var expectedPkey =
        PKey.empty().addIndex(5).addIndex(fieldPKeyIndex).addIndex(index);

    expect(pbase.pkey.indices, equals(expectedPkey.indices));
  }

  test('Create primitive from CBOR list 1D.', () {
    var parentPrimitive = TestPrimitive();
    var pkey = PKey.addIndex(PKey.empty(), 5);
    void eventHandler(EventType eventType, PKey pkey, CborMap fieldUpdates) {}
    var ctorArgs =
        CtorArgs.once(parentPrimitive, eventHandler, cborEmpty(), pkey);
    var tpi = TestPrimitveImplWithDescendant(ctorArgs);

    var items = tpi.createPrimitivesFromCborList1D(cborForAny1DField(), 3);

    expect(items.length, equals(2));
    verify1DPrimitive(items, 3, 0);
    verify1DPrimitive(items, 3, 1);
  });

  void verify2DPrimitive(
      List<List<Primitive>> rows, int fieldPKeyIndex, int row, int col) {
    var p = rows[row][col];

    expect(p, const TypeMatcher<Command>());
    var pbase = p as PrimitiveBase;
    var expectedPkey = PKey.empty()
        .addIndex(5)
        .addIndex(fieldPKeyIndex)
        .addIndex(row)
        .addIndex(col);

    expect(pbase.pkey.indices, equals(expectedPkey.indices));
  }

  test('Create primitive from CBOR list 2D.', () {
    var parentPrimitive = TestPrimitive();
    var pkey = PKey.addIndex(PKey.empty(), 5);
    void eventHandler(EventType eventType, PKey pkey, CborMap fieldUpdates) {}
    var ctorArgs =
        CtorArgs.once(parentPrimitive, eventHandler, cborEmpty(), pkey);
    var tpi = TestPrimitveImplWithDescendant(ctorArgs);

    var rows = tpi.createPrimitivesFromCborList2D(cborForAny2DField(), 3);

    expect(rows.length, equals(2));
    expect(rows[0].length, equals(2));
    expect(rows[1].length, equals(2));
    verify2DPrimitive(rows, 3, 0, 0);
    verify2DPrimitive(rows, 3, 0, 1);
    verify2DPrimitive(rows, 3, 1, 0);
    verify2DPrimitive(rows, 3, 1, 1);
  });

  TestPrimitiveImpl setupGetEmbodimentPropertiesTest() {
    var parentPrimitive = TestPrimitive();
    var pkey = PKey.addIndex(PKey.empty(), 5);
    void eventHandler(EventType eventType, PKey pkey, CborMap fieldUpdates) {}
    var ctorArgs =
        CtorArgs.once(parentPrimitive, eventHandler, cborEmpty(), pkey);
    return TestPrimitiveImpl(ctorArgs);
  }

  test('Get embodiment properties:  empty embodiment yields null.', () {
    var tp = setupGetEmbodimentPropertiesTest();
    tp.updateFromCbor(cborForEmptyEmbodiment());
    expect(tp.getEmbodimentProperties(), isNull);
  });

  test(
      'Get embodiment properties:  empty embodiment with whitespace yields null map.',
      () {
    var tp = setupGetEmbodimentPropertiesTest();
    tp.updateFromCbor(cborForEmptyWhitespaceEmbodiment());
    expect(tp.getEmbodimentProperties(), isNull);
  });

  test(
      'Get embodiment properties:  simple embodiment yields a map with embodiment value.',
      () {
    var tp = setupGetEmbodimentPropertiesTest();
    tp.updateFromCbor(cborForSimplifiedEmbodiment());
    var m = tp.getEmbodimentProperties();
    expect(m, isNotNull);
    expect(m!['embodiment'] as String, equals('down-and-dirty'));
  });

  test(
      'Get embodiment properties:  complex embodiment yields a map with several properties.',
      () {
    var tp = setupGetEmbodimentPropertiesTest();
    tp.updateFromCbor(cborForComplexEmbodiment());
    var m = tp.getEmbodimentProperties();
    expect(m, isNotNull);
    expect(m!['embodiment'] as String, equals('fancy-look-and-feel'));
    expect(m['layoutMethod'] as String, equals('flow'));
    expect(m['flowDirection'] as String, equals('LTR'));
  });

  test('Get embodiment properties:  reassign embodiment yields correct map.',
      () {
    var tp = setupGetEmbodimentPropertiesTest();
    tp.updateFromCbor(cborForComplexEmbodiment());
    tp.updateFromCbor(cborForSimplifiedEmbodiment());
    var m = tp.getEmbodimentProperties();
    expect(m!.length, equals(1));
    expect(m['embodiment'] as String, equals('down-and-dirty'));
  });

  test('Get embodiment properties:  reassign empty embodiment yields null map.',
      () {
    var tp = setupGetEmbodimentPropertiesTest();
    tp.updateFromCbor(cborForComplexEmbodiment());
    tp.updateFromCbor(cborForSimplifiedEmbodiment());
    var m = tp.getEmbodimentProperties();
    expect(m!.length, equals(1));
    expect(m['embodiment'] as String, equals('down-and-dirty'));
  });

  test(
      'convertSimplifiedKVPairsToJson converts valid simplified key:value pairs to JSON',
      () {
    var simplified = 'key1:value1,key2:value2,key3:value3';
    var expectedJson = '{"key1":"value1","key2":"value2","key3":"value3"}';

    var result = convertSimplifiedKVPairsToJson(simplified);

    expect(result, equals(expectedJson));
  });

  test(
      'convertSimplifiedKVPairsToJson throws exception for invalid key:value pairs',
      () {
    var invalidSimplified = 'key1:value1,key2value2,key3:value3';

    expect(() => convertSimplifiedKVPairsToJson(invalidSimplified),
        throwsException);
  });

  test('convertSimplifiedKVPairsToJson handles whitespace correctly', () {
    var simplified = ' key1 : value1 , key2 : value2 , key3 : value3 ';
    var expectedJson = '{"key1":"value1","key2":"value2","key3":"value3"}';

    var result = convertSimplifiedKVPairsToJson(simplified);

    expect(result, equals(expectedJson));
  });
}
