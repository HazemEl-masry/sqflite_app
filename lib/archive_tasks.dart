import 'package:flutter/material.dart';

class ArchiveTasks extends StatelessWidget {
  const ArchiveTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40.0,
            child: Text(
                "02:00 pm"
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Archive tasks",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "28 March 2023",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
