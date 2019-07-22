class Note{

  int _id;
  String _title;
  String description;
  int _priority;
  String _date;

  Note(this._title, this._priority, this._date, {this.description});
  Note.withId(this._id,this._title, this._priority, this._date, {this.description});

  int get id => _id;
  int get priority => _priority;
  String get title => _title;
  String get desc => description;
  String get date => _date;

  set title(String title){
    /*if(title.isNotEmpty && title.length<=255) {*/_title = title;//}
  }
  set desc(String descriptions){
    description = descriptions;
  }
  set priority(int priority){
    if(priority>=0 && priority<=3) {_priority = priority;}
  }
  set date(String date){
    if(date!=null) {_date = date;}
  }


  Map<String, dynamic> toMap() => {
    'id': _id,
    'title': _title,
    'description': description,
    'priority': _priority,
    'date': _date,
  };

  factory Note.fromMap(Map<String, dynamic> map) => new Note.withId(
    map['id'],
    map['title'],
    map['priority'],
    map['date'],
    description: map['description'],
  );




}