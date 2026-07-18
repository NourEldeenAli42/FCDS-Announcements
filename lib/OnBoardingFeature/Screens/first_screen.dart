import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        Lottie.asset('assets/screen1.lottie'),
        SizedBox(height: 20),
        Text(
          'Stay Connected to Your Campus',
          style: MyTextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: .center,
        ),
        SizedBox(height: 10),
        Text(
          'Get real-time updates and academic announcements directly from your institution.',
          style: MyTextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: .center,
        ),
      ],
    );
  }
}
