import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  final Color color;
  final IconData icon = Icons.book;
  const SubjectTile({super.key, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: color.computeLuminance() < 0.5
              ? color.withValues(alpha: 0.2)
              : color.withValues(alpha: 0.6),
          child: Icon(icon, size: 28, color: color),
        ),
        collapsedShape: Border(),
        shape: Border(),
        title: Text(
          'Mathematics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        children: [
          ListTile(title: Text('Algebra', style: TextStyle(fontSize: 16))),
          ListTile(title: Text('Geometry', style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
