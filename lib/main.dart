import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_note.dart';
import 'db_helper.dart';
import 'edit_note.dart';

/// 厦门大学计算机专业 | 前华为工程师
/// 专注《零基础学编程系列》  http://lblbc.cn/blog
/// 包含：Java | 安卓 | 前端 | Flutter | iOS | 小程序 | 鸿蒙
/// 公众号：蓝不蓝编程
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '记事本-蓝不蓝编程',
      home: NoteListPage(),
    );
  }
}

class NoteListPage extends StatelessWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '蓝不蓝编程',
      home: NoteListWidget(),
    );
  }
}

class NoteListWidget extends StatefulWidget {
  const NoteListWidget({Key? key}) : super(key: key);

  @override
  createState() => _NoteListState();
}

class _NoteListState extends State<NoteListWidget> {
  List _notes = [];

  @override
  void initState() {
    super.initState();
    queryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("记事本-蓝不蓝编程"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: gotoAddNotePage,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: getBody(),
      ),
    );
  }

  gotoAddNotePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNotePage())).then((value) => queryData());
  }

  queryData() async {
    NoteDatabase noteDataBase = NoteDatabase();
    await noteDataBase.openSqlite();
    List<Note> notes = await noteDataBase.queryAll();
    await noteDataBase.close();
    setState(() {
      _notes = notes;
    });
  }

  getItem(note) {
    var row = Container(
      margin: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          onRowClick(note);
        },
        child: buildRow(note),
      ),
    );
    return Card(
      child: row,
    );
  }

  Row buildRow(Note note) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(left: 8.0),
          height: 40.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                note.content,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ))
      ],
    );
  }

  getBody() {
    if (_notes.isNotEmpty) {
      return ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (BuildContext context, int position) {
            return getItem(_notes[position]);
          });
    }
  }

  onRowClick(Note note) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditNotePage(noteId: note.id)))
        .then((value) => queryData());
  }
}
