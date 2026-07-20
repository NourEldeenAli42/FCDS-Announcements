import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressTrackerBar extends StatelessWidget {
  final double percentage;
  const ProgressTrackerBar({super.key, this.percentage = 0.5});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Progress Tracker',
                style: MyTextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                '${(percentage * 100).toStringAsFixed(0)}%',
                style: MyTextStyle(
                  fontWeight: .bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          LinearPercentIndicator(
            barRadius: .circular(8),
            percent: percentage,
            progressColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        ],
      ),
    );
  }
}
