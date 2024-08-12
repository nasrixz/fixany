import 'dart:async';
import 'dart:io';
import 'package:fixany/model/command_model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class UtilsController {
  List<CommandModel> cmdData = [];
  late StreamController<List<CommandModel>> rtcommand;
  late StreamController<CommandModel> currentCommandCL;
  late StreamController<List<CommandModel>> currentCommandResult;
  late StreamController<bool> show;
  String currCommand = '';
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH_mm");

  FlutterTts flutterTts = FlutterTts();

  Future<void> configureTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
  }

  void speakText(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.accessMediaLocation,
      Permission.mediaLibrary,
    ].request();
    if (status[Permission.storage]!.isDenied) {
    }
  }
  Future<String> createFolder(String folder) async {
    final folderName = folder;
    final path = Directory("storage/emulated/0/Download/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }
}
