import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

void main() {
  testWidgets('provides single ticker by default', (tester) async {
    late TickerProvider capturedVsync;
    await tester.pumpWidget(
      VsyncProvider(
        child: Builder(
          builder: (context) {
            capturedVsync = VsyncProvider.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final controller = AnimationController(
      vsync: capturedVsync,
      duration: const Duration(milliseconds: 100),
    )..forward();

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(controller.value, 1);
    controller.dispose();
  });

  testWidgets('provides multiple tickers when isSingleTicker is false', (
    tester,
  ) async {
    late TickerProvider capturedVsync;
    await tester.pumpWidget(
      VsyncProvider(
        isSingleTicker: false,
        child: Builder(
          builder: (context) {
            capturedVsync = context.read<TickerProvider>();
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final controller1 = AnimationController(
      vsync: capturedVsync,
      duration: const Duration(milliseconds: 100),
    )..forward();
    final controller2 = AnimationController(
      vsync: capturedVsync,
      duration: const Duration(milliseconds: 100),
    )..forward();

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(controller1.value, 1);
    expect(controller2.value, 1);
    controller1.dispose();
    controller2.dispose();
  });

  testWidgets('throws FlutterError when VsyncProvider is missing', (
    tester,
  ) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          capturedContext = context;
          return const SizedBox.shrink();
        },
      ),
    );

    expect(() => VsyncProvider.of(capturedContext), throwsFlutterError);
  });
}
