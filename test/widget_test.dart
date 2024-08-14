import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:dalgeurak/main.dart';
import 'package:dalgeurak/controllers/notification_controller.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // NotificationController 인스턴스를 생성하거나 mock으로 대체
    NotificationController notiController = Get.put(NotificationController());

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(notiController: notiController));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
