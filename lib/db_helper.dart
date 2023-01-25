import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// 厦门大学计算机专业 | 前华为工程师
/// 专注《零基础学编程系列》  http://lblbc.cn/blog
/// 包含：Java | 安卓 | 前端 | Flutter | iOS | 小程序 | 鸿蒙
/// 公众号：蓝不蓝编程

const String tableNote = 'note';
const String columnId = '_id';
const String columnContent = 'content';

class Note {
  int id = 0;
  String content = "";

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnContent: content,
    };
    return map;
  }

  Note(this.content);

  Note.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    content = map[columnContent];
  }
}

class NoteDatabase {
  late Database db;

  openSqlite() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'note.db');

    db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $tableNote (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
            $columnContent TEXT)
          ''');
    });
  }

  Future<Note> insert(Note note) async {
    note.id = await db.insert(tableNote, note.toMap());
    return note;
  }

  Future<Note?> query(int id) async {
    List<Map<String, dynamic>> maps =
        await db.query(tableNote, columns: [columnId, columnContent], where: '$columnId = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Note>> queryAll() async {
    List<Map<String, dynamic>> maps = await db.query(tableNote, columns: [columnId, columnContent]);
    List<Note> notes = [];

    if (maps.isEmpty) {
      return notes;
    }

    for (int i = 0; i < maps.length; i++) {
      notes.add(Note.fromMap(maps[i]));
    }
    return notes;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Note note) async {
    return await db.update(tableNote, note.toMap(), where: '$columnId = ?', whereArgs: [note.id]);
  }

  close() async {
    await db.close();
  }
}
