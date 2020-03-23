import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

class MuteFeaturePage extends StatelessWidget {
  const MuteFeaturePage._({Key key}) : super(key: key);

  static const routeName = '/mute_feature';

  static Widget withModel() {
    return MultiProvider(
      providers: [
        VsyncProvider(),
        DisposableProvider(
          create: (context) => _Model(
            vsync: VsyncProvider.of(context),
          ),
        )
      ],
      child: const MuteFeaturePage._(),
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
        child: RaisedButton(
          child: Text('Next Page'),
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(),
              ),
            ),
          ),
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
