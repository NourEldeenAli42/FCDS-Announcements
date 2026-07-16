import 'package:fcds_announcements/OnBoardingFeature/Screens/first_screen.dart';
import 'package:fcds_announcements/OnBoardingFeature/Screens/second_screen.dart';
import 'package:fcds_announcements/OnBoardingFeature/Screens/third_screen.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  late final PageController _pageController;
  bool onLastPage = false;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            SizedBox(width: 10),
            Image.asset('assets/logo.png', width: 40, height: 40),
          ],
        ),
        titleSpacing: 0,
        title: Text(
          'FCDS Announcements',
          style: MyTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  onLastPage = index == 2;
                });
              },
              controller: _pageController,
              children: [FirstScreen(), SecondScreen(), ThirdScreen()],
            ),
          ),
          Padding(
            padding: const .all(8.0),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    'Back',
                    style: MyTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: SwapEffect(
                    dotWidth: 8,
                    dotHeight: 8,
                    activeDotColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    if (onLastPage) {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setBool('firstTimeUser', false);
                      });
                      Navigator.of(context).pushReplacementNamed('/auth');
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    onLastPage ? 'Get Started' : 'Next',
                    style: MyTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
