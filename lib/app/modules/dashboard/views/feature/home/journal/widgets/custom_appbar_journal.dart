import 'package:flutter/material.dart';
import 'package:sehati/app/common/localization/app_strings.dart';

class CustomAppbarJournal extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;

  const CustomAppbarJournal({
    super.key,
    this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      elevation: 2,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        title ?? AppStrings.get(AppStrings.menuKeyJournalTitle),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
