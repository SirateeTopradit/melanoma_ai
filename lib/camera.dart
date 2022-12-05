import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;


class FaceDetectionFromLiveCamera extends StatefulWidget {
  @override
  _FaceDetectionFromLiveCameraState createState() =>
      _FaceDetectionFromLiveCameraState();
}

class _FaceDetectionFromLiveCameraState
    extends State<FaceDetectionFromLiveCamera> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool isDetecting = false;
  late List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  @override
  void initState() {
    super.initState();
    loadModel();
    _initializeCamera();
  }

  void loadModel() async {
    await Tflite.loadModel(
      // C:\Users\Tae\Documents\Project_code\Skin Diseases Classification\melanoma_ai\assets\converted_model.tflite
      model: "assets/converted_model.tflite",
    );
  }

  void _initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraController.initialize().then(
      (_) {
        if (!mounted) {
          return;
        }
        cameraController.startImageStream(
          (CameraImage img) {
            if (!isDetecting) {
              isDetecting = true;
              Tflite.runModelOnFrame(
                bytesList: img.planes.map(
                  (plane) {
                    return plane.bytes;
                  },
                ).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 2,
              ).then(
                (recognitions) {
                  setRecognitions(recognitions, img.height, img.width);
                  isDetecting = false;
                },
              );
            }
          },
        );
      },
    );
  }

  void setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints.expand(),
      child: cameraController == null
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: cameraController.value.aspectRatio,
                    child: CameraPreview(cameraController),
                  ),
                ),
              ],
            ),
    );
  }
}
