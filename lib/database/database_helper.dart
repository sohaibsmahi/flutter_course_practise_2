import 'dart:io';
import 'package:flutter_course_practise_2/modal/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{

  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();  

  static Database _database;

  Future<Database> get database async{
    if (_database != null)
      return _database;
    
    _database = await initDB();
    return _database;
  }

  initDB() async{
    Directory docdirectory = await getApplicationDocumentsDirectory();
    String path = join(docdirectory.path, 'notedb.db');
    return await openDatabase(path, version: 1, onOpen: (db){}, onCreate: (Database db, int version) async{
      //await db.execute('DROP TABLE NOTE IF EXISTS');
      await db.execute('CREATE TABLE Note(id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR(50) NOT NULL, description VARCHAR(255), priority INTEGER NOT NULL, date TEXT NOT NULL);');
    });
  }

  Future<int> addNote(Note note) async{
    final db = await database;
    var res = await db.rawInsert("INSERT Into Note(title,description,priority,date) VALUES ('${note.title}','${note.description}',${note.priority}, '${note.date}');");
    //print(db.execute('.tables'));
    return res;
  }

  Future<List<Note>> getNote() async{
    final db = await database;
    var response = await db.query("Note", orderBy: 'priority,date');
    List<Note> list = response.map((c) => Note.fromMap(c)).toList();
    return list;
  }

  updateNote(Note note) async{
    final db = await database;
    //db.rawUpdate('UPDATE Note SET title=${note.title}, description=${note.desc}, priority=${note.priority}, date=${note.date} WHERE id=${note.id};');
    db.update('Note', note.toMap(), where: 'id=?', whereArgs: [note.id]);
  }

  deleteNote(Note note) async{
    final db = await database;
    //var res = db.delete('Note', where: '${note.id}');
    var res = db.rawDelete('DELETE FROM Note WHERE id=${note.id};');
    return res;
  }
  deleteAllNotes() async{
    final db = await database;
    db.rawDelete('Delete * from Note;');
  }

}

