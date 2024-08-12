import 'dart:async';
import 'dart:io';
import 'package:fixany/controller/model_controller.dart';
import 'package:fixany/controller/utils_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/response_model.dart';
import 'package:fixany/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewDetails extends StatefulWidget {
  final String imagePath;
  final String title;
  final String response;
  final int id;

  const ViewDetails(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.response,
      required this.id});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  final modelController = getIt<ModelController>();
  late StreamController<Response> responseData;
  DatabaseHelper db = DatabaseHelper.instance;

  final controller = getIt<UtilsController>();
  final ScrollController _scrollController = ScrollController();
  bool showSave = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, right: 8, left: 8, bottom: 8),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      SvgPicture.asset(
                        'assets/logo/fixany_white.svg',
                        height: 25,
                        width: 80,
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            _showAlertDialogDoN(context, widget.id);
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.cover,
                    )),
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
                Padding(
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
                                await Clipboard.setData(
                                    ClipboardData(text: widget.title));
                                // copied successfully
                              },
                              icon: const Icon(Icons.copy)),
                          IconButton(
                              onPressed: () {
                                controller.speakText(widget.title);
                              },
                              icon: const Icon(Icons.volume_up_rounded))
                        ],
                      ),
                      Text(widget.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 22)),
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
                                await Clipboard.setData(
                                    ClipboardData(text: widget.response));
                                // copied successfully
                              },
                              icon: const Icon(Icons.copy)),
                          IconButton(
                              onPressed: () {
                                controller.speakText(widget.response);
                              },
                              icon: const Icon(Icons.volume_up_rounded))
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.response,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            )),
      ),
    );
  }

  void _showAlertDialogDoN(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          icon: const Icon(Icons.delete_forever_outlined),
          title: const Text('Delete?'),
          content: const Text(
            'Are you sure to delete this command?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                db.deleteS(id).then((v) {
                  Navigator.pop(context);
                  Navigator.of(context).pop();
                  const snackBar = SnackBar(
                    content: Text('Delete Completed'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
