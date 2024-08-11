import 'dart:async';

import 'package:camera/camera.dart';
import 'package:fixany/camera/camera_function.dart';
import 'package:fixany/controller/utils_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/command_model.dart';
import 'package:fixany/services/database_helper.dart';
import 'package:fixany/view/command_page/command_page.dart';
import 'package:fixany/view/preview/preview_page.dart';
import 'package:fixany/view/saved_response/saved_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  final cController = getIt<CameraFunction>();
  bool _isCameraInitialized = false;
  late final List<CameraDescription> _cameras;
  DatabaseHelper commanddb = DatabaseHelper.instance;
  List<CommandModel> command = [];
  final controller = getIt<UtilsController>();

  @override
  void initState() {
    commanddb.getAll().then((value) {
      if (value.isEmpty) {
        commanddb.insert(CommandModel('Default Command',
            'Analyze the broken part, and list the step to fix it', 1));
        commanddb.insert(CommandModel(
            'Google Cookbook ',
            'Analyze the ingredient , and create receipe with that ingredient',
            0));
      } else {}
    }).then((V) {
      commanddb.getAll().then((value) {
        controller.rtcommand.sink.add(value);
        setState(() {
          command = value;
          controller.cmdData = value;
          if (controller.currCommand == '') {
            controller.currCommand = command[0].command!;
          }
        });
      });
    });
    WidgetsBinding.instance.addObserver(this);

    initCamera();
    controller.rtcommand = StreamController<List<CommandModel>>();
    controller.currentCommandCL = StreamController<CommandModel>();

    super.initState();
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

  void onTakePhotoPressed(String cmd) async {
    final navigator = Navigator.of(context);
    final xFile = await cController.capturePhoto();
    if (xFile != null) {
      if (xFile.path.isNotEmpty) {
        // controller.show.sink.add(false);
        navigator.push(
          MaterialPageRoute(
            builder: (context) => PreviewPage(
              crCommand: cmd,
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    JustTheTooltip(
                      preferredDirection: AxisDirection.up,
                      backgroundColor: Colors.grey[900],
                      content: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Fixany powered by Gemini',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/logo/fixany_white.svg',
                        height: 25,
                        width: 80,
                      ),
                    ),
                    
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: Row(
                    children: [
                      Expanded(
                        child: StreamBuilder<List<CommandModel>>(
                            initialData: command,
                            stream: controller.rtcommand.stream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                final error = snapshot.error;
                                return Center(child: Text(error.toString()));
                              } else if (snapshot.hasData) {
                                if (snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text('No data'),
                                  );
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (snapshot.data![index].status ==
                                              0) {
                                            for (int i = 0;
                                                i < snapshot.data!.length;
                                                i++) {
                                              commanddb.updateAll(
                                                  0, snapshot.data![i].id!);
                                            }
                                            commanddb
                                                .update(
                                                    CommandModel(
                                                        snapshot
                                                            .data![index].title,
                                                        snapshot.data![index]
                                                            .command,
                                                        1),
                                                    snapshot.data![index].id!)
                                                .then((value) {
                                              commanddb.getAll().then((value) {
                                                controller.rtcommand.sink
                                                    .add(value);
                                              });
                                            });
                                            setState(() {
                                              controller.currCommand = snapshot
                                                  .data![index].command!;
                                            });
                                            debugPrint(controller.currCommand);
                                          }
                                        },
                                        child: JustTheTooltip(
                                          preferredDirection: AxisDirection.up,
                                          backgroundColor: Colors.grey[900],
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Command',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data![index].command!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 4, left: 4),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: snapshot.data![index]
                                                                .status ==
                                                            1
                                                        ? const Color(
                                                                0xFF42b883)
                                                            .withOpacity(0.5)
                                                        : Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: snapshot.data![index]
                                                            .status ==
                                                        1
                                                    ? const Color(0xFF42b883)
                                                        .withOpacity(0.3)
                                                    : Colors.grey
                                                        .withOpacity(0.1)),
                                            child: Text(
                                                snapshot.data![index].title!),
                                          ),
                                        ),
                                      );
                                    });
                              }
                              return Container();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: JustTheTooltip(
                      preferredDirection: AxisDirection.up,
                      backgroundColor: Colors.grey[900],
                      content: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Command',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CommandPage(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 30,
                          )),
                    ),
                  ),
                  JustTheTooltip(
                    preferredDirection: AxisDirection.up,
                    backgroundColor: Colors.grey[900],
                    content: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Capture',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        onTakePhotoPressed(controller.currCommand);
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(75, 75),
                          shape: const CircleBorder(),
                          backgroundColor: Colors.grey.withOpacity(0.3)),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SavedResponsePage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.save_rounded,
                          size: 30,
                        )),
                  ),
                ],
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
