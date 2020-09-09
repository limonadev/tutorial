import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

void main() {
  AssetTestStore.testAssets = [
    'assets/simple.json',
  ];
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      print('${record.error}');
    }
    if (record.stackTrace != null) {
      print('${record.stackTrace}');
    }
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  TestController _testController;
  UniqueKey _uniqueKey;

  Future<void> _onReset() async {
    while (_navigatorKey.currentState?.canPop() == true) {
      _navigatorKey.currentState.pop();
    }
    _uniqueKey = UniqueKey();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _testController = TestController(
      navigatorKey: _navigatorKey,
      onReset: _onReset,
      testReader: AssetTestStore.testReader,
    );

    _runTests();
  }

  Future<void> _runTests() async {
    /*
    var tests = await _testController.loadTests(context);
    await _testController.runPendingTests(tests);
    */
    print('Starting delay... Please press the button before the time ends.');
    await Future<dynamic>.delayed(Duration(seconds: 5));
    setState(() {
      _uniqueKey = UniqueKey();
    });
    print('Has been the screen reloaded?');
  }

  @override
  Widget build(BuildContext context) {
    return TestRunner(
      controller: _testController,
      child: MaterialApp(
        key: _uniqueKey,
        navigatorKey: _navigatorKey,
        title: 'Automated Testing Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Testable(
              id: 'text_value',
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Testable(
        id: 'fab',
        child: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
