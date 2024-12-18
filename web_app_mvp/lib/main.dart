import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

late PackageInfo packageInfo;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  packageInfo = await PackageInfo.fromPlatform();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Вітаємо в Hlibnytsia'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initializeAndExpand();
  }

  Future<void> initializeAndExpand() async {
    if (!isSupported) {
      return await Future.delayed(Duration(seconds: 1), initializeAndExpand);
    }

    setState(() {
      TelegramWebApp.instance.ready();
      TelegramWebApp.instance.expand();
    });
  }

  bool get isSupported => TelegramWebApp.instance.isSupported;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: isSupported
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('v$version($buildNumber)'),
                  Text(
                      'Привіт ${TelegramWebApp.instance.initData.user.firstname} ${TelegramWebApp.instance.initData.user.lastname}'),
                  Text('@${TelegramWebApp.instance.initData.user.username}'),
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Telegram Web App is loading'),
                  SizedBox(height: 16),
                  CircularProgressIndicator.adaptive()
                ],
              ),
      ),
      floatingActionButton: isSupported
          ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
