import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/ui/HomeScreen/tabs/SettingsTab.dart';
import 'package:todoapp/ui/HomeScreen/tabs/TaskTAb/TasksTab.dart';
import 'package:todoapp/ui/HomeScreen/widgets/AddTAskBottomSheet.dart';
import 'package:todoapp/ui/Login_Screen/login_Screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "Home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  DateTime selectedDate =DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => AddTAskBottomSheet());
          }),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            currentIndex: index,
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.list,
                  ),
                  label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: "")
            ]),
      ),
      body: Column(children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [AppBar(
            title: Text("To Do List"),
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginScreen.routeName,
                          (route) => false,
                    );
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: -30,
            child: Visibility(
              visible: index==0,
              child: EasyInfiniteDateTimeLine(
                showTimelineHeader: false,
                dayProps: EasyDayProps(
                  width: 58,
                  height: 79,
                  todayStyle: DayStyle(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    )
                  )
                ),
                focusDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days:365)),
                onDateChange: (newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                },
              ),
            ),
          )
          ]
        ),
        Expanded(child: index== 0
            ?TasksTab(selectedDate)
            :SettingsTab()
        ),
      ]),
    );
  }
}
