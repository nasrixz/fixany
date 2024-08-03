import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixany/controller/model_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class PreviewPage extends StatefulWidget {
  final String? imagePath;
  final String? videoPath;

  const PreviewPage({super.key, this.imagePath, this.videoPath});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
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
          "based on this image analyze the broken part, and list the step to fix it");
      final content = [DataPart('image/jpeg', value)];
      final response = await modelController.model.generateContent([
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
      print(response.text);
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
            const SizedBox(height: 30),
            StreamBuilder<Response>(
                stream: responseData.stream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          snapshot.data!.brokenPart,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
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
                                style: Theme.of(context).textTheme.bodyLarge,
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
