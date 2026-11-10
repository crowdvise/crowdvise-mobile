import 'package:crowdvise/features/landing/presentation/widgets/flip_text.dart';
import 'package:crowdvise/features/landing/presentation/widgets/halftone_horizon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child, {bool disableAnimations = false}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('FlipText', () {
    testWidgets('renders every word and settles at full opacity', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const FlipText(
            text: 'Know what customers think,',
            style: TextStyle(fontSize: 32),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final word in ['Know', 'what', 'customers', 'think,']) {
        expect(find.text(word), findsOneWidget);
      }

      final opacities = tester.widgetList<Opacity>(
        find.descendant(
          of: find.byType(FlipText),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacities, isNotEmpty);
      expect(opacities.every((o) => o.opacity == 1), isTrue);
    });

    testWidgets('renders plain text when animations are disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const FlipText(
            text: 'Know what customers think,',
            style: TextStyle(fontSize: 32),
          ),
          disableAnimations: true,
        ),
      );
      await tester.pump();

      expect(find.text('Know what customers think,'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(FlipText),
          matching: find.byType(Opacity),
        ),
        findsNothing,
      );
    });

    testWidgets('restarts the flip when the text changes', (tester) async {
      await tester.pumpWidget(
        _app(
          const FlipText(
            text: 'First phrase',
            style: TextStyle(fontSize: 32),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        _app(
          const FlipText(
            text: 'Second phrase',
            style: TextStyle(fontSize: 32),
          ),
        ),
      );
      await tester.pump();

      final opacities = tester.widgetList<Opacity>(
        find.descendant(
          of: find.byType(FlipText),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacities.any((o) => o.opacity < 1), isTrue);

      await tester.pumpAndSettle();
      expect(find.text('Second'), findsOneWidget);
    });
  });

  group('HalftoneHorizon', () {
    testWidgets('paints a non-interactive, repaint-bounded layer', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const SizedBox(
            width: 400,
            height: 300,
            child: HalftoneHorizon(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(HalftoneHorizon), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(HalftoneHorizon),
          matching: find.byType(IgnorePointer),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(HalftoneHorizon),
          matching: find.byType(RepaintBoundary),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(HalftoneHorizon),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });
  });
}
