import 'package:flutter/material.dart';

class PriorityDeadlineCard extends StatelessWidget {
  final String title;
  final String timeLeft;

  const PriorityDeadlineCard({
    super.key,
    required this.title,
    required this.timeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 1. The Red Left Accent Border
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 8, // Adjust thickness
                color: const Color(
                  0xFFD38670,
                ), // The coral/red color from your image
              ),
            ),

            // 2. The Faded Background Icon (Warning)
            Positioned(
              right: -10,
              top: 20,
              child: Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: const Color(0xFFD38670).withValues(alpha: 0.1),
              ),
            ),

            // 3. The Content
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PRIORITY DEADLINE",
                        style: TextStyle(
                          color: Color(0xFF5D7E6D), // Muted green text
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                    ],
                  ),

                  // The "Time Left" Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F0), // Very light red/pink
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: Color(0xFFD38670),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeLeft,
                          style: const TextStyle(
                            color: Color(0xFFD38670),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
