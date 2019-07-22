import 'package:flutter/material.dart';
import 'package:todo_list_app/database/database_helper.dart';
import 'package:todo_list_app/modal/note.dart';

class AddReminder extends StatefulWidget {
  Note note;
  AddReminder(this.note);
  AddReminder.empty();

  @override
  State<StatefulWidget> createState() {
    return _AddReminderState();
  }
}

class _AddReminderState extends State<AddReminder> {
  List<String> _list = [
    'Urgent, Important',
    'Urgent, Not Important',
    'Not Urgent, Important',
    'Not Urgent, Not Important'
  ];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String _title;
  String _description;
  String _date;
  String _priority;
  final GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  //Note note;

  String getPriority(Note note) {
    String result;
    switch (note.priority) {
      case 0:
        result = 'Urgent, Important';
        break;
      case 1:
        result = 'Urgent, Not Important';
        break;
      case 2:
        result = 'Not Urgent, Important';
        break;
      case 3:
        result = 'Not Urgent, Not Important';
        break;
    }
    return result;
  }

  int setPriorityCode() {
    int result;
    switch (_priority) {
      case 'Urgent, Important':
        result = 0;
        break;
      case 'Urgent, Not Important':
        result = 1;
        break;
      case 'Not Urgent, Important':
        result = 2;
        break;
      case 'Not Urgent, Not Important':
        result = 3;
        break;
    }
    return result;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    if (widget.note == null) {
      _title = '';
      _description = '';
      _date = '';
      _priority = 'Urgent, Important';
    } else {
      _title = widget.note.title;
      _description = widget.note.desc;
      _date = widget.note.date;
      _priority = getPriority(widget.note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 220, 1),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text('Add Note'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Form(
          key: formkey,
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                padding: EdgeInsets.all(10.00),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10.00,
                    ),
                    TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1.00,
                                color: Colors.black,
                                style: BorderStyle.solid)),
                        labelText: 'Enter Title',
                        hintText: 'Ex: Visiting my friend',
                      ),
                      onSaved: (String value) {
                        setState(() {
                          _title = value;
                        });
                      },
                      validator: (String value) {
                        if (value.isEmpty) return 'Title is required !';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 25.00,
                    ),
                    TextFormField(
                      initialValue: _description,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1.00,
                                color: Colors.black,
                                style: BorderStyle.solid)),
                        labelText: 'Enter Description',
                        hintText: 'Description',
                      ),
                      onSaved: (String value) {
                        setState(() {
                          _description = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 25.00,
                    ),
                    Row(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.red,
                          onPressed: () async {
                            await _selectDate(context);
                            await _selectTime(context);
                            setState(() {
                              _date =
                                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedTime.format(context)}';
                            });
                          },
                          child: Text('Select Date'),
                        ),
                        SizedBox(
                          width: 55.00,
                        ),
                        Text(_date),
                      ],
                    ),
                    SizedBox(
                      height: 25.00,
                    ),
                    Row(children: <Widget>[
                      Container(
                        color: Color.fromRGBO(100, 149, 237, 1),
                        child: Text('Select Priority'),
                        padding: EdgeInsets.all(10),
                      ),
                      SizedBox(
                        width: 15.00,
                      ),
                      DropdownButton(
                        hint: Text('Select the priority:'),
                        value: _priority,
                        onChanged: (value) {
                          setState(() {
                            _priority = value;
                          });
                        },
                        items:
                            _list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]),
                    SizedBox(
                      height: 35.00,
                    ),
                    Center(
                        child: ButtonTheme(
                      minWidth: 55.00,
                      height: 40.00,
                      child: RaisedButton.icon(
                        color: Colors.green,
                        icon: Icon(Icons.save),
                        onPressed: () async {
                          if (!formkey.currentState.validate()) return;
                          formkey.currentState.save();

                          if (widget.note != null) {
                            widget.note.title = _title;
                            widget.note.desc = _description;
                            widget.note.priority = setPriorityCode();
                            widget.note.date = _date;
                            await DatabaseHelper.db.updateNote(widget.note);
                          } else {
                            widget.note = new Note(
                                _title, setPriorityCode(), _date,
                                description: _description);
                            await DatabaseHelper.db.addNote(widget.note);
                          }
                          Navigator.pop(context);
                        },
                        label: Text('Save'),
                      ),
                    ))
                  ],
                ),
              ))),
    );
  }
}
