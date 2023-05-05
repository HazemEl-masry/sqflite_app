// ignore_for_file: avoid_print, non_constant_identifier_names
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_app/archive_tasks.dart';
import 'package:sqflite_app/done_tasks.dart';
import 'package:sqflite_app/new_tasks.dart';

import 'constans/constans.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {

  int currentIndex = 0;

  Database? database;

  var ScaffoldKey = GlobalKey<ScaffoldState>();

  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScaffoldKey,
      appBar: AppBar(
        title: Text(title[currentIndex]),
      ),
      body: ConditionalBuilder(
        condition: tasks.length > 0,
        builder: (context) => screens[currentIndex],
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
      //tasks.length == 0 ? const Center(child: CircularProgressIndicator()) : screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          if(isBottomSheetShown)
          {
            insertToDatabase(
              title: titleController.text,
              time: timeController.text,
              date: dateController.text,).then(
                    (value) => {
                      getDataFromDatabase(database).then((value)
                      {
                        Navigator.pop(context);
                        setState(() {
                          isBottomSheetShown = false;
                          fabIcon = Icons.edit;
                          tasks = value;
                          print(tasks);
                        });
                      })
                }
            );

          } else
          {
            ScaffoldKey.currentState?.showBottomSheet((context) => Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      // validator: (value) {
                      //   if(value == null || value.isEmpty){}
                      //   return "txt must not empty";
                      // },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        labelText: "Task title",
                        prefixIcon: const Icon(Icons.text_fields)
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: timeController,
                      onTap: () {
                        showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value)
                        {
                          timeController.text = value!.format(context).toString();
                          print(value.format(context));
                        }
                        );
                      },
                      keyboardType: TextInputType.datetime,
                      // validator: (value) {
                      //   if(value == null || value.isEmpty){}
                      //   return null;
                      // },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                          labelText: "Task time",
                          prefixIcon: const Icon(Icons.access_time)
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: dateController,
                      onTap: () {
                        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.parse("2028-05-15")).then((value)
                        {
                          // dateController.text = value!.format(context).toString();
                          // print(value.format(context));
                          dateController.text = (DateFormat.yMMMd().format(value!));
                          print(value);
                        }
                        );
                      },
                      keyboardType: TextInputType.datetime,
                      // validator: (value) {
                      //   if(value == null || value.isEmpty){}
                      //   return null;
                      // },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                          labelText: "Task date",
                          prefixIcon: const Icon(Icons.date_range)
                      ),
                    ),
                  ],
                ),
              ),
            )
            ).closed.then((value) {
              isBottomSheetShown = false;
              setState(() {
              fabIcon = Icons.edit;});
            });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        elevation: 0.0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu),
            label: "New Tasks"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: "Done"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label: "Archive"
          ),
        ],
      ),
    );
  }

  createDatabase() async
  {
    database = await openDatabase(
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
          setState(() {
            tasks = value;
            print(tasks);
          });
        }
        );
        print("database opened");
      }
    );
  }

  insertToDatabase({required String title, required String time, required String date}) async
  {
    await database!.transaction((txn) {
      txn.rawInsert('INSERT INTO Tasks(title, time, date, status) VALUES("$title", "$time", "$date", "new")').then((value)
      {
        print("$value inserted successfully");
      }).catchError((error)
      {
        print("error when inserted new record ${error.toString()}");
      });
      return Future(() {});
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async
  {
    return await database!.rawQuery("SELECT * FROM tasks");
  }

}
