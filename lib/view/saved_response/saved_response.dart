import 'dart:io';

import 'package:fixany/controller/utils_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/saved_response_model.dart';
import 'package:fixany/services/database_helper.dart';
import 'package:fixany/view/saved_response/view_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SavedResponsePage extends StatefulWidget {
  const SavedResponsePage({super.key});

  @override
  State<SavedResponsePage> createState() => _SavedResponsePageState();
}

class _SavedResponsePageState extends State<SavedResponsePage> {
  DatabaseHelper db = DatabaseHelper.instance;
  List<SavedResponseModel> command = [];
  final controller = getIt<UtilsController>();
  @override
  void initState() {
    db.getAllS().then((value) {
      setState(() {
        command = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Saved Response List',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            command.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: command.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => ViewDetails(
                                            imagePath: command[index].path!,
                                            title: command[index].title!,
                                            response: command[index].response!,
                                            id: command[index].id!)))
                                    .then((_) {
                                  db.getAllS().then((value) {
                                    setState(() {
                                      command = value;
                                    });
                                  });
                                });
                              },
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      flex: 1,
                                      onPressed: (context) {
                                        _showAlertDialogDoN(
                                            context, command[index].id!);
                                      },
                                      spacing: 4,
                                      backgroundColor: const Color(0xFFf95959),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.transparent),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: Image.file(
                                              fit: BoxFit.cover,
                                              File(command[index].path!),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                command[index].title!,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                command[index].response!,
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    fontWeight:
                                                        FontWeight.w400),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Divider(
                                                color: Colors.white
                                                    .withOpacity(0.1),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            )
                          ],
                        );
                      },
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: Text('No Saved Response available'),
                    ),
                  ),
          ],
        ),
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
                  db.getAllS().then((value) {
                    setState(() {
                      command = value;
                    });
                  }).then((v) {
                    Navigator.of(context).pop();
                    const snackBar = SnackBar(
                      content: Text('Delete Completed'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
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

void doNothing(BuildContext context) {}
