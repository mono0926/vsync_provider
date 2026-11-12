import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class const VsyncProvider({
  super.key,
  super.child,
  final bool isSingleTicker = true,
}) extends SingleChildStatelessWidget {
  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return isSingleTicker
        ? _SingleTickerWidget(child: child)
        : _TickerWidget(child: child);
  }

  /// Thin wrapper of Provider.of
  static TickerProvider of(BuildContext context) {
    try {
      return Provider.of<TickerProvider>(context, listen: false);
    } catch (error) {
      throw FlutterError('''
        TickerProvider.of() called with a context that does not contain
        a Disposable of type TickerProvider.
        The context used was: $context
        Error: $error
        ''');
    }
  }
}

class const _SingleTickerWidget({
  super.child,
}) extends SingleChildStatefulWidget {
  @override
  State<_SingleTickerWidget> createState() => _SingleTickerWidgetState();
}

class _SingleTickerWidgetState()
    extends SingleChildState<_SingleTickerWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    _triggerTickerMutedUpdate(context);
    return Provider<TickerProvider>.value(
      value: this,
      child: child,
    );
  }
}

class const _TickerWidget({
  super.child,
}) extends SingleChildStatefulWidget {
  @override
  State<_TickerWidget> createState() => _TickerWidgetState();
}

class _TickerWidgetState()
    extends SingleChildState<_TickerWidget>
    with TickerProviderStateMixin {
  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    _triggerTickerMutedUpdate(context);
    return Provider<TickerProvider>.value(
      value: this,
      child: child,
    );
  }
}

void _triggerTickerMutedUpdate(BuildContext context) {
  TickerMode.valuesOf(context);
}
