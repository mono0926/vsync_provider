import 'package:flutter/material.dart';

import 'pages/single_ticker_page.dart';
import 'pages/ticker_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const _HomePage(),
      routes: {
        SingleTickerPage.routeName: (context) => SingleTickerPage.withVsync(),
        TickerPage.routeName: (context) => TickerPage.withVsync(),
      },
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VsyncProvider'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('SingleTicker'),
            trailing: Icon(Icons.chevron_right),
            onTap: () =>
                Navigator.of(context).pushNamed(SingleTickerPage.routeName),
          ),
          ListTile(
            title: const Text('Ticker'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(TickerPage.routeName),
          )
        ],
      ),
    );
  }
}
