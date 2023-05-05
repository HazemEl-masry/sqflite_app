import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'componants/componants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (BuildContext context, state) {
        var tasks = AppCubit.get(context).tasks;
        return ListView.separated(
            itemBuilder: (context, index) => buildTasksItem(
                tasks[index]
            ),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 20.0
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            itemCount: tasks.length
        );
      },
    );



    // return ListView.separated(
    //     itemBuilder: (context, index) => buildTasksItem(
    //       tasks[index]
    //     ),
    //     separatorBuilder: (context, index) => Padding(
    //       padding: const EdgeInsetsDirectional.only(
    //         start: 20.0
    //       ),
    //       child: Container(
    //         width: double.infinity,
    //         height: 1.0,
    //         color: Colors.grey[300],
    //       ),
    //     ),
    //     itemCount: tasks.length
    // );
  }
}
