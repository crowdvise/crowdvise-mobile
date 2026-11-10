import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/features/landing/presentation/data/landing_content.dart';
import 'package:crowdvise/features/landing/presentation/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    getIt.registerFactoryAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance(),
    );
  });

  testWidgets('platform carousel is a swipeable PageView', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: LandingScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.scrollUntilVisible(
      find.byType(PageView),
      200,
      scrollable: find
          .descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pump();

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text(LandingContent.stages[0].body), findsOneWidget);

    final pageWidth = tester.getSize(find.byType(PageView)).width;
    await tester.drag(find.byType(PageView), Offset(-pageWidth * 0.6, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text(LandingContent.stages[1].body), findsOneWidget);
  });
}
