import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class VsyncProvider extends SingleChildStatelessWidget {
  const VsyncProvider({
    Key key,
    Widget child,
    this.isSingleTicker = true,
  }) : super(key: key, child: child);

  final bool isSingleTicker;

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return _TickerWidget(
      isSingleTicker: isSingleTicker,
      child: child,
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

class _TickerWidget extends SingleChildStatefulWidget {
  const _TickerWidget({
    Key key,
    @required this.isSingleTicker,
    Widget child,
  }) : super(key: key, child: child);

  final bool isSingleTicker;

  @override
  State createState() =>
      isSingleTicker ? _SingleTickerWidgetState() : _TickerWidgetState();
}

class _SingleTickerWidgetState extends SingleChildState<_TickerWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return Provider<TickerProvider>.value(
      value: this,
      child: child,
    );
  }
}

class _TickerWidgetState extends SingleChildState<_TickerWidget>
    with TickerProviderStateMixin {
  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return Provider<TickerProvider>.value(
      value: this,
      child: child,
    );
  }
}
