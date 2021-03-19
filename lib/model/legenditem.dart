import 'package:sqflite_learning/database/TableColumnNames.dart';

class LegendItem{
  int id;
  String name;

  LegendItem({String this.name});

  LegendItem.fromMap(Map map){
    id = map[columnid];
    name = map[columnname];
  }

  Map toMap(){
    var map = <String, dynamic>{
      columnname: name,
    };
    if (id != null){
      map[columnid] = id;
    }
    return map;
  }

  @override
  String toString(){
    return 'id: $id -- name: $name';
  }
}