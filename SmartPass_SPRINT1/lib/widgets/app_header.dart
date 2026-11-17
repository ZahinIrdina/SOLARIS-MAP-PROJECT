import 'package:flutter/material.dart';import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Maroon top bar: hamburger on the left, optional centred serif title,
/// settings cog on the right.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    this.title,
    this.onSettings,
    this.showBack = false,
  });

  final String? title;
  final VoidCallback? onSettings;

  /// Pushed screens show a back arrow instead of the hamburger.
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.maroon,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 64,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: showBack
          ? const BackButton()
          : Builder(
              builder: (context) => IconButton(
                tooltip: 'Menu',
                icon: const Icon(Icons.menu, size: 26),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
      title: title == null
          ? null
          : FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title!,
                style: AppFonts.serif(
                  size: 20,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
      actions: [
        if (onSettings != null)
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined, size: 28),
            onPressed: onSettings,
          ),
        const SizedBox(width: 4),
      ],
    );
  }
}
