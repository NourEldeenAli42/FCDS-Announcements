import 'package:fcds_announcements/PageFeedFeature/page_feed_view.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class UrgentAnnouncement extends StatefulWidget {
  final String chipText;
  final String titleText;
  final String bodyText;
  final String timeText;
  final int pageId;
  final String redirectLink;
  final bool isEditing;
  bool notificationEnabled = true;
  final void Function({
    required String chipText,
    required String title,
    required String body,
    required bool notificationEnabled,
    required String redirectLink,
  })?
  onSubmit;
  UrgentAnnouncement({
    super.key,
    required this.chipText,
    required this.titleText,
    required this.bodyText,
    required this.timeText,
    required this.pageId,
    required this.redirectLink,
    this.isEditing = false,
    this.onSubmit,
    this.notificationEnabled = true,
  });

  UrgentAnnouncement.editing({super.key, this.onSubmit})
    : chipText = '',
      titleText = '',
      bodyText = '',
      timeText = '',
      redirectLink = '',
      pageId = 0,
      isEditing = true,
      notificationEnabled = true;

  @override
  State<UrgentAnnouncement> createState() => _UrgentAnnouncementState();
}

class _UrgentAnnouncementState extends State<UrgentAnnouncement> {
  final chipController = TextEditingController();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final redirectLinkController = TextEditingController();

  @override
  void dispose() {
    chipController.dispose();
    titleController.dispose();
    bodyController.dispose();
    redirectLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 54, 125, 101),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: .all(32),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Chip(
                label: widget.isEditing
                    ? IntrinsicWidth(
                        child: TextField(
                          maxLength: 15,
                          controller: chipController,
                          style: MyTextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            counterText: '',
                            hintText: 'Enter chip text',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: 1,
                          minLines: 1,
                          maxLengthEnforcement: null,
                        ),
                      )
                    : Text(widget.chipText),
                backgroundColor: Color(0xEE5e9784),
                shape: StadiumBorder(),
                side: BorderSide(color: Colors.transparent),
              ),
              widget.isEditing
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          widget.notificationEnabled =
                              !widget.notificationEnabled;
                        });
                      },
                      icon: Icon(
                        Icons.campaign,
                        color: widget.notificationEnabled
                            ? Colors.white
                            : Colors.white38,
                      ),
                    )
                  : Icon(Icons.campaign, color: Colors.white),
            ],
          ),
          widget.isEditing
              ? Column(
                  mainAxisSize: .min,
                  children: [
                    TextField(
                      maxLength: 30,
                      controller: titleController,
                      style: MyTextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: .bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Enter title',
                        hintStyle: MyTextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: 1,
                      minLines: 1,
                    ),
                    TextField(
                      controller: bodyController,
                      style: MyTextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: 'Enter Announcement Content',
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ],
                )
              : RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.titleText}\n',
                        style: MyTextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: .bold,
                        ),
                      ),
                      TextSpan(
                        text: widget.bodyText,
                        style: MyTextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Icon(Icons.access_time, color: Colors.white70, size: 16),
              SizedBox(width: 4),
              Text(
                'Posted ${widget.isEditing ? 'Now' : widget.timeText}',
                style: MyTextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              FilledButton.tonal(
                onPressed: () {
                  if (!widget.isEditing) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            PageFeedView(pageId: widget.pageId),
                      ),
                    );
                  }
                },
                child: Text('View Announcement'),
              ),
              if (widget.isEditing)
                IconButton(
                  onPressed: () {
                    if (widget.isEditing) {
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Redirect Link',
                                    style: MyTextStyle(
                                      fontSize: 18,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    controller: redirectLinkController,
                                    style: MyTextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText: 'Enter redirect link',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  icon: Icon(Icons.link, color: Colors.white),
                ),

              if (!widget.isEditing && widget.redirectLink.isNotEmpty)
                IconButton(
                  onPressed: () {
                    final url = Uri.parse(widget.redirectLink);
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                  icon: Icon(Icons.link, color: Colors.white),
                ),
            ],
          ),
          if (widget.isEditing)
            FilledButton(
              onPressed: () {
                widget.onSubmit?.call(
                  chipText: chipController.text,
                  title: titleController.text,
                  body: bodyController.text,
                  notificationEnabled: widget.notificationEnabled,
                  redirectLink: redirectLinkController.text,
                );
              },
              child: Text('Submit'),
            ),
        ],
      ),
    );
  }
}
