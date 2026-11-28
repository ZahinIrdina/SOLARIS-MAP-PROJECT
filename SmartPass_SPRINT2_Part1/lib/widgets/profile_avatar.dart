import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// Light-grey circle with the pink "image" glyph from the wireframe.
/// Shows the user's photo instead when `photoUrl` is set.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.size, this.photoUrl = ''});

  final double size;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      Icons.image_outlined,
      color: AppColors.placeholderAccent,
      size: (size * 0.16).clamp(16, 40).toDouble(),
    );

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.placeholder,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: photoUrl.isEmpty
          ? placeholder
          : Image.network(
              photoUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => placeholder,
            ),
    );
  }
}
