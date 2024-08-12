import 'package:fixany/controller/utils_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/command_model.dart';
import 'package:fixany/services/database_helper.dart';
import 'package:flutter/material.dart';

class EditCommandPage extends StatefulWidget {
  final int id;
  final int status;
  const EditCommandPage({super.key, required this.id, required this.status});

  @override
  State<EditCommandPage> createState() => _EditCommandPageState();
}

class _EditCommandPageState extends State<EditCommandPage> {
  DatabaseHelper cmddb = DatabaseHelper.instance;
  late CommandModel _data;
  late TextEditingController title = TextEditingController();
  late TextEditingController command = TextEditingController();
  final controller = getIt<UtilsController>();
  @override
  void initState() {
    cmddb.read(widget.id).then((value) {
      setState(() {
        _data = value;
        title.text = value.title!;
        command.text = value.command!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    IconButton(
                        onPressed: () {
                          if (title.text == _data.title &&
                              command.text == _data.command) {
                            _showAlertDialogNoChange(context);
                          } else {
                            cmddb
                                .update(
                                    CommandModel(title.text, command.text,
                                        widget.status),
                                    widget.id)
                                .then((value) {
                              _showAlertDialog(context);
                              cmddb.getAll().then((value) {
                                controller.rtcommand.sink.add(value);
                              });
                            });
                          }
                        },
                        icon: const Icon(Icons.check))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Edit Command',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Title',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                        maxLines: 2,
                        controller: title,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.05),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: const Color(0xFF42b883).withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Command',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                        maxLines: 16,
                        controller: command,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.05),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: const Color(0xFF42b883).withOpacity(0.2),
                              width: 2.0,
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          icon: const Icon(Icons.check),
          title: const Text('Success'),
          content: const Text(
            'Command has been updated succesfully',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialogNoChange(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          icon: const Icon(Icons.info_outline),
          title: const Text('No Update'),
          content: const Text(
            'No update has been made, Please edit title or command to update',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
