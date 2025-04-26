// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:product_crud_app/main.dart';

void main() {
  testWidgets('Product app loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProductApp());

    // Verify that the home screen loads by checking for 'PRODUCTS' title.
    expect(find.text('PRODUCTS'), findsOneWidget);
  });
}
