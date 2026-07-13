import 'package:flutter/material.dart';

class Unread extends StatelessWidget {
  final Widget child;
  final bool isUnread;
  const Unread({super.key, required this.child, required this.isUnread});

  @override
  Widget build(BuildContext context) {
    return isUnread
        ? Stack(
            children: [
              child,
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 60),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : child;
  }
}
