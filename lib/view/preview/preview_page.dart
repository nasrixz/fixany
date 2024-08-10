import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fixany/controller/model_controller.dart';
import 'package:fixany/controller/utils_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/command_model.dart';
import 'package:fixany/model/response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';

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
  final controller = getIt<UtilsController>();

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
    responseData = StreamController<Response>();
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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
                // height: MediaQuery.of(context).size.height * 0.60,
                width: double.infinity,
                child: Image.file(
                  File(widget.imagePath ?? ""),
                  fit: BoxFit.cover,
                )),
            StreamBuilder<Response>(
                stream: responseData.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: LottieBuilder.asset(
                      'assets/lottie/loading.json',
                    ));
                  } else if (snapshot.hasError) {
                    final error = snapshot.error;
                    return Center(child: Text(error.toString()));
                  } else if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Title',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                          Text(snapshot.data!.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 22)),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Title',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.content,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 8,
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                })
          ],
        ),
      ),
    );
  }
}
