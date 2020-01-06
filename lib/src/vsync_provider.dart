import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class VsyncProvider extends SingleChildStatelessWidget {
  VsyncProvider({
    Key key,
    Widget child,
    this.isSingleTicker = true,
  }) : super(key: key, child: child);

  final bool isSingleTicker;

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return Provider(
      create: (context) {
        return isSingleTicker
            ? GlobalKey<_SingleTickerWidgetState>() as GlobalKey
            : GlobalKey<_TickerWidgetState>() as GlobalKey;
      },
      child: Consumer<GlobalKey>(
        builder: (context, tickerKey, _child) {
          final provider = Builder(
            builder: (context) {
              return Provider<TickerProvider>.value(
                value: tickerKey.currentState as TickerProvider,
                updateShouldNotify: (_, __) => false,
                child: child,
              );
            },
          );
          return isSingleTicker
              ? _SingleTickerWidget(
                  key: tickerKey,
                  child: provider,
                )
              : _TickerWidget(
                  key: tickerKey,
                  child: provider,
                );
        },
      ),
    );
  }

  /// Thin wrapper of Provider.of
  static TickerProvider of(BuildContext context) {
    try {
      return Provider.of<TickerProvider>(context, listen: false);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      throw FlutterError(
        '''
        TickerProvider.of() called with a context that does not contain
        a Disposable of type TickerProvider.
        The context used was: $context
        Error: $error
        ''',
      );
    }
  }
}

class _SingleTickerWidget extends StatefulWidget {
  const _SingleTickerWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _SingleTickerWidgetState createState() => _SingleTickerWidgetState();
}

class _SingleTickerWidgetState extends State<_SingleTickerWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _TickerWidget extends StatefulWidget {
  const _TickerWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _TickerWidgetState createState() => _TickerWidgetState();
}

class _TickerWidgetState extends State<_TickerWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
