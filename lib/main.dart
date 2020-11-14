import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    // TaskModel(1, "task1", 5, 1),
    // TaskModel(2, "task2", 5, 1),
    // TaskModel(3, "task3", 5, 1),
    // TaskModel(4, "task4", 5, 1),
    // TaskModel(5, "task5", 5, 1),
  ];

  @override
  // ignore: must_call_super
  void initState() {
    // _insert();
    _query();
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
    final task = taskList[index];
    return Card(
      child: (taskList[index].time > 0)
          ? Container(
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
                                  task.title,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  task.time.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          )),
                      _playOrPause(index),
                    ],
                  )
                ],
              ),
            )
          : Container(
              child: Text(
                'Completed',
                style: TextStyle(fontSize: 20),
              ),
              height: 80,
              width: 320,
              margin: EdgeInsets.only(left: 20, top: 15),
            ),
    );
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  // bool isPlay = true;

  // ignore: missing_return
  Widget _playOrPause(int index) {
    Timer _timer;
    if (taskList[index].status == 1) {
      return IconButton(
        icon: Icon(
          Icons.play_arrow,
          size: 50,
        ),
        onPressed: () {
          startTimer(_timer, index);
          setState(() {
            taskList[index].status = 2;
            _update(taskList[index]);
          });
        },
      );
    } else if (taskList[index].status == 2) {
      return IconButton(
        icon: Icon(
          Icons.pause,
          size: 50,
        ),
        onPressed: () {
          stopTimer(_timer,index);
          setState(() {
            taskList[index].status = 1;
            // taskList[index].time=taskList[index].time;
            _update(taskList[index]);
          });
        },
      );
    }
  }

  void startTimer(Timer _timer, index) {
    const oneSec = const Duration(seconds: 1);
    int sec = 60;
    int updateTime=5;

    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (taskList[index].time < 1) {
              timer.cancel();
            } else {
              updateTime=updateTime-1;
              if(updateTime<=0){
                updateTime=5;
                // taskList[index].status=1;
                _updateByTime(taskList[index]);
              }
              sec = sec - 1;
              setState(() {
                if (sec <= 0 && taskList[index].status==2) {
                  taskList[index].time = taskList[index].time - 1;
                  sec = 60;
                }else{
                  timer.cancel();
                }
              });
            }
          },
        ),
      );
    }
  }

  void stopTimer(Timer _timer,index) {
    // _timer.;
    setState(() {
      taskList[index].time=taskList[index].time;
    });
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
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                margin: EdgeInsets.only(top: 20),
              ),
              Container(
                child: TextField(
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'time'),
                ),
                margin: EdgeInsets.only(top: 40),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: MaterialButton(
                  onPressed: () {
                    print(titleController.text);
                    print(timeController.text);
                    _insert(TaskModel(1, titleController.text,
                        int.parse(timeController.text), 1));
                  },
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

  _query() async {
    final allRows = await dbHelper.queryAllRows();

    List<TaskModel> taskList = <TaskModel>[];

    allRows.forEach((row) => taskList
        .add(TaskModel(row['_id'], row['title'], row['time'], row['status'])));

    print(taskList[0].id);
    this.taskList = taskList;
    print('database');
    setState(() {
      this.taskList = taskList;
    });
    print(taskList);
  }

  void _insert(TaskModel taskModel) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: taskModel.title,
      DatabaseHelper.columnTime: taskModel.time,
      DatabaseHelper.columnStatus: taskModel.status
    };
    final id = await dbHelper.insert(row);
    setState(() {
      taskList.clear();
      _query();
    });
    print('inserted row id: $id');
  }

  void _update(TaskModel taskModel) async {
    // row to update
    print(taskModel.id);
    print(taskModel.title);
    print(taskModel.time);
    print(taskModel.status);
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: taskModel.id,
      DatabaseHelper.columnTitle: taskModel.title,
      DatabaseHelper.columnTime: taskModel.time,
      DatabaseHelper.columnStatus: taskModel.status
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _updateByTime(TaskModel taskModel) async {
    // row to update
    print(taskModel.id);
    print(taskModel.title);
    print(taskModel.time);
    print(taskModel.status);
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: taskModel.id,
      DatabaseHelper.columnTitle: taskModel.title,
      DatabaseHelper.columnTime: taskModel.time,
      DatabaseHelper.columnStatus: 1
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete(int id) async {
    // Assuming that the number of rows is the id for the last row.
    // final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
