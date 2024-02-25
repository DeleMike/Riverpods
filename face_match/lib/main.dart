import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_compare/image_compare.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Comparison',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FaceComparisonScreen(),
    );
  }
}

class FaceComparisonScreen extends StatefulWidget {
  const FaceComparisonScreen({super.key});

  @override
  State<FaceComparisonScreen> createState() => _FaceComparisonScreenState();
}

class _FaceComparisonScreenState extends State<FaceComparisonScreen> {
  bool _facesMatch = false;
  bool _hasLoaded = false;

  // Helper function to calculate distance between two points
  double _calculateDistance(Point<int> point1, Point<int> point2) {
    return (point1 - point2).distanceTo(Point<int>(0, 0));
  }

  Future<void> _compareImage() async {
    // Initialize sources for the images
    var image1 = File(_imagePath1);
    var image2 = File(_imagePath2);

    // Select an algorithm
    var algorithm = ChiSquareDistanceHistogram();

    // Compare the images
    var difference =
        await compareImages(src1: image1, src2: image2, algorithm: algorithm);

    // Print the difference
    print('Difference: ${difference * 100}%');
  }

  Future<void> _compareFaces() async {
    setState(() {
      _hasLoaded = false;
    });
    final inputImage1 = InputImage.fromFilePath(_imagePath1);
    final inputImage2 = InputImage.fromFilePath(_imagePath2);

    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
    final List<Face> faces1 = await faceDetector.processImage(inputImage1);
    final List<Face> faces2 = await faceDetector.processImage(inputImage2);

    if (faces1.isNotEmpty && faces2.isNotEmpty) {
      // Assuming we have only one face per image for simplicity
      final Face face1 = faces1.first;
      final Face face2 = faces2.first;

      // Calculate differences in bounding box size
      final double sizeDifference =
          (face1.boundingBox.width - face2.boundingBox.width).abs();

      // Calculate differences in head Euler angles
      final double eulerAngleXDifference =
          (face1.headEulerAngleX! - face2.headEulerAngleX!).abs();
      final double eulerAngleYDifference =
          (face1.headEulerAngleY! - face2.headEulerAngleY!).abs();
      final double eulerAngleZDifference =
          (face1.headEulerAngleZ! - face2.headEulerAngleZ!).abs();

      // print('Face1 left eye probability = ${face1.leftEyeOpenProbability}');
      // print('Face2 left eye probability = ${face2.leftEyeOpenProbability}');

      // print('Face1 right eye probability = ${face1.rightEyeOpenProbability}');
      // print('Face2 right eye probability = ${face2.rightEyeOpenProbability}');

      // print('Face1 smiling probability = ${face1.smilingProbability}');
      // print('Face2 smiling probability = ${face2.smilingProbability}');

      // // Calculate differences in eye open probabilities
      // final double leftEyeOpenProbabilityDifference =
      //     (face1.leftEyeOpenProbability! - face2.leftEyeOpenProbability!).abs();

      // final double rightEyeOpenProbabilityDifference =
      //     (face1.rightEyeOpenProbability ??
      //             0.0 - face2.rightEyeOpenProbability!)
      //         .abs();
      // // Calculate differences in smiling probabilities
      // final double smilingProbabilityDifference =
      //     (face1.smilingProbability ?? 0.0 - face2.smilingProbability!).abs();

      // Define thresholds for each property
      const double sizeDifferenceThreshold = 0.1;
      const double eulerAngleThreshold = 10.0;
      // const double eyeOpenProbabilityThreshold = 0.1;
      // const double smilingProbabilityThreshold = 0.1;

      // Check if all differences are within acceptable thresholds
      final bool sizeMatches = sizeDifference <= sizeDifferenceThreshold;
      final bool eulerAnglesMatch =
          eulerAngleXDifference <= eulerAngleThreshold &&
              eulerAngleYDifference <= eulerAngleThreshold &&
              eulerAngleZDifference <= eulerAngleThreshold;
      // final bool eyeOpenProbabilitiesMatch =
      //     leftEyeOpenProbabilityDifference <= eyeOpenProbabilityThreshold &&
      //         rightEyeOpenProbabilityDifference <= eyeOpenProbabilityThreshold;
      // final bool smilingProbabilitiesMatch =
      //     smilingProbabilityDifference <= smilingProbabilityThreshold;

      // Define the facial landmarks to compare (e.g., eyes, nose)

      setState(() {
        _facesMatch = sizeMatches && eulerAnglesMatch;
      });
    } else {
      setState(() {
        _facesMatch = false;
      });
    }

    setState(() {
      _hasLoaded = true;
    });
  }

  String _imagePath1 = ''; // Path to first image
  String _imagePath2 = ''; // Path to second image

  Future<void> _getImage(ImageSource source, int imageIndex) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        if (imageIndex == 1) {
          _imagePath1 = pickedImage.path;
        } else {
          _imagePath2 = pickedImage.path;
        }
        _facesMatch = false; // Reset faces match result
      });
    }
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
              onPressed: () => _getImage(ImageSource.gallery, 1),
              child: Text('Pick First Image'),
            ),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery, 2),
              child: Text('Pick Second Image'),
            ),
            SizedBox(height: 20),
            if (_imagePath1.isNotEmpty && _imagePath2.isNotEmpty)
              ElevatedButton(
                onPressed: _compareFaces,
                child: Text('Compare Faces'),
              ),
            SizedBox(height: 20),
            if (_imagePath1.isNotEmpty && _imagePath2.isNotEmpty)
              Text(
                !_hasLoaded
                    ? ''
                    : _facesMatch
                        ? 'Faces Match!'
                        : 'Faces Do Not Match!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _facesMatch ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
