import 'package:fcds_announcements/OnBoardingFeature/Widgets/lottie_animation.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            LottieAnimation(
              assetLink:
                  'https://lottie.host/508c5d1e-9ec2-40e8-9048-a848f1f9ee09/GAJHm9EFsQ.json',
            ),
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