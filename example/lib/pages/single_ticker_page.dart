import 'package:disposable_provider/disposable_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

class const SingleTickerPage._() extends StatelessWidget {
  static const routeName = '/single_ticker';

  static Widget withModel() {
    return MultiProvider(
      providers: [
        const VsyncProvider(),
        DisposableProvider(
          create: (context) => _Model(
            vsync: VsyncProvider.of(context),
          ),
        ),
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

class _Model({
  required TickerProvider vsync,
}) implements Disposable {
  final AnimationController _animationController = AnimationController(
    vsync: vsync,
    duration: const Duration(milliseconds: 1000),
  );

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
