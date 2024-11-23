import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/firestore/Firestore_Handler.dart';
import 'package:todoapp/style/reusable_components/CustomLoadingDialog.dart';
import 'package:todoapp/ui/HomeScreen/widgets/Edit_Task.dart';
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
          ActionPane(motion: BehindMotion(), extentRatio: 0.5, children: [
        SlidableAction(
          onPressed: (context) {
            DeletTask();
          },
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(10),
          label: "Delete",
          icon: Icons.delete,
        ),
        SizedBox(
          width:3,
        ),
        SlidableAction(
          onPressed: (context) {
           Navigator.pushNamed(context, EditTask.routeName,arguments: widget.task);
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
          label: "Edit",
          icon: Icons.edit,
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
                  color: widget.task.isDone == false
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(
              width: 0.02 * height,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.task.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: widget.task.isDone == false
                          ? Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.primary)
                          : Theme.of(context).textTheme.titleMedium),
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
            widget.task.isDone == false
                ? ElevatedButton(
                    onPressed: () {
                      FirestoreHandler.editIsDone(
                          FirebaseAuth.instance.currentUser!.uid,
                          widget.task.id.toString(),
                          true);
                    },
                    child: Icon(Icons.check))
                : GestureDetector(
                    onTap: () {
                      FirestoreHandler.editIsDone(
                          FirebaseAuth.instance.currentUser!.uid,
                          widget.task.id.toString(),
                          false);
                    },
                    child: Text(
                      "Done!",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
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
