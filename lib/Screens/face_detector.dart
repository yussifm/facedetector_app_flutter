// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMKey =
      GlobalKey<ScaffoldMessengerState>();
  bool faceDetectorChecking = false;
  XFile? imageFile;
  String facesmiling = "";
  String headRotation = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (faceDetectorChecking)
                Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.all(10),
                    child: const CircularProgressIndicator.adaptive()),
              if (!faceDetectorChecking && imageFile == null)
                Container(
                  width: 300,
                  height: 300,
                  color: Colors.grey[400],
                ),
              if (imageFile != null)
                Image.file(
                  File(imageFile!.path),
                  width: 350,
                  height: 450,
                  fit: BoxFit.contain,
                ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          onPickBtnImgSelected(btnName: 'Camera');
                        },
                        icon: Icon(Icons.camera_alt_rounded),
                        label: Text("Camera"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          onPickBtnImgSelected(btnName: 'Gallary');
                        },
                        label: Text("Gallary"),
                        icon: Icon(Icons.image_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    facesmiling,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPickBtnImgSelected({required String btnName}) async {
    ImageSource imageSource;
    if (btnName == "Camera") {
      imageSource = ImageSource.camera;
    } else {
      imageSource = ImageSource.gallery;
    }
    final scaffoldstate = _scaffoldMKey.currentState;
    try {
      XFile? file = await ImagePicker().pickImage(source: imageSource);
      if (file != null) {
        faceDetectorChecking = true;
        imageFile = file;
        setState(() {});
        getImageFacedetections(file);
      }
    } catch (e) {
      faceDetectorChecking = false;
      imageFile = null;
      facesmiling = "Error Occured while getting image";
      scaffoldstate?.showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 4),
      ));
      setState(() {});
    }
  }

  void getImageFacedetections(XFile source) async {
    final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
        enableContours: true,
        enableTracking: true));
    final InputImage inputImage = InputImage.fromFilePath(source.path);

    final List<Face> faces = await faceDetector.processImage(inputImage);
    double? smileprob = 0.0;

    // extract faces
    for (Face face in faces) {
      if (face.smilingProbability != null) {
        smileprob = face.smilingProbability;

        if (smileprob != null && smileprob < 0.45) {
          facesmiling = "You are 😐";
        }
        if (smileprob != null && smileprob >= 0.45) {
          facesmiling = "You are 🙂";
        }
        if (smileprob != null && smileprob >= 0.75) {
          facesmiling = "You are 😀";
        }

        if (smileprob != null && smileprob >= 0.86) {
          facesmiling = "You are 🤣";
        }
      }
    }
    faceDetector.close();
    faceDetectorChecking = false;
    setState(() {});
  }
}
