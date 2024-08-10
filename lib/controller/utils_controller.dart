import 'dart:async';
import 'package:fixany/model/command_model.dart';

class UtilsController {
  List<CommandModel> cmdData = [];
  late StreamController<List<CommandModel>> rtcommand;
  late StreamController<CommandModel> currentCommandCL;
  late StreamController<List<CommandModel>> currentCommandResult;
  String currCommand = '';
}
