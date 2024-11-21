import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/firestore/Firestore_Handler.dart';
import 'package:todoapp/ui/HomeScreen/tabs/TaskTAb/widgets/TaskItem.dart';

import '../../../../firestore/model/Task.dart';

class TasksTab extends StatelessWidget {
  DateTime selectedDate;
  static const routeName = "Tasks";
  TasksTab(this.selectedDate);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: FirestoreHandler.getTasksListen(FirebaseAuth.instance.currentUser!.uid,selectedDate),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError){
            return Column(
              children: [
                Text(snapshot.error.toString())
              ],
            );
          }
          List<Task> tasks = snapshot.data??[];
          return Padding(
            padding: EdgeInsets.all(10),
            child: ListView.separated(
              itemBuilder: (context, index) => TaskItem(task: tasks[index],),
              separatorBuilder: (context, index) => SizedBox(
                  height:0.02*height
              ),
              itemCount: tasks.length,
            ),
          );
        },
    );
  }
}
