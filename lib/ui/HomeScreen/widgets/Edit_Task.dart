import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/style/reusable_components/CustomFormField.dart';

import '../../../firestore/Firestore_Handler.dart';
import '../../../firestore/model/Task.dart';
import '../../../style/constants.dart';
import '../../../style/reusable_components/CustomErrorDialog.dart';
import '../../../style/reusable_components/CustomLoadingDialog.dart';

class EditTask extends StatefulWidget {
  static const String routeName ="Edit Task";

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  GlobalKey<FormState> formKey =GlobalKey<FormState>();
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
    var task = ModalRoute.of(context)?.settings.arguments as Task;
    double height = MediaQuery.of(context).size.height;
    titleController.text = task.title??"";
    descriptionController.text = task.description??"";
    String id = task.id.toString();
    var time =DateTime.fromMicrosecondsSinceEpoch(Timestamp.fromMicrosecondsSinceEpoch(task.date!.microsecondsSinceEpoch).microsecondsSinceEpoch);
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
      ),
      body: Card(
        margin: EdgeInsets.only(
          right: 30,
          left: 30,
          top: 10,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Edit Task",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(
                    height:0.07*height ,
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
                      controller: titleController,
                  ),
                  SizedBox(
                    height:0.03*height ,
                  ),
                  Customformfield(
                    label: "Enter the description of task",
                    keybord: TextInputType.text,
                    validate: (value){
                      if(value == null || value.isEmpty){
                        return "Plase enter the description of task";
                      }
                      return null;
                    },
                    controller: descriptionController,
                  ),
                  SizedBox(
                    height: 0.05*height,
                  ),
                  Align(
                    alignment:Alignment.centerLeft,
                      child: Text("Select Date",style: Theme.of(context).textTheme.titleSmall,)),
                  SizedBox(
                    height:0.03*height ,
                  ),
                  InkWell(
                    onTap: () {
                      showTaskDate();
                    },
                    child: Text(
                      selectedDate == null
                          ? DateFormat('MM/dd/yyyy').format(time)
                          :DateFormat.yMd().format(selectedDate!),
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0.1*height,
                  ),
                  ElevatedButton(onPressed: () {
                    editTaskbtn(id,task);
                  }, child: Text("Edit Task"))
                ],
              ),
            ),
          ),
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
      selectedDate = date;
    });
  }
  editTaskbtn(String taskId , Task task) async {
    if (formKey.currentState!.validate()) {
      showDialog(context: context, builder: (context) => CustomLoadingDialog(),);
      Task newTask = Task(
        date: Timestamp.fromMicrosecondsSinceEpoch(
            selectedDate!.microsecondsSinceEpoch),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
      );
        await FirestoreHandler.editTask(
            FirebaseAuth.instance.currentUser!.uid,
            taskId,
            newTask
        );
        Navigator.pop(context);
        showDialog(context: context, builder:(context) => CustomErrorDialog(message: "Edit Task successfully", postiveBtnPress: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },));
    }
  }

}
