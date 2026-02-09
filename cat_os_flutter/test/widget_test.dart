import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:cat_os_flutter/app.dart";

void main() {
  testWidgets("CAT.AI boots to single-screen cat UI", (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const CatOsApp());
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text("CAT.AI"), findsNothing);
  });
}
