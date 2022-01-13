import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_class_demo/firebase/firestore/schedule_collection.dart';
import 'package:video_class_demo/models/schedule_model.dart';
import 'package:video_class_demo/screens/auth_screen.dart';
import 'package:video_class_demo/screens/schedule_class_screen.dart';
import 'package:video_class_demo/widgets/builder_widgets/builder_progress_indicator.dart';
import 'package:video_class_demo/widgets/screen_component_widgets/schedule_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTeacher = true;
  GlobalKey<ScaffoldState> homeSceenKey = GlobalKey<ScaffoldState>();

  handleSignOut() async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeSceenKey,
      drawer: _homeDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Home Screen"),
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => homeSceenKey.currentState?.openDrawer(),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: ScheduleCollection.getAllSchedules(),
              builder: (context, scheduleSnapshots) {
            // print(scheduleSnapshots.connectionState.toString());
            if (scheduleSnapshots.hasError) {
              return SliverFillRemaining(
                child: Center(
                  child: Text("error : ${scheduleSnapshots.error}"),
                ),
              );
            }
            switch (scheduleSnapshots.connectionState) {
              case ConnectionState.active:
              case ConnectionState.done:
                List<QueryDocumentSnapshot<Object?>>? scheduleDataList =
                    scheduleSnapshots.data?.docs;
                if (scheduleDataList!.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text("No schedules found on the cloud"),
                    ),
                  );
                }
                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  ScheduleModel scheduleModel =
                      ScheduleModel.fromFirestore(scheduleDataList[index]);
                  return ScheduleCardWidget(scheduleModel: scheduleModel,);
                },childCount: scheduleDataList.length));
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const SliverFillRemaining(
                  child: Center(
                    child: BuilderProgressIndicator(),
                  ),
                );
            }
          }),
        ],
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleClassScreen(restorationId: 'schedule_class'))),
              label: const Text("Schedule Class"),
            )
          : const Text(""),
    );
  }

  Drawer _homeDrawer() => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu Options'),
            ),
            Text(FirebaseAuth.instance.currentUser?.email.toString() ?? "none"),
            SwitchListTile(
               title: const Text("Teacher Mode:"),
                value: isTeacher,
                onChanged: (newValue) {
                  Navigator.pop(context);
                  setState(() {
                    isTeacher = newValue;
                  });
                }),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () => handleSignOut(),
            ),
            ListTile(
              title: const Text('Exit'),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      );
}
