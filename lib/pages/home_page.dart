import 'package:flutter/material.dart';
import 'package:todo_list_app/database/database_helper.dart';
import 'package:todo_list_app/modal/note.dart';
import 'add_reminder.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}
class _HomePageState extends State<HomePage>{

  Color setColor(Note note){
    Color color;
    switch (note.priority) {
      case 0:
        color =  Colors.red;
        break;
      case 1:
        color =  Colors.orange;
        break;
      case 2:
        color =  Colors.yellow;
        break;
      case 3:
        color =  Colors.green;
        break;
    }
    return color;
  }
  String getPriority(Note note){
    String priority;
    switch (note.priority) {
      case 0:
        priority =  'Urgent, Important';
        break;
      case 1:
        priority =  'Urgent, Not Important';
        break;
      case 2:
        priority =  'Not Urgent, Important';
        break;
      case 3:
        priority =  'Not Urgent, Not Important';
        break;
    }
    return priority;
  }
  
  deleteNote(Note note){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Delete Note?'),
          content: Text('This will delete the selected note !'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              } 
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () async{
                await DatabaseHelper.db.deleteNote(note);
                Navigator.of(context).pop();
                setState(() {});
              },
            )
          ],
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245,245,220,1),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => AddReminder.empty()));
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Note>>(
        future: DatabaseHelper.db.getNote(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snap){
          if(snap.hasData)
            return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (BuildContext context, int index){
                Note note = snap.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: setColor(note)),
                  onDismissed: (direction) async{
                    await deleteNote(note);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: setColor(note),
                    ),
                    title: Text(note.title),
                    subtitle: Text(note.date),
                    onTap: (){
                      showModalBottomSheet(
                        context: context,
                        builder: (context){
                          return Container(
                            color: Color.fromRGBO(245,245,220,1),
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.title),
                                  title: Text('Title: ' + note.title),
                                ),
                                ListTile(
                                  leading: Icon(Icons.description),
                                  title: Text('Description: ' + note.desc),
                                ),
                                ListTile(
                                  leading: Icon(Icons.priority_high),
                                  title: Text('Priority: ' + getPriority(note)),
                                ),
                                ListTile(
                                  leading: Icon(Icons.date_range),
                                  title: Text('Date: ' + note.date),
                                ),
                              ],
                            ),
                          );
                        }
                      );
                    },
                    onLongPress: (){
                      showModalBottomSheet(
                        context: context,
                        builder: (context){
                          return Container(
                            color: Color.fromRGBO(245,245,220,1),
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.mode_edit),
                                  title: Text('Modify'),
                                  onTap: (){
                                    Navigator.of(context).pop();
                                    Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => AddReminder(note)));
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                  onTap: (){
                                    Navigator.of(context).pop();
                                    deleteNote(note);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      );
                      
                    },
                  ),
                );
              },
            );
          else return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
