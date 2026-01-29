import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:fcds_announcements/utils/repositories/local_notifications_repository.dart';
import 'package:fcds_announcements/utils/text_style.dart';
import 'package:flutter/material.dart';

class AddReminderForm extends StatefulWidget {
  const AddReminderForm({super.key});

  @override
  State<AddReminderForm> createState() => _AddReminderFormState();
}

class _AddReminderFormState extends State<AddReminderForm> {
  late String timeText = 'Select Time';
  late String dateText = 'Select Date';
  late TimeOfDay time = TimeOfDay.now();
  late DateTime? selectedDate = DateTime.now();
  late final TextEditingController titleController = TextEditingController();
  late final TextEditingController bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  width: 2,
                  color: Color.fromARGB(255, 53, 125, 101),
                ),
              ),
              labelStyle: MyTextStyle(),
              floatingLabelBehavior: .auto,
              labelText: 'Reminder Title',
            ),
            cursorColor: Color.fromARGB(255, 53, 125, 101),
          ),
          SizedBox(height: 10),
          TextField(
            controller: bodyController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  width: 2,
                  color: Color.fromARGB(255, 53, 125, 101),
                ),
              ),
              labelStyle: MyTextStyle(),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelText: 'Reminder Body',
            ),
            cursorColor: Color.fromARGB(255, 53, 125, 101),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    showPicker(
                      context: context,
                      value: Time.fromTimeOfDay(time, 0),
                      sunrise: TimeOfDay(hour: 6, minute: 0), // optional
                      sunset: TimeOfDay(hour: 18, minute: 0), // optional
                      duskSpanInMinutes: 120, // optional
                      onChange: (newTime) {
                        time = newTime;
                        setState(() {
                          timeText =
                              '${time.hour % 12}:${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.hour >= 12 ? 'PM' : 'AM'}';
                        });
                      },
                    ),
                  );
                },
                icon: Icon(
                  Icons.access_time,
                  color: Color.fromARGB(255, 53, 125, 101),
                ),
              ),
              Text(timeText, style: MyTextStyle()),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  selectedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      dateText =
                          '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}';
                    });
                  }
                },
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: Color.fromARGB(255, 53, 125, 101),
                ),
              ),
              Text(dateText, style: MyTextStyle()),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 53, 125, 101),
            ),
            onPressed: () {
              // Schedule the notification using the entered details
              LocalNotificationsRepository().scheduleNotification(
                title: titleController.text,
                body: bodyController.text,
                scheduledDate: DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  time.hour,
                  time.minute,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Reminder Scheduled for $dateText at $timeText',
                    style: MyTextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color.fromARGB(255, 53, 125, 101),
                ),
              );
              Navigator.of(context).pop();
            },
            child: Text(
              'Add Reminder',
              style: MyTextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
