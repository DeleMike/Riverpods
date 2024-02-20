import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Go!'),
        ),
      ),
    );
  }
}

Future<void> runTest() async {
  OrtEnv.instance.init();

  final sessionOptions = OrtSessionOptions();
  const assetFileName = 'assets/models/test.onnx';
  final rawAssetFile = await rootBundle.load(assetFileName);
  final bytes = rawAssetFile.buffer.asUint8List();
  final session = OrtSession.fromBuffer(bytes, sessionOptions);

  final shape = [1, 2, 3];
  final inputOrt = OrtValueTensor.createTensorWithDataList(data, shape);
  final inputs = {'input': inputOrt};
  final runOptions = OrtRunOptions();
  final outputs = await session?.runAsync(runOptions, inputs);
  inputOrt.release();
  runOptions.release();
  outputs?.forEach((element) {
    element?.release();
  });
}
