import 'package:material_ui/material_ui.dart';

import '../models/user_profile.dart';
import '../screens/app_shell.dart';

/// Student side. [profile] comes live from `students/{matricNo}` (see
/// AuthWrapper), so after Edit Profile the new values appear straight away.
class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) => AppShell(profile: profile);
}
