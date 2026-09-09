---
name: vsync_provider-animation
description: >-
  Use when supplying TickerProvider to AnimationController instances in Flutter widget subtrees
  without writing boilerplate StatefulWidget and SingleTickerProviderStateMixin classes using vsync_provider.
---

# vsync_provider Animation Ticker Guide

`vsync_provider` provides a `TickerProvider` to descendant Flutter widgets using `package:provider`. This allows developers to initialize `AnimationController`s cleanly without creating boilerplate `StatefulWidget`s mixed with `SingleTickerProviderStateMixin`.

## Guidelines

- **Mounting the Provider**:
  - Wrap the animated section with `VsyncProvider(child: ...)`.
  - By default, `isSingleTicker: true` is used (wrapping `SingleTickerProviderStateMixin`). If multiple concurrent animations require separate tickers within the same subtree, set `isSingleTicker: false`.
- **Retrieving the Ticker**:
  - Inside descendant builder callbacks or child widgets, retrieve the ticker using `VsyncProvider.of(context)` (or `context.read<TickerProvider>()`).
- **Instantiating Animation Controllers**:
  - Pass the retrieved `TickerProvider` to `AnimationController(vsync: ticker, duration: ...)`.
  - Ensure the created `AnimationController` is disposed when its lifecycle ends (for example, combining it with `DisposableProvider` or `ProxyProvider`).

## Examples

### 1. Providing Ticker to AnimationController via MultiProvider

```dart
import 'package:disposable_provider/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

class FadeAnimationController implements Disposable {
  FadeAnimationController({required TickerProvider vsync})
      : animationController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 500),
        );

  final AnimationController animationController;

  void play() => animationController.forward();

  @override
  void dispose() {
    animationController.dispose();
  }
}

class AnimatedScreen extends StatelessWidget {
  const AnimatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        const VsyncProvider(),
        DisposableProvider<FadeAnimationController>(
          create: (context) => FadeAnimationController(
            vsync: VsyncProvider.of(context),
          )..play(),
        ),
      ],
      child: const _AnimatedBody(),
    );
  }
}

class _AnimatedBody extends StatelessWidget {
  const _AnimatedBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FadeAnimationController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ticker Animation')),
      body: Center(
        child: FadeTransition(
          opacity: controller.animationController,
          child: const FlutterLogo(size: 100),
        ),
      ),
    );
  }
}
```

## Common Pitfalls & Anti-Patterns

- ❌ **Anti-pattern**: Attempting to initialize multiple `AnimationController`s using `isSingleTicker: true` (which triggers Flutter's runtime single-ticker assertion).
  - ✔️ **Correct**: Set `VsyncProvider(isSingleTicker: false)` when managing multiple tickers within the same subtree.
- ❌ **Anti-pattern**: Creating `AnimationController` without disposing it.
  - ✔️ **Correct**: Always pair `AnimationController` with a disposal mechanism (e.g. `DisposableProvider` or an enclosing `StatefulWidget`).
