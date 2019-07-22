import 'dart:async';

import 'package:flutter_course_practise_2/database/database_helper.dart';
import 'package:flutter_course_practise_2/modal/note.dart';

class NotesBloc {
  NotesBloc() {
    getClients();
  }
  final _clientController =     StreamController<List<Note>>.broadcast();
  get clients => _clientController.stream;

  dispose() {
    _clientController.close();
  }




  getClients() async {
    _clientController.sink.add(await DatabaseHelper.db.getNote());
  }
}