// ignore_for_file: avoid_print
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_app/cubit/cubit.dart';

import 'cubit/states.dart';


class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              // condition: tasks.length > 0,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            //tasks.length == 0 ? const Center(child: CircularProgressIndicator()) : screens[currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: ()
              {
                if(cubit.isBottomSheetShown)
                {
                  cubit.insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text);
                  // insertToDatabase(
                  //   title: titleController.text,
                  //   time: timeController.text,
                  //   date: dateController.text,).then(
                  //         (value) => {
                  //       getDataFromDatabase(database).then((value)
                  //       {
                  //         Navigator.pop(context);
                  //         // setState(() {
                  //         //   isBottomSheetShown = false;
                  //         //   fabIcon = Icons.edit;
                  //         //   tasks = value;
                  //         //   print(tasks);
                  //         // });
                  //       })
                  //     }
                  // );

                } else
                {
                  scaffoldKey.currentState?.showBottomSheet((context) => Container(
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
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
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
        },
      ),
    );
  }
}
