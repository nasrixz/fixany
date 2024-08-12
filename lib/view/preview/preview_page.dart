import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fixany/controller/model_controller.dart';
import 'package:fixany/controller/utils_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/command_model.dart';
import 'package:fixany/model/response_model.dart';
import 'package:fixany/model/saved_response_model.dart';
import 'package:fixany/services/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviewPage extends StatefulWidget {
  final String? imagePath;
  final String? videoPath;
  final String crCommand;

  const PreviewPage(
      {super.key, this.imagePath, this.videoPath, required this.crCommand});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final modelController = getIt<ModelController>();
  late StreamController<Response> responseData;
  DatabaseHelper db = DatabaseHelper.instance;

  final controller = getIt<UtilsController>();
  final ScrollController _scrollController = ScrollController();
  bool showSave = false;
  Future<Uint8List> getResult(path) async {
    final bytes = await File(path).readAsBytes();
    return bytes;
  }

  Future<Response> x(data) async {
    var x = json.encode(data);
    return responseFromJson(x);
  }

  CommandModel getSelectedValue(List<CommandModel> data) {
    for (int i = 0; i < data.length; i++) {
      if (data[i].status == 1) {
        return data[i];
      }
    }
    return data.first;
  }

  @override
  void initState() {
    Permission.storage.request();
    controller.show = StreamController<bool>();
    responseData = StreamController<Response>();
    controller.show.sink.add(false);

    getResult(widget.imagePath).then((value) async {
      final prompt = TextPart(
          "based on this image, ${widget.crCommand} , state reponse with title attribute and content attribute only, all list state on content attribute with no list format only with comma");
      final content = [DataPart('image/jpeg', value)];
      await modelController.model.generateContent([
        Content.multi([prompt, ...content])
      ]).then((value) {
        var i = jsonDecode(value.text!);
        if (kDebugMode) {
          print(value.text);
        }
        x(i).then((value) {
          if (kDebugMode) {
            print(value);
          }
          responseData.sink.add(value);
        });
      });
    });
    Future.delayed(const Duration(seconds: 1)).then((v) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    }).then((_) {
      Future.delayed(const Duration(seconds: 3)).then((v) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.show.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: StreamBuilder<bool>(
            initialData: false,
            stream: controller.show.stream,
            builder: (context, snapshot) {
              showSave = snapshot.data!;
              return Column(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: Image.file(
                        File(widget.imagePath ?? ""),
                        fit: BoxFit.cover,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              controller.show.sink.add(false);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        SvgPicture.asset(
                          'assets/logo/fixany_white.svg',
                          height: 25,
                          width: 80,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: const Color(0xFF42b883).withOpacity(0.3)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.verified_outlined,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text(
                          'Response by Gemini. ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (!await launchUrl(
                                Uri.parse('https://gemini.google.com'))) {
                              throw Exception(
                                  'Could not launch ${Uri.parse('https://gemini.google.com')}');
                            }
                          },
                          child: const Text(
                            'Learn more.',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  StreamBuilder<Response>(
                      stream: responseData.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: LottieBuilder.asset(
                            'assets/lottie/loading.json',
                          ));
                        } else if (snapshot.hasError) {
                          final error = snapshot.error;
                          return Center(child: Text(error.toString()));
                        } else if (snapshot.hasData) {
                          controller.show.sink.add(true);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Title',
                                      style: TextStyle(
                                          color: Colors.grey.withOpacity(0.8),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          await Clipboard.setData(ClipboardData(
                                              text: snapshot.data!.title));
                                          // copied successfully
                                        },
                                        icon: const Icon(Icons.copy)),
                                    IconButton(
                                        onPressed: () {
                                          controller
                                              .speakText(snapshot.data!.title);
                                        },
                                        icon:
                                            const Icon(Icons.volume_up_rounded))
                                  ],
                                ),
                                Text(snapshot.data!.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22)),
                                const Divider(),
                                Row(
                                  children: [
                                    Text(
                                      'Content',
                                      style: TextStyle(
                                          color: Colors.grey.withOpacity(0.8),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                     IconButton(
                                        onPressed: () async {
                                          await Clipboard.setData(ClipboardData(
                                              text: snapshot.data!.content));
                                          // copied successfully
                                        },
                                        icon: const Icon(Icons.copy)),
                                    IconButton(
                                        onPressed: () {
                                          controller.speakText(
                                              snapshot.data!.content);
                                        },
                                        icon:
                                            const Icon(Icons.volume_up_rounded))
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  snapshot.data!.content,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500),
                                ),
                                const Divider(),
                                const SizedBox(height: 16,),
                                showSave
                                    ? GestureDetector(
                                        onTap: () async {
                                          final String path =
                                              (await getApplicationDocumentsDirectory())
                                                  .path;
                                          await XFile(widget.imagePath!)
                                              .saveTo(
                                                  '$path/${controller.dateFormat.format(DateTime.now())}.jpg')
                                              .then((v) async {
                                            // Save Image (Supports two ways)
                                            await Gal.putImage(
                                                '$path/${controller.dateFormat.format(DateTime.now())}.jpg',
                                                album: 'fixany');
                                            db
                                                .insertS(SavedResponseModel(
                                                    snapshot.data!.title,
                                                    snapshot.data!.content,
                                                    '/storage/emulated/0/Pictures/fixany/${controller.dateFormat.format(DateTime.now())}.jpg'))
                                                .then((v) {
                                              const snackBar = SnackBar(
                                                content: Text('Response Save'),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color(0xFF42b883)
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              color: const Color(0xFF42b883)
                                                  .withOpacity(0.2)),
                                          child: const Center(
                                              child: Text(
                                            'Save Response',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF42b883),
                                                fontWeight: FontWeight.w600),
                                          )),
                                        ),
                                      )
                                    : Container(),
                                showSave
                                    ? GestureDetector(
                                        onTap: () async {
                                          final String path =
                                              (await getApplicationDocumentsDirectory())
                                                  .path;
                                          await XFile(widget.imagePath!)
                                              .saveTo(
                                                  '$path/${controller.dateFormat.format(DateTime.now())}.jpg')
                                              .then((v) async {
                                            await Gal.putImage(
                                                '$path/${controller.dateFormat.format(DateTime.now())}.jpg',
                                                album: 'fixany');
                                            const snackBar = SnackBar(
                                              content: Text('Image Saved'),
                                            );
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5)),
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              color:
                                                  Colors.grey.withOpacity(0.1)),
                                          child: const Center(
                                              child: Text(
                                            'Save Image Only',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          )),
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      }),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
