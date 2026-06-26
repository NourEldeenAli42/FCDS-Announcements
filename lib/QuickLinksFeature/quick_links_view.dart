import 'package:fcds_announcements/QuickLinksFeature/Widgets/quick_link.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuickLinksView extends StatelessWidget {
  const QuickLinksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Wrap(
          alignment: .spaceEvenly,
          children: [
            QuickLink(
              title: 'Google Drive',
              url:
                  'https://drive.google.com/drive/folders/1Cv6pwhhwu386NK1jyZLn1mWGLpz1j8De',
              icon: FontAwesomeIcons.googleDrive,
            ),
            QuickLink(
              title: 'Chameleon',
              url:
                  'https://chameleon-nu.vercel.app/specialization/computing-data-sciences',
              icon: Image.asset('assets/chameleon.webp', width: 40, height: 40),
            ),
          ],
        ),
        Text(
          'More links coming soon!',
          style: MyTextStyle(
            fontSize: 16,
            fontWeight: .w600,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
