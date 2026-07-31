import 'package:flutter/material.dart';

class SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: children.asMap().entries.map((entry) {
            int index = entry.key;
            Widget child = entry.value;
            return Column(
              children: [
                child,
                if (index < children.length - 1)
                  Divider(
                    height: 1,
                    indent: 56,
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
