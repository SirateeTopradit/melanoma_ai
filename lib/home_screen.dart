import 'camera.dart';
import 'image.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Mask Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Detect face mask from the Image'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FaceDetectionFromImage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text('Detect face mask from Live Camera'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FaceDetectionFromLiveCamera(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}