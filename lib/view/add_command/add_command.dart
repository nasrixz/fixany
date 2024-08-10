import 'package:fixany/controller/utils_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/command_model.dart';
import 'package:fixany/services/database_helper.dart';
import 'package:flutter/material.dart';

class AddCommand extends StatefulWidget {
  const AddCommand({super.key});

  @override
  State<AddCommand> createState() => _AddCommandState();
}

class _AddCommandState extends State<AddCommand> {
  DatabaseHelper cmddb = DatabaseHelper.instance;
  late TextEditingController title = TextEditingController();
  late TextEditingController command = TextEditingController();
  final controller = getIt<UtilsController>();
  @override
  void initState() {
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
                          cmddb
                              .insert(
                            CommandModel(title.text, command.text, 0),
                          )
                              .then((value) {
                            _showAlertDialog(context);
                            cmddb.getAll().then((value) {
                              controller.rtcommand.sink.add(value);
                            });
                          });
                        },
                        icon: const Icon(Icons.check))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Add New Command',
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
                          // hintText: hintText,
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
                          // hintText: hintText,
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
            'Command has been added succesfully',
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
}
