import 'package:carousel_slider/carousel_slider.dart';
import 'package:fcds_announcements/HomeFeature/Models/priority_deadline_data_model.dart';
import 'package:fcds_announcements/HomeFeature/Widgets/priority_deadline.dart';
import 'package:flutter/material.dart';

class DeadlinesCarousel extends StatefulWidget {
  final List<PriorityDeadlineDataModel> priorityDeadlines;
  const DeadlinesCarousel({super.key, required this.priorityDeadlines});
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<DeadlinesCarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.priorityDeadlines.map((deadline) {
            return PriorityDeadlineCard(
              priorityDeadline: deadline,
            );
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.priorityDeadlines.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withValues(alpha: _current == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
