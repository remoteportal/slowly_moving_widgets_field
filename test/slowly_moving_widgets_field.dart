import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slowly_moving_widgets_field/slowly_moving_widgets_field.dart';

// https://flutter.dev/docs/cookbook/testing/widget/introduction#3-create-a-testwidgets-test

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('test the thing!', (WidgetTester tester) async {
    await tester.pumpWidget(Directionality(
        child: SlowlyMovingWidgetsField(), textDirection: TextDirection.ltr));
  });
}
