import 'package:fcds_announcements/PageFeedFeature/Data%20Models/announcement_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:fcds_announcements/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class Announcement extends StatefulWidget {
  final AnnouncementDataModel announcement;
  final bool isAdmin;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  bool isEditing = false;
  final Function({
    required String title,
    required String body,
    required String date,
    required String redirectLink,
  })?
  onSubmit;
  Announcement({
    super.key,
    required this.announcement,
    this.isAdmin = false,
    this.onDelete,
    this.onEdit,
    this.onSubmit,
  });

  Announcement.editing({
    super.key,
    this.onSubmit,
    this.announcement = const AnnouncementDataModel(
      id: 0,
      date: null,
      title: '',
      content: '',
      redirectLink: '',
      deadline: null,
    ),
  }) : isEditing = true,
       isAdmin = false,
       onDelete = null,
       onEdit = null;

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _redirectLinkController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.announcement.title);
    _bodyController = TextEditingController(text: widget.announcement.content);
    _redirectLinkController = TextEditingController(
      text: widget.announcement.redirectLink,
    );
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _redirectLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: .symmetric(vertical: 16, horizontal: 16),
      child: Padding(
        padding: const .symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Text(
                  Dateformatter.getTimeAgo(
                    widget.announcement.date ?? DateTime.now(),
                  ),
                  style: MyTextStyle(
                    color: const Color.fromARGB(255, 80, 149, 126),
                  ),
                ),
                Spacer(),
                if (widget.isAdmin)
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                if (widget.isAdmin)
                  IconButton(
                    onPressed: widget.onEdit,
                    icon: Icon(Icons.edit, color: Colors.blue),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            widget.isEditing
                ? TextField(
                    maxLength: 15,
                    controller: _titleController,
                    style: MyTextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: .bold,
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Enter title',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: 2,
                    minLines: 1,
                    maxLengthEnforcement: null,
                  )
                : Text(
                    widget.announcement.title,
                    style: MyTextStyle(fontSize: 24, fontWeight: .bold),
                  ),
            const SizedBox(height: 8),
            widget.isEditing
                ? TextField(
                    controller: _bodyController,
                    style: MyTextStyle(
                      color: Color.fromARGB(255, 82, 102, 93),
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Enter Announcement Content',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    minLines: 1,
                    maxLines: 3,
                  )
                : Text(
                    widget.announcement.content,
                    style: MyTextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 82, 102, 93),
                    ),
                    maxLines: 3,
                  ),

            const SizedBox(height: 12),
            if (widget.announcement.redirectLink.isNotEmpty)
              OutlinedButton(
                onPressed: () {
                  final Uri url = Uri.parse(widget.announcement.redirectLink);
                  launchUrl(url);
                },
                child: Builder(
                  builder: (context) {
                    final double iconSize = 25.0;
                    final Color themeColor = const Color.fromARGB(
                      255,
                      40,
                      127,
                      111,
                    );

                    // 1. Check for Google Drive
                    if (widget.announcement.redirectLink.contains('drive')) {
                      return Row(
                        mainAxisAlignment: .center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.googleDrive,
                            color: themeColor,
                            size: iconSize,
                          ),
                          SizedBox(width: 8),
                          Text('View Attachment'),
                        ],
                      );
                    }

                    // 2. Check for Chameleon
                    if (widget.announcement.redirectLink.contains(
                      'chameleon',
                    )) {
                      return Row(
                        mainAxisAlignment: .center,
                        children: [
                          Image.asset(
                            'assets/chameleon.webp',
                            color: Color.fromARGB(255, 255, 228, 52),
                            width: 35,
                          ),
                          Text('View Attachment'),
                        ],
                      );
                    }

                    // 3. Dynamic Fallback: Safely parse domain and fetch Favicon
                    try {
                      final uri = Uri.parse(widget.announcement.redirectLink);
                      // Extract the host (e.g., "github.com")
                      final String domain = uri.host.isNotEmpty
                          ? uri.host
                          : widget.announcement.redirectLink;

                      return Row(
                        mainAxisAlignment: .center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              "https://www.google.com/s2/favicons?domain=$domain&sz=64",
                              width: iconSize,
                              height: iconSize,
                              fit: BoxFit.contain,
                              // If the API fails or network is down, fallback to a generic link icon
                              errorBuilder: (context, error, stackTrace) {
                                return Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Icon(
                                      Icons.link,
                                      color: themeColor,
                                      size: iconSize,
                                    ),
                                    SizedBox(width: 8),
                                    Text('View Attachment'),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('View Attachment'),
                        ],
                      );
                    } catch (e) {
                      // If the URL string is totally malformed and fails Uri.parse
                      return Icon(
                        Icons.link,
                        color: themeColor,
                        size: iconSize,
                      );
                    }
                  },
                ),
              ),
            if (widget.isEditing)
              OutlinedButton(
                onPressed: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      final oldLink = _redirectLinkController.text;
                      return AlertDialog(
                        title: Row(children: [Text('Attach Link')]),
                        content: TextField(
                          controller: _redirectLinkController,
                          decoration: InputDecoration(
                            hintText: 'Enter redirect link',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _redirectLinkController.text = oldLink;
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text('Attach Link'),
                    if (_redirectLinkController.text.isNotEmpty) ...[
                      SizedBox(width: 8),
                      Icon(
                        Icons.link,
                        color: Color.fromARGB(255, 40, 127, 111),
                      ),
                    ],
                  ],
                ),
              ),
            if (widget.isEditing) ...[
              SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  widget.onSubmit!(
                    title: _titleController.text,
                    body: _bodyController.text,
                    date: DateTime.now().toIso8601String(),
                    redirectLink: _redirectLinkController.text,
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
