import 'package:fcds_announcements/HomeFeature/Models/priority_deadline_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PriorityDeadlineCard extends StatefulWidget {
  final PriorityDeadlineDataModel priorityDeadline;
  bool isEditing = false;
  Function({
    required String title,
    required DateTime deadline,
    required bool notificationEnabled,
  })?
  onSubmit;

  PriorityDeadlineCard({super.key, required this.priorityDeadline});

  PriorityDeadlineCard.editing({super.key, required this.onSubmit})
    : priorityDeadline = PriorityDeadlineDataModel(
        title: '',
        remainingTime: '',
      ),
      isEditing = true;

  @override
  State<PriorityDeadlineCard> createState() => _PriorityDeadlineCardState();
}

class _PriorityDeadlineCardState extends State<PriorityDeadlineCard> {
  late final TextEditingController _titleController;
  DateTime? _selectedDeadline;
  TimeOfDay? _selectedTime;
  bool _notificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.priorityDeadline.title,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 1. The Red Left Accent Border
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 8, // Adjust thickness
                color: const Color(
                  0xFFD38670,
                ), // The coral/red color from your image
              ),
            ),

            // 2. The Faded Background Icon (Warning)
            Positioned(
              right: -10,
              top: 20,
              child: Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: const Color(0xFFD38670).withValues(alpha: 0.1),
              ),
            ),

            // 3. The Content
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "PRIORITY DEADLINE",
                        style: TextStyle(
                          color: Color(0xFF5D7E6D), // Muted green text
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Spacer(),
                      if (widget.isEditing)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _notificationEnabled = !_notificationEnabled;
                            });
                          },
                          child: Icon(
                            Icons.campaign,
                            color: _notificationEnabled
                                ? Color(0xFFD38670)
                                : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  widget.isEditing
                      ? TextField(
                          controller: _titleController,
                          style: MyTextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1E1E1E),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Title',
                            hintStyle: MyTextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey[600],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        )
                      : Text(
                          widget.priorityDeadline.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                  InkWell(
                    onTap: widget.isEditing
                        ? () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDeadline ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                _selectedDeadline = pickedDate;
                              });
                              if (context.mounted) {
                                _selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                              }
                              if (_selectedTime != null) {
                                setState(() {
                                  _selectedDeadline = DateTime(
                                    _selectedDeadline!.year,
                                    _selectedDeadline!.month,
                                    _selectedDeadline!.day,
                                    _selectedTime!.hour,
                                    _selectedTime!.minute,
                                  );
                                });
                              }
                            }
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF2F0), // Very light red/pink
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: _selectedDeadline != null
                                ? Color(0xFFD38670)
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.isEditing
                                ? 'Tap to Select Deadline'
                                : widget.priorityDeadline.remainingTime,
                            style: MyTextStyle(
                              color: Color(0xFFD38670),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.isEditing) ...[
                    const SizedBox(height: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Color(0xFFD38670),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: widget.onSubmit != null
                          ? () => widget.onSubmit!(
                              deadline: _selectedDeadline!,
                              title: _titleController.text,
                              notificationEnabled: _notificationEnabled,
                            )
                          : null,
                      child: Text(
                        'Submit',
                        style: MyTextStyle(color: Colors.white),
                      ),
                    ),
                  ],

                  // The "Time Left" Chip
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
