import 'package:flutter/material.dart';
import 'package:video_class_demo/firebase/firestore/schedule_collection.dart';
import 'package:video_class_demo/models/schedule_model.dart';
import 'package:uuid/uuid.dart';
import 'package:video_class_demo/screens/home_screen.dart';

var uuid = Uuid();

class ScheduleClassScreen extends StatefulWidget {
  const ScheduleClassScreen({Key? key, this.restorationId}) : super(key: key);
  final String? restorationId;

  @override
  _ScheduleClassScreenState createState() => _ScheduleClassScreenState();
}

class _ScheduleClassScreenState extends State<ScheduleClassScreen>
    with RestorationMixin {
  final _formKey = GlobalKey<FormState>();
  final subjectTextController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime =
  TimeOfDay(hour: TimeOfDay
      .now()
      .hour + 1, minute: TimeOfDay
      .now()
      .minute);

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
  RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(BuildContext context,
      Object? arguments,) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2022),
          lastDate: DateTime(2023),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value
                  .month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Class Form"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: [
            TextFormField(
              controller: subjectTextController,
              decoration: InputDecoration(labelText: "Subject :"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextButton(
                onPressed: () {
                  _restorableDatePickerRouteFuture.present();
                },
                child: Text(
                    'Selected Date : ${_selectedDate.value.day}/${_selectedDate
                        .value.month}/${_selectedDate.value.year} ')),
            TextButton(
                onPressed: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    initialTime: startTime,
                    context: context,
                  );
                  startTime = selectedTime!;
                  endTime = TimeOfDay(
                    hour: selectedTime.hour + 1,
                    minute: selectedTime.minute,
                  );

                  setState(() {});
                },
                child: Text(
                    'Start Time : ${startTime.hour} : ${startTime.minute}')),
            TextButton(
                onPressed: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    initialTime: endTime,
                    context: context,
                  );
                  if (startTime.hour < endTime.hour) {
                    endTime = selectedTime!;
                    setState(() {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("End time can't be earlier than start")));
                  }
                },
                child: Text('End Time : ${endTime.hour} : ${endTime.minute}')),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    var sid = uuid.v1();
                    ScheduleModel scheduleModel = ScheduleModel(sid: sid,
                        roomCode: sid,
                        subject: subjectTextController.text,
                        scheduleDate: _selectedDate.value,
                        startTime: startTime,
                        endTime: endTime);
                    ScheduleCollection.addSchedule(scheduleModel);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
