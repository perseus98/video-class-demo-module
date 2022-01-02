import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleModel {
  String sid;
  String roomCode;
  String subject;
  DateTime scheduleDate;
  TimeOfDay startTime;
  TimeOfDay endTime;

  ScheduleModel(
      {required this.sid,
        required this.roomCode,
        required this.subject,
        required this.scheduleDate,
        required this.startTime,
        required this.endTime,
      });

  factory ScheduleModel.fromFirestore(dynamic map) {
    return ScheduleModel(
        sid: map['sid']! as String,
        roomCode: map['roomCode']! as String,
        subject: map['subject']! as String,
      scheduleDate: DateTime.parse(map['scheduleDate']),
      startTime: TimeOfDay.fromDateTime(DateTime.parse(map['startTime'])),
      endTime: TimeOfDay.fromDateTime(DateTime.parse(map['endTime'])),
    );
  }
  Map<String,dynamic> toFirestore(){
    DateTime current = DateTime.now();
    DateTime startTimeTmp = DateTime(current.year,current.month,current.day,startTime.hour,startTime.minute);
    DateTime endTimeTmp = DateTime(current.year,current.month,current.day,endTime.hour,endTime.minute);

    return {
      'sid' : sid,
      'roomCode' : roomCode,
      'subject' : subject,
      'scheduleDate' : scheduleDate.toString(),
      'startTime': startTimeTmp.toString(),
      'endTime': endTimeTmp.toString(),
    };
  }
}
