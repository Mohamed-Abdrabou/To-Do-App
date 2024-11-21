import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/firestore/Firestore_Handler.dart';
import 'package:todoapp/style/reusable_components/CustomLoadingDialog.dart';
import '../../../../../style/constants.dart';
import '../../../../../firestore/model/Task.dart';
import '../../../../../style/reusable_components/CustomErrorDialog.dart';

class TaskItem extends StatefulWidget {
  Task task;
  TaskItem({required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Slidable(
      startActionPane:
          ActionPane(motion: BehindMotion(), extentRatio: 0.25, children: [
        SlidableAction(
          onPressed: (context) {
            DeletTask();
          },
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
          label: "Delete",
          icon: Icons.delete,
        )
      ]),
      child: Container(
        height: height * 0.11,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 0.08 * height,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(
              width: 0.02 * height,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.task.description ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            ElevatedButton(onPressed: () {
            }, child: Icon(Icons.check))
          ],
        ),
      ),
    );
  }

  DeletTask() {
    showDialog(
        context: context,
        builder: (context) => CustomErrorDialog(
              message: 'Are you sure you want to delete this task ?',
              postiveBtnPress: () async {
                showDialog(
                  context: context,
                  builder: (context) => CustomLoadingDialog(),
                );
                await FirestoreHandler.deleteTask(
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.task.id ?? "");
                Navigator.pop(context);
                Navigator.pop(context);
                Constants.showToast("Task deleted successfully");
              },
              postiveBtnTitle: "Yes",

              negativeBtnPress: () {
                Navigator.pop(context);
              },
              negativeBtnTitle: "No",
            ));
  }
}
