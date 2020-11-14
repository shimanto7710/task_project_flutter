import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'TaskModel.dart';
import 'database.dart';

void main() {
  runApp(
    new MaterialApp(
      title: 'Task',
      // initialRoute: MyApp.routeName,
      // routes: {
      //   // LoginPage.routeName: (context) => LoginPage(),
      //   // Signup.routeName: (context) => Signup(),
      //   HomePage.routeName: (context) => HomePage()
      // },
      theme: ThemeData(primaryColor: Colors.green, accentColor: Colors.yellow),
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final dbHelper = DatabaseHelper.instance;

  List<TaskModel> taskList = [
    TaskModel(1, "task1", 5, 1),
    TaskModel(2, "task2", 5, 1),
    TaskModel(3, "task3", 5, 1),
    TaskModel(4, "task4", 5, 1),
    TaskModel(5, "task5", 5, 1),
  ];

  @override
  void initState() {
    // _insert();
    // _query();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task'),
      ),
      body: Container(
        child: new ListView.builder(
          itemCount: taskList.length,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int index) {
            return listItem(context, index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onClickFloatingActionButton();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  _onClickFloatingActionButton() {
    showDialog();
  }

  Widget listItem(BuildContext context, int index) {
    final trip = taskList[index];
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 80,
                  width: 320,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: Text(
                          trip.title,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: Text(
                          trip.time.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
                _playOrPause(trip.status)
              ],
            )
          ],
        ),
      ),
    );
  }

  // bool isPlay = true;

  // ignore: missing_return
  Widget _playOrPause(int status) {
    if (status == 1) {
      return IconButton(icon: Icon(Icons.play_arrow,size: 50,),onPressed: (){
        setState(() {
          status=2;
        });
      },);
    } else if (status == 2) {
      return IconButton(icon: Icon(Icons.pause,size: 50,),onPressed: (){

      },);
    }
  }

  void showDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 500,
            child: _createTask(),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Widget _createTask() {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 0),
                child: Text(
                  'Create Task',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                margin: EdgeInsets.only(top: 20),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(hintText: 'time'),
                ),
                margin: EdgeInsets.only(top: 40),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();

    allRows.forEach((row) => print(row));
  }

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: 'Bob',
      DatabaseHelper.columnTime: 23,
      DatabaseHelper.columnStatus: 1
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }
}
