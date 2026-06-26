import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/Reminders%20Bloc/reminders_bloc.dart';
import 'package:fcds_announcements/utils/repositories/local_notifications_repository.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddReminderForm extends StatefulWidget {
  final bool onReminderScreen;
  const AddReminderForm({super.key, this.onReminderScreen = false});

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
  String? titleError;
  String? bodyError;
  bool dateErrored = false;
  bool timeErrored = false;

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
              errorText: titleError,
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
              errorText: bodyError,
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
              !timeErrored
                  ? Text(timeText, style: MyTextStyle())
                  : Text(
                      timeText,
                      style: MyTextStyle(
                        color: const Color.fromARGB(255, 212, 35, 35),
                      ),
                    ),
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
              !dateErrored
                  ? Text(dateText, style: MyTextStyle())
                  : Text(
                      dateText,
                      style: MyTextStyle(
                        color: const Color.fromARGB(255, 212, 35, 35),
                      ),
                    ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 53, 125, 101),
            ),
            onPressed: () {
              // Validate inputs
              setState(() {
                titleError = titleController.text.trim().isEmpty
                    ? 'Please enter a title'
                    : null;
                bodyError = bodyController.text.trim().isEmpty
                    ? 'Please enter a body'
                    : null;
                dateText == 'Select Date'
                    ? dateErrored = true
                    : dateErrored = false;
                timeText == 'Select Time'
                    ? timeErrored = true
                    : timeErrored = false;
              });

              // If there are errors, don't proceed
              if (titleError != null || bodyError != null) {
                return;
              }

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
              floatingSnackBar(
                message: 'Reminder Scheduled for $dateText at $timeText',
                backgroundColor: Color.fromARGB(255, 53, 125, 101),
                context: context,
              );
              if (widget.onReminderScreen) {
                context.read<RemindersBloc>().add(LoadRemindersEvent());
              }
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
