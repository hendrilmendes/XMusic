import 'package:flutter/material.dart';
import 'package:xmusic/CustomWidgets/copy_clipboard.dart';

class MediaTile extends StatelessWidget {
  final EdgeInsetsGeometry contentPadding;
  final String title;
  final String? subtitle;
  final bool isThreeLine;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final Function()? onTap;

  const MediaTile({
    super.key,
    this.contentPadding = const EdgeInsets.only(left: 15.0),
    required this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.leadingWidget,
    this.trailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: contentPadding,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle:
          subtitle == null
              ? null
              : Text(subtitle!, overflow: TextOverflow.ellipsis),
      isThreeLine: isThreeLine,
      leading: leadingWidget,
      trailing: trailingWidget,
      onLongPress: () {
        copyToClipboard(context: context, text: title);
      },
      onTap: onTap,
    );
  }
}
