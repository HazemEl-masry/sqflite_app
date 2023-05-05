import 'package:flutter/material.dart';

Widget buildTasksItem(Map model) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 40.0,
        child: Text(
            "${model["time"]}"
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${model["title"]}",
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            "${model["date"]}",
            style: const TextStyle(
                fontSize: 18.0,
                color: Colors.grey
            ),
          ),
        ],
      )
    ],
  ),
);