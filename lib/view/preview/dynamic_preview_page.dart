import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fixany/controller/model_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DynamicPreviewPage extends StatefulWidget {
  final String? imagePath;
  final String? videoPath;

  const DynamicPreviewPage({super.key, this.imagePath, this.videoPath});

  @override
  State<DynamicPreviewPage> createState() => _DynamicPreviewPageState();
}

class _DynamicPreviewPageState extends State<DynamicPreviewPage> {
  final modelController = getIt<ModelController>();
  late StreamController<Response> responseData;

  Future<Uint8List> getResult(path) async {
    final bytes = await File(path).readAsBytes();
    return bytes;
  }

  Future<Response> x(data) async {
    var x = json.encode(data);
    return responseFromJson(x);
  }

  @override
  void initState() {
    responseData = StreamController<Response>();
    getResult(widget.imagePath).then((value) async {
      final prompt = TextPart(
          "based on this");
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
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.60,
                width: double.infinity,
                child: Image.file(
                  File(widget.imagePath ?? ""),
                  fit: BoxFit.cover,
                )),
            StreamBuilder<Response>(
                stream: responseData.stream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Title',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        Text(snapshot.data!.brokenPart,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 22)),
                        const SizedBox(
                          height: 16,
                        ),
                        for (int i = 0;
                            i < snapshot.data!.stepsToFix.length;
                            i++)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.stepsToFix[i],
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
                })
          ],
        ),
      ),
    );
  }
}
