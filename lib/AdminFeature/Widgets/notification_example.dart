import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class NotificationExample extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Function(String title, String message)? onSubmit;

  const NotificationExample({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.notifications,
    this.onSubmit,
  });

  @override
  State<NotificationExample> createState() => _NotificationExampleState();
}

class _NotificationExampleState extends State<NotificationExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleFocusNode.addListener(_validateOnBlur);
    _messageFocusNode.addListener(_validateOnBlur);
  }

  @override
  void dispose() {
    _titleFocusNode.removeListener(_validateOnBlur);
    _messageFocusNode.removeListener(_validateOnBlur);
    _titleFocusNode.dispose();
    _messageFocusNode.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _validateOnBlur() {
    if (!_titleFocusNode.hasFocus && !_messageFocusNode.hasFocus) {
      _formKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: .onUserInteraction,
      child: Card(
        child: Padding(
          padding: const .all(10.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: _titleController,
                                focusNode: _titleFocusNode,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Title is required';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hint: Text(
                                    'Enter Title',
                                    style: MyTextStyle(
                                      fontSize: 18,
                                      fontWeight: .bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                style: MyTextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                minLines: 1,
                                maxLines: 2,
                              ),
                            ),
                            Text(
                              'now',
                              style: MyTextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        TextFormField(
                          controller: _messageController,
                          focusNode: _messageFocusNode,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Message is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hint: Text(
                              'Enter Message',
                              style: MyTextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          style: MyTextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                          minLines: 1,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              FilledButton(
                onPressed: widget.onSubmit != null
                    ? () {
                        if (_formKey.currentState?.validate() ?? false) {
                          widget.onSubmit!(
                            _titleController.text.trim(),
                            _messageController.text.trim(),
                          );
                          _formKey.currentState?.reset();
                        }
                      }
                    : null,
                child: Text('Send Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
