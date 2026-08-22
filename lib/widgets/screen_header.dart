import 'package:flutter/material.dart';
import '../../utils/adaptive_widgets/adaptive_widgets.dart';

/// Reusable header widget for all screens in the app.
///
/// For root-level screens (Home, Search, Saved, Settings):
///   ScreenHeader(title: 'Home')
///
/// For sub-screens with a back button:
///   ScreenHeader(title: 'About', showBackButton: true)
///
/// With trailing actions:
///   ScreenHeader(title: 'Saved', trailing: Row(...))
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    required this.title,
    this.showBackButton = false,
    this.trailing,
    super.key,
  });

  final String title;
  final bool showBackButton;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 24, left: 8, right: 8),
      child: Row(
        children: [
          if (showBackButton) ...[
            const AdaptiveBackButton(),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: showBackButton ? 28 : 34,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
