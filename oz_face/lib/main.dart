import 'package:flutter/material.dart';
import 'package:ozsdk/ozsdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OzApp(),
    );
  }
}

class OzApp extends StatelessWidget {
  const OzApp({super.key});

  _init() async {
    final isInitialised =
        await OZSDK.initSDK(['assets/forensics.license']);
        
    print('isInit = $isInitialised');
  }

  _startWork() async {
    List<Analysis> analysis = [
      Analysis(Type.quality, Mode.onDevice, [], {}),
    ];

    final analysisResult = await OZSDK.analyze(analysis, [], {});

    print('analysisResult = $analysisResult');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Comparison'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _init();
              },
              child: const Text('hit me'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _startWork();
              },
              child: const Text('start camera'),
            ),
          ],
        ),
      ),
    );
  }
}
