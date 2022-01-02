import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_class_demo/models/schedule_model.dart';

class ScheduleCollection {
  static CollectionReference schedules =
      FirebaseFirestore.instance.collection('schedules');

  static Stream<QuerySnapshot<Object?>>  getAllSchedules() => schedules.snapshots();

  static addSchedule(ScheduleModel scheduleModel) {
    schedules
        .doc(scheduleModel.sid)
        .set(scheduleModel.toFirestore())
        .whenComplete(() => print("schedule added"));
  }

  static deleteSchedule(ScheduleModel scheduleModel) {
    schedules
        .doc(scheduleModel.sid)
        .delete()
        .whenComplete(() => print("deletion complete"));
  }
}
