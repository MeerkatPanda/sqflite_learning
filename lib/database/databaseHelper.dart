import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_learning/database/TableColumnNames.dart';
import 'package:sqflite_learning/model/legenditem.dart';

class DatabaseHelper{

  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();
  Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'items.db');
    return await openDatabase(path, version: 1,
    onCreate: (db, newerVersion) async {
      await db.execute('''
      CREATE TABLE $tableLegend($columnid INTEGER PRIMARY KEY, $columnname TEXT);
      ''');
      await db.rawInsert('''
      INSERT INTO $tableLegend($columnname) VALUES ('Reminder');
      ''');
    });
  }

  //Save New Item (Insert)
  Future<LegendItem> saveLegendItem(LegendItem li) async{
    var dbLegend = await db;
    print(li.name);
    li.id = await dbLegend.insert('$tableLegend', li.toMap());
    return li;
  }

  //Get All Items
  Future<List> getAllLegendItems() async {
    var dbLegend = await db;
    List listMap = await dbLegend.rawQuery('SELECT * FROM $tableLegend');
    var listItems = <LegendItem>[];
    for (Map m in listMap){
      listItems.add(LegendItem.fromMap(m));
    }
    return listItems;
  }

  //Delete Function
  Future<int> deleteListItem(int id) async{
    var dbLegend = await db;
    return await dbLegend.delete('$tableLegend', where: '$columnid = ?',
    whereArgs: [id]);
  }

  //Update Function
  Future<int> updateListItem(LegendItem legenditem) async{
    var dbLegend = await db;
    return await dbLegend.update('$tableLegend', legenditem.toMap(),
    where: '$columnid = ?', whereArgs: [legenditem.id]);
  }

  Future<List<LegendItem>> searchItems(String name) async{
    var dbLegend = await db;
    List<Map> maps = await dbLegend.query('$tableLegend',
    columns: [columnid, columnname],
      where: '$columnname = ?',
      whereArgs: [name]);
    print("maps Length: " + maps.length.toString());
    var listResults = <LegendItem>[];
    if(maps.isNotEmpty){
      print("Maps is not Empty");
      for(Map m in maps){
        listResults.add(LegendItem.fromMap(m));
      }
    }
    return listResults;
  }
}


