import 'package:flutter/material.dart';
import 'package:video_class_demo/models/schedule_model.dart';

class ScheduleCardWidget extends StatelessWidget {
  const ScheduleCardWidget({Key? key, required this.scheduleModel})
      : super(key: key);
  final ScheduleModel scheduleModel;

  @override
  Widget build(BuildContext context) {
    String scheduledDate =
        "Date :  ${scheduleModel.scheduleDate.day} / ${scheduleModel.scheduleDate.month} / ${scheduleModel.scheduleDate.year}";
    String scheduledTime =
        " Time : ${scheduleModel.startTime.hour} : ${scheduleModel.startTime.minute} to ${scheduleModel.endTime.hour} : ${scheduleModel.endTime.minute} ";
    return Container(
      height: MediaQuery.of(context).size.width * 0.3,
      width: MediaQuery.of(context).size.width * 0.7,
      color: Colors.black12,
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(15.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: Text("Subject : " + scheduleModel.subject)),
              Flexible(child: Text(scheduledDate)),
              Flexible(child: Text(scheduledTime)),

            ],
          ),
          ElevatedButton(onPressed: () => print("pressed"), child: Text("Join"))
        ],
      ),
    );
  }
}
