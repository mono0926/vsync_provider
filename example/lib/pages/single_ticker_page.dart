import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

class SingleTickerPage extends StatelessWidget {
  const SingleTickerPage._({Key key}) : super(key: key);

  static const routeName = '/single_ticker';

  static Widget withModel() {
    return MultiProvider(
      providers: [
        const VsyncProvider(),
        DisposableProvider(
          create: (context) => _Model(
            vsync: VsyncProvider.of(context),
          ),
        )
      ],
      child: const SingleTickerPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<_Model>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(routeName),
      ),
      body: Center(
        child: IconButton(
          iconSize: 88,
          icon: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: model.animation,
          ),
          onPressed: model.toggle,
        ),
      ),
    );
  }
}

class _Model implements Disposable {
  _Model({
    @required TickerProvider vsync,
  }) : _animationController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 1000),
        );

  final AnimationController _animationController;

  Animation<double> get animation => _animationController;

  void toggle() {
    _animationController.isCompleted
        ? _animationController.reverse()
        : _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
  }
}
