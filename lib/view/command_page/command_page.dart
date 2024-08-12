import 'package:fixany/controller/utils_controller.dart';
import 'package:fixany/di/service_locator.dart';
import 'package:fixany/model/command_model.dart';
import 'package:fixany/services/database_helper.dart';
import 'package:fixany/view/add_command/add_command.dart';
import 'package:fixany/view/edit_command_page/edit_command_page.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class CommandPage extends StatefulWidget {
  const CommandPage({super.key});

  @override
  State<CommandPage> createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  DatabaseHelper db = DatabaseHelper.instance;
  List<CommandModel> command = [];
  final controller = getIt<UtilsController>();
  @override
  void initState() {
    db.getAll().then((value) {
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
              padding: const EdgeInsets.all(8),
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
              padding: EdgeInsets.all(8),
              child: Text(
                'Command List',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            command.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: command.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (command[index].status == 0) {
                              for (int i = 0; i < command.length; i++) {
                                db.updateAll(0, command[i].id!);
                              }
                              db
                                  .update(
                                      CommandModel(command[index].title,
                                          command[index].command, 1),
                                      command[index].id!)
                                  .then((value) {
                                db.getAll().then((value) {
                                  controller.rtcommand.sink.add(value);
                                  setState(() {
                                    command = value;
                                  });
                                });
                              });
                              controller.currCommand = command[index].command!;
                            }
                          },
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  // An action can be bigger than the others.
                                  onPressed: (context) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditCommandPage(
                                          id: command[index].id!,
                                          status: command[index].status!,
                                        ),
                                      ),
                                    );
                                  },
                                  backgroundColor: const Color(0xFF385170),
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit_note_sharp,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    _showAlertDialogDoN(
                                        context, command[index].id!);
                                  },
                                  backgroundColor: const Color(0xFFf95959),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: command[index].status == 1
                                        ? const Color(0xFF42b883)
                                            .withOpacity(0.3)
                                        : Colors.transparent),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      command[index].title!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(command[index].command!),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(),
                                        ),
                                        command[index].status == 1
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    color:
                                                        const Color(0xFF42b883)
                                                            .withOpacity(0.2)),
                                                child: const Text(
                                                    'Current Command'),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: Text('No Command Available'),
                    ),
                  ),
          ],
        ),
        floatingActionButton: JustTheTooltip(
          preferredDirection: AxisDirection.up,
          backgroundColor: Colors.grey[900],
          content: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Add new',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF42b883).withOpacity(0.5),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const AddCommand()))
                  .then((v) => db.getAll().then((value) {
                        setState(() {
                          command = value;
                        });
                      }));
            },
            child: const Icon(Icons.add),
          ),
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
                db.delete(id).then((v) {
                  db.getAll().then((value) {
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
