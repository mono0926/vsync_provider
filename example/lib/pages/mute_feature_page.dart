import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

class MuteFeaturePage extends StatelessWidget {
  const MuteFeaturePage._({Key? key}) : super(key: key);

  static const routeName = '/mute_feature';

  static Widget withModel() {
    return MultiProvider(
      providers: [
        const VsyncProvider(),
        DisposableProvider(
          create: (context) => _Controller(
            vsync: VsyncProvider.of(context),
          ),
        )
      ],
      child: const MuteFeaturePage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<_Controller>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(routeName),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'This value changes on this page, '
              'but after navigated to next page, '
              'the animation will be stopped.'
              '(See print log)',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: controller.animation,
              builder: (context, value) => Text(
                '${controller.animation.value.toStringAsFixed(3)}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Next Page'),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller implements Disposable {
  _Controller({
    required TickerProvider vsync,
  }) : _animationController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 10000),
        )..repeat() {
    _animationController.addListener(
      () => print('value: ${_animationController.value}'),
    );
  }

  final AnimationController _animationController;

  Animation<double> get animation => _animationController;

  @override
  void dispose() {
    _animationController.dispose();
  }
}
