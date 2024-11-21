import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/firestore/Firestore_Handler.dart';
import 'package:todoapp/style/reusable_components/CustomErrorDialog.dart';
import 'package:todoapp/style/reusable_components/CustomFormField.dart';
import 'package:todoapp/style/reusable_components/CustomLoadingDialog.dart';

import '../../../firestore/model/Task.dart';
import '../../../style/constants.dart';

class AddTAskBottomSheet extends StatefulWidget {
  @override
  State<AddTAskBottomSheet> createState() => _AddTAskBottomSheetState();
}

class _AddTAskBottomSheetState extends State<AddTAskBottomSheet> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  GlobalKey<FormState> formKe =GlobalKey<FormState>();
   @override
  void initState() {
    super.initState();
    titleController =TextEditingController();
    descriptionController =TextEditingController();
  }
  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
    titleController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Form(
      key: formKe,
      child: Padding(
        
        padding: EdgeInsets.only(
          right: 16,
          left: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              Text(
                "Add New Task",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            SizedBox(
              height: 0.02*height,
            ),
            Customformfield(
                label: "Enter the task title",
                keybord: TextInputType.text,
                validate: (value){
                  if(value == null || value.isEmpty){
                    return "Plase enter the title of task";
                  }
                  return null;
                },
                controller: titleController
            ),
            SizedBox(
              height: 0.02*height,
            ),
            Customformfield(
                label: "Enter the task description of task",
                keybord: TextInputType.text,
                validate: (value){
                  if(value == null || value.isEmpty){
                    return "Plase enter the description of task";
                  }
                  return null;
                },
                controller: descriptionController
            ),
            SizedBox(
              height: 0.02*height,
            ),
            InkWell(
              onTap: () {
                  showTaskDate();
              },
              child: Text(
                selectedDate == null
                    ? "Date"
                    :DateFormat.yMd().format(selectedDate!),
                style: TextStyle(
                  fontSize: 18
                ),
              ),
            ),
            SizedBox(
              height: 0.02*height,
            ),
            ElevatedButton(onPressed: () {
              AddNewTask();
            }, child: Text("Add Task"))
          ],
        ),
      ),
    );
  }
  DateTime? selectedDate;
  showTaskDate()async{
      var date = await showDatePicker(context: context,
         initialDate: selectedDate ?? DateTime.now(),
         firstDate: DateTime.now(),
         lastDate: DateTime.now().add(Duration(
           days: 365
         )));
      setState(() {
        selectedDate = date!;
      });
  }
  AddNewTask() async {
    if (formKe.currentState!.validate()) {
      if(selectedDate != null){
        showDialog(context: context, builder: (context) => CustomLoadingDialog(),);
        await FirestoreHandler.createTask(Task(
          title: titleController.text,
          description: descriptionController.text,
          date: Timestamp.fromMicrosecondsSinceEpoch(
              selectedDate!.microsecondsSinceEpoch),
        ), FirebaseAuth.instance.currentUser!.uid);
        Navigator.pop(context);
        showDialog(context: context, builder:(context) => CustomErrorDialog(message: "Task created successfully", postiveBtnPress: () {
          Navigator.pop(context);
        },));
      }
      else{
        Constants.showToast("Please select task date");
      }
    }
  }
}
