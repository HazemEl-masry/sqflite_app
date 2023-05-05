// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_app/cubit/states.dart';

import '../archive_tasks.dart';
import '../done_tasks.dart';
import '../new_tasks.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;

  List<Widget> screens =
  [
    const NewTasks(),
    const DoneTasks(),
    const ArchiveTasks()
  ];

  List<String> title =
  [
    "New Tasks",
    "Done Tasks",
    "Archive Tasks"
  ];

  Database? database;
  List<Map> tasks = [];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeButtomNavBarState());
  }

  createDatabase()
  {
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version)
        {
          // id integer
          // title String
          // date String
          // time String
          // status String

          print("database created");
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)').then((value) {
            print("table created");
          }).catchError((error){
            print("error when creating table ${error.toString()}");
          });
        },
        onOpen: (database)
        {
          getDataFromDatabase(database).then((value)
          {
            tasks = value;
            print(value);
            emit(AppGetDatabaseState());
          }
          );
          print("database opened");
        }
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({required String title, required String time, required String date}) async
  {
    await database!.transaction((txn) {
      txn.rawInsert('INSERT INTO Tasks(title, time, date, status) VALUES("$title", "$time", "$date", "new")').then((value)
      {
        print("$value inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database).then((value)
        {
          tasks = value;
          print(value);
          emit(AppGetDatabaseState());
        }
        );
      }).catchError((error)
      {
        print("error when inserted new record ${error.toString()}");
      });
      return Future(() {});
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async
  {
    emit(AppGetDatabaseLoadingState());
    return await database!.rawQuery("SELECT * FROM tasks");
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeButtomSheetState());
  }
}