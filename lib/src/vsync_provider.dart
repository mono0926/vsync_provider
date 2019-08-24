import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class VsyncProvider extends ValueDelegateWidget<GlobalKey>
    implements SingleChildCloneableWidget {
  VsyncProvider({
    Key key,
    this.child,
    this.isSingleTicker = true,
  }) : super(
          key: key,
          delegate: BuilderStateDelegate<GlobalKey>(
            (context) => isSingleTicker
                ? GlobalKey<_SingleTickerWidgetState>() as GlobalKey
                : GlobalKey<_TickerWidgetState>() as GlobalKey,
          ),
        );

  final Widget child;
  final bool isSingleTicker;

  @override
  Widget build(BuildContext context) {
    final delegate = this.delegate as BuilderStateDelegate<GlobalKey>;
    // Get TickerProvider from State.
    // Is it better to create TickerProvider on your own?
    final tickerKey = delegate.value;
    final child = Builder(
      builder: (context) {
        final tickerProvider = isSingleTicker
            ? tickerKey.currentState as TickerProvider
            : tickerKey.currentState as TickerProvider;
        return InheritedProvider<TickerProvider>(
          value: tickerProvider,
          updateShouldNotify: (_, __) => false,
          child: this.child,
        );
      },
    );
    return isSingleTicker
        ? _SingleTickerWidget(
            key: tickerKey,
            child: child,
          )
        : _TickerWidget(
            key: tickerKey,
            child: child,
          );
  }

  @override
  SingleChildCloneableWidget cloneWithChild(Widget child) {
    return VsyncProvider(
      key: key,
      child: child,
      isSingleTicker: isSingleTicker,
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
