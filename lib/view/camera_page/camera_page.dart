import 'package:camera/camera.dart';
import 'package:fixany/camera/camera_function.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/view/preview/preview_page.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  final cController = getIt<CameraFunction>();
  bool _isCameraInitialized = false;
  late final List<CameraDescription> _cameras;
  // bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initCamera();
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    // Initialize the camera with the first camera in the list
    await onNewCameraSelected(_cameras.first);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    final CameraController? cameraController = cController.controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    cController.controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onTakePhotoPressed() async {
    final navigator = Navigator.of(context);
    final xFile = await cController.capturePhoto();
    if (xFile != null) {
      if (xFile.path.isNotEmpty) {
        navigator.push(
          MaterialPageRoute(
            builder: (context) => PreviewPage(
              imagePath: xFile.path,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCameraInitialized) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                  child: SizedBox(
                      width: double.infinity,
                      child: CameraPreview(cController.controller!))),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onTakePhotoPressed,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(70, 70),
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Future<void> onNewCameraSelected(CameraDescription description) async {
    final previousCameraController = cController.controller;

    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      description,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }
    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        cController.controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = cController.controller!.value.isInitialized;
      });
    }
  }
}
