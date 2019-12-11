import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

class TickerPage extends StatelessWidget {
  const TickerPage._({Key key}) : super(key: key);

  static const routeName = '/ticker';

  static Widget withModel() {
    return MultiProvider(
      providers: [
        VsyncProvider(isSingleTicker: false),
        DisposableProvider(
          create: (context) => _Model(
            vsync: VsyncProvider.of(context),
          ),
        )
      ],
      child: const TickerPage._(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 88,
              icon: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: model.animation1,
              ),
              onPressed: model.toggle1,
            ),
            const SizedBox(height: 44),
            IconButton(
              iconSize: 88,
              icon: AnimatedIcon(
                icon: AnimatedIcons.view_list,
                progress: model.animation2,
              ),
              onPressed: model.toggle2,
            ),
          ],
        ),
      ),
    );
  }
}

class _Model implements Disposable {
  _Model({
    @required TickerProvider vsync,
  })  : _animationController1 = AnimationController(
          vsync: vsync,
          duration: Duration(milliseconds: 1000),
        ),
        _animationController2 = AnimationController(
          vsync: vsync,
          duration: Duration(milliseconds: 1000),
        );

  final AnimationController _animationController1;
  final AnimationController _animationController2;

  Animation<double> get animation1 => _animationController1;
  Animation<double> get animation2 => _animationController2;

  void toggle1() {
    _animationController1.isCompleted
        ? _animationController1.reverse()
        : _animationController1.forward();
  }

  void toggle2() {
    _animationController2.isCompleted
        ? _animationController2.reverse()
        : _animationController2.forward();
  }

  @override
  void dispose() {
    _animationController1.dispose();
    _animationController2.dispose();
  }
}
