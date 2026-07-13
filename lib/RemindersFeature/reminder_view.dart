import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fcds_announcements/RemindersFeature/Widgets/event.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/Events%20Bloc/events_bloc.dart';
import 'package:fcds_announcements/RemindersFeature/bloc/Reminders%20Bloc/reminders_bloc.dart';
import 'package:fcds_announcements/RemindersFeature/repository/reminders_repository.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:fcds_announcements/utils/Widgets/unread.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timelines_plus/timelines_plus.dart';

class ReminderView extends StatelessWidget {
  const ReminderView({super.key});
  final Color color = const Color.fromARGB(255, 53, 125, 101);

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    // Load reminders when the view is built
    context.read<RemindersBloc>().add(const LoadRemindersEvent());
    context.read<EventsBloc>().add(const LoadEventsEvent());

    return RefreshIndicator(
      onRefresh: () async {
        context.read<RemindersBloc>().add(const LoadRemindersEvent());
        context.read<EventsBloc>().add(const LoadEventsEvent());
        context.read<EventsBloc>().add(SelectEventsEvent(DateTime.now()));
      },
      child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          BlocBuilder<EventsBloc, EventsState>(
            builder: (context, state) {
              if (state is EventsLoadedState && state.events.isNotEmpty) {
                // Create a set of dates that have events
                final eventDates = state.events
                    .map((event) {
                      final deadline = event.deadline;
                      if (deadline != null) {
                        return DateTime(
                          deadline.year,
                          deadline.month,
                          deadline.day,
                        );
                      }
                      return null;
                    })
                    .whereType<DateTime>()
                    .toSet();

                return EasyDateTimeLine(
                  dayProps: EasyDayProps(height: 60, width: 10),
                  initialDate: DateTime.now(),
                  timeLineProps: EasyTimeLineProps(),
                  itemBuilder: (context, date, isSelected, onTap) {
                    // Normalize the date to compare (remove time component)
                    final normalizedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                    );
                    final hasEvent = eventDates.contains(normalizedDate);
                    final isToday =
                        normalizedDate ==
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        );

                    // Get the default widget from the package
                    final dateWidget = InkWell(
                      onTap: () {
                        onTap();
                        context.read<EventsBloc>().add(
                          SelectEventsEvent(normalizedDate),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? color : Colors.transparent,
                          border: isToday && !isSelected
                              ? Border.all(color: color, width: 2)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${date.day}',
                              style: MyTextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              _getDayName(date.weekday),
                              style: MyTextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    // Wrap with Unread widget if this date has an event
                    return hasEvent
                        ? Unread(isUnread: true, child: dateWidget)
                        : dateWidget;
                  },
                );
              } else if (state is EventsLoadingState ||
                  state is EventsErrorState ||
                  state is EventsInitial ||
                  state is EventsLoadedState && state.events.isEmpty) {
                return EasyDateTimeLine(
                  dayProps: EasyDayProps(height: 60, width: 10),
                  initialDate: DateTime.now(),
                  timeLineProps: EasyTimeLineProps(),
                  itemBuilder: (context, date, isSelected, onTap) {
                    // Normalize the date to compare (remove time component)
                    final normalizedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                    );
                    final isToday =
                        normalizedDate ==
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        );

                    // Get the default widget from the package
                    final dateWidget = InkWell(
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? color : Colors.transparent,
                          border: isToday && !isSelected
                              ? Border.all(color: color, width: 2)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${date.day}',
                              style: MyTextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              _getDayName(date.weekday),
                              style: MyTextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    // Wrap with Unread widget if this date has an event
                    return dateWidget;
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          BlocBuilder<EventsBloc, EventsState>(
            builder: (context, state) {
              if (state is EventsLoadedState) {
                final eventsToShow = state.selectedEvents;
                if (eventsToShow.isEmpty) {
                  return SizedBox.shrink();
                }
                return Timeline.tileBuilder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  theme: TimelineThemeData(
                    nodePosition: 0,
                    connectorTheme: ConnectorThemeData(
                      thickness: 2,
                      color: Colors.grey[300]!,
                    ),
                    indicatorTheme: IndicatorThemeData(size: 20, color: color),
                  ),
                  builder: TimelineTileBuilder.fromStyle(
                    contentsAlign: ContentsAlign.basic,
                    contentsBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Event(announcement: eventsToShow[index]),
                    ),
                    itemCount: eventsToShow.length,
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
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
