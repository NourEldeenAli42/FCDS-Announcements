import 'package:fcds_announcements/RemindersFeature/bloc/reminders_bloc.dart';
import 'package:fcds_announcements/RemindersFeature/repository/reminders_repository.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReminderView extends StatelessWidget {
  const ReminderView({super.key});
  final Color color = const Color.fromARGB(255, 53, 125, 101);

  @override
  Widget build(BuildContext context) {
    // Load reminders when the view is built
    context.read<RemindersBloc>().add(const LoadRemindersEvent());

    return RefreshIndicator(
      onRefresh: () async {
        context.read<RemindersBloc>().add(const LoadRemindersEvent());
      },
      child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(
            'Reminders',
            style: MyTextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          Text(
            'Manage your reminders and stay organized.',
            style: MyTextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          BlocBuilder<RemindersBloc, RemindersState>(
            builder: (context, state) {
              if (state is RemindersLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is RemindersLoadedState) {
                if (state.reminders.isEmpty) {
                  return Center(
                    child: Text(
                      'No reminders set.',
                      style: MyTextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                state.reminders.sort(
                  (a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime),
                );
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = state.reminders[index];
                    return Dismissible(
                      confirmDismiss: (direction) {
                        return showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Delete Reminder',
                                style: MyTextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                'Are you sure you want to delete the reminder "${reminder.title}"?',
                                style: MyTextStyle(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: MyTextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text(
                                    'Delete',
                                    style: MyTextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Icon(Icons.delete, color: Colors.white),
                            Spacer(),
                            Icon(Icons.delete, color: Colors.white),
                          ],
                        ),
                      ),
                      onDismissed: (direction) async {
                        await RemindersRepository().removeReminder(reminder.id);

                        if (context.mounted) {
                          context.read<RemindersBloc>().add(
                            const LoadRemindersEvent(),
                          );
                        }

                        if (context.mounted) {
                          floatingSnackBar(
                            backgroundColor: Color.fromARGB(255, 53, 125, 101),
                            message: 'Reminder "${reminder.title}" deleted.',
                            context: context,
                          );
                        }
                      },
                      key: Key(reminder.id.toString()),
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: color.computeLuminance() < 0.5
                                ? color.withValues(alpha: 0.2)
                                : color.withValues(alpha: 0.6),
                            child: Icon(Icons.alarm, size: 20, color: color),
                          ),
                          title: Text(
                            reminder.title,
                            style: MyTextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(reminder.body),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${reminder.scheduledDateTime.hour.toString().padLeft(2, '0')}:${reminder.scheduledDateTime.minute.toString().padLeft(2, '0')}',
                                style: MyTextStyle(
                                  color: Colors.grey.shade900,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${reminder.scheduledDateTime.day}/${reminder.scheduledDateTime.month}/${reminder.scheduledDateTime.year}',
                                style: MyTextStyle(
                                  color: Colors.grey.shade900,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is RemindersErrorState) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: MyTextStyle(fontSize: 18, color: Colors.red),
                  ),
                );
              } else if (state is AddingReminderState) {
                return Center(
                  child: Text(
                    'Add Reminder Form Goes Here',
                    style: MyTextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
