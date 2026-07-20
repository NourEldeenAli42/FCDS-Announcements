import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddNewSchedule extends StatelessWidget {
  const AddNewSchedule({super.key, this.onSubmit});
  final Function? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: .circular(8),
        border: .all(width: 1, color: Theme.of(context).colorScheme.primary),
      ),
      margin: .all(8),
      padding: .all(8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              CircleAvatar(child: FaIcon(FontAwesomeIcons.bolt)),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'AI Study Plan',
                      style: MyTextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'No progress yet? Let AI reate a custom schedule for you using this page\'s material',
                      style: MyTextStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  child: Text(
                    'Create Schedule',
                    style: MyTextStyle(fontWeight: .bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
