//reference: github.com/felipecastrosales/Contacts/blob/master/lib/ui/home_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_learning/database/databaseHelper.dart';
import 'package:sqflite_learning/model/legenditem.dart';

class LegendScreen extends StatefulWidget {
  @override
  _LegendScreenState createState() => _LegendScreenState();
}

class _LegendScreenState extends State<LegendScreen> {
  DatabaseHelper helper = DatabaseHelper();
  List<LegendItem> legendItems = [];
  final _legendItemNameController = TextEditingController();
  String valueText;

  @override
  void initState() {
    super.initState();
    _getAllLegendItems();
  }

  void _getAllLegendItems() {
    helper.getAllLegendItems().then((list) {
      setState(() {
        legendItems = list;
        print(legendItems.length);
      });
    });
  }

  void _getSearchedLegendItems(String name) {
    helper.searchItems(name).then((list) {
      setState(() {
        legendItems = list;
        print(legendItems.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Test SQL CRUD Operations"),
          backgroundColor: Colors.blue[200],
          centerTitle: true,
        ),
        body: Column(
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: (){
              _getAllLegendItems();
            }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                child: Text("Search!"),
                onPressed: () {
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: Text("Search for items"),
                      content: TextField(
                          controller: _legendItemNameController,
                          onChanged: (value){
                            setState(() {
                              valueText = value;
                            });
                          }),
                      actions: [
                        TextButton(onPressed: () {Navigator.pop(context);},
                            child: Text("Cancel!")),
                        TextButton(onPressed: () {
                          print('Value Text = $valueText');
                          _getSearchedLegendItems(valueText);
                          Navigator.pop(context);
                        },
                            child: Text("Search!"))
                      ],
                    );
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                child: Text("Add a new Legend Item"),
                onPressed: () {
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: Text("Add a new Legend Item"),
                      content: TextField(
                        controller: _legendItemNameController,
                        onChanged: (value){
                          setState(() {
                            valueText = value;
                          });
                        }),
                      actions: [
                        TextButton(onPressed: () {Navigator.pop(context);},
                            child: Text("Cancel!")),
                        TextButton(onPressed: () {
                          print('Value Text = $valueText');
                          valueText??= 'NULL VALUE';
                          LegendItem li = LegendItem(name: valueText);
                          print('Value Text Double Check = ${li.name}');
                          helper.saveLegendItem(li);
                          _getAllLegendItems();
                          Navigator.pop(context);
                        },
                            child: Text("Add!"))
                      ],
                    );
                  });
                },
              ),
            ),
            if(legendItems.length == 0) Text('No matching results'),
            if(legendItems.length > 0) Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: legendItems.length,
                itemBuilder: (BuildContext context, int index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(title: Text(legendItems[index].name??'NULL VALUE'),
                        trailing: IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.delete),
                          onPressed: (){
                            helper.deleteListItem(legendItems[index].id);
                            setState(() {
                              legendItems.removeAt(index);
                              //Navigator.pop(context);
                            });
                            print("Delete Pressed");
                          },
                        ),
                        //BELOW IS FOR UPDATING ITEM - NEEDS WORK
                        onTap: (){
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: Text('${legendItems[index].name}'),
                              content: TextField(
                                  controller: _legendItemNameController,
                                  onChanged: (value){
                                    setState(() {
                                      valueText = value;
                                    });
                                  }),
                              actions: [
                                TextButton(onPressed: () {Navigator.pop(context);},
                                    child: Text("Cancel!")),
                                TextButton(onPressed: () {
                                  print('Value Text = $valueText');
                                  legendItems[index].name = valueText;
                                  print('Value Text Double Check = ${legendItems[index].name}');
                                  setState(() {
                                    helper.updateListItem(legendItems[index]);
                                    _getAllLegendItems();
                                  });
                                  Navigator.pop(context);
                                },
                                    child: Text("Update!"))
                              ],
                            );
                          });
                        },
                      ),
                    ),
                  );
              },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
