import 'package:fcds_announcements/RecentMessagesFeature/Widgets/recent_notification.dart';
import 'package:fcds_announcements/RecentMessagesFeature/bloc/Messages%20Bloc/messages_bloc.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesBloc(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocBuilder<MessagesBloc, MessagesState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: () {
                    context.read<MessagesBloc>().add(
                      const MarkAllMessagesAsReadEvent(),
                    );
                  },
                  child: Text(
                    'Mark all read',
                    style: MyTextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 54, 125, 101),
                      fontWeight: .w700,
                    ),
                  ),
                );
              },
            ),
          ],
          leadingWidth: 90,
          leading: InkWell(
            child: Container(
              margin: .only(left: 16),
              child: Row(
                crossAxisAlignment: .center,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                    color: const Color.fromARGB(255, 54, 125, 101),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Back',
                    style: MyTextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 54, 125, 101),
                      fontWeight: .w700,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          centerTitle: true,
          title: Text('Messages', style: MyTextStyle(fontWeight: .bold)),
        ),
        body: Padding(
          padding: const .symmetric(horizontal: 16),
          child: Column(
            children: [
              BlocBuilder<MessagesBloc, MessagesState>(
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: .symmetric(vertical: 12),
                    child: TextField(
                      style: MyTextStyle(),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hint: Text(
                          'Search messages...',
                          style: MyTextStyle(color: Colors.grey[600]),
                          textDirection: null,
                        ),
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        context.read<MessagesBloc>().add(
                          SearchMessagesEvent(value),
                        );
                      },
                    ),
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<MessagesBloc, MessagesState>(
                  builder: (context, state) {
                    if (state is MessagesInitial) {
                      context.read<MessagesBloc>().add(
                        const LoadMessagesEvent(),
                      );
                      return Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 54, 125, 101),
                          ),
                        ),
                      );
                    } else if (state is MessagesLoaded) {
                      final messages = state.messages;
                      if (messages.isEmpty) {
                        return Center(
                          child: Text(
                            'No messages available.',
                            style: MyTextStyle(fontSize: 16),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Dismissible(
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            key: Key(message.id.toString()),
                            onDismissed: (direction) {
                              context.read<MessagesBloc>().add(
                                DeleteMessageEvent(message.id),
                              );
                            },
                            child: InkWell(
                              child: RecentNotification(notification: message),
                              onTap: () {
                                context.read<MessagesBloc>().add(
                                  MarkMessageAsReadEvent(message.id),
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else if (state is MessagesError) {
                      return Center(
                        child: Text(
                          'Failed to load messages.',
                          style: MyTextStyle(fontSize: 16),
                        ),
                      );
                    } else {
                      return Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 54, 125, 101),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
