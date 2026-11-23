import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:material_ui/material_ui.dart';

import '../models/user_profile.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/profile_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile.fullName);
  late final _phone = TextEditingController(text: widget.profile.phone);
  late final _faculty = TextEditingController(text: widget.profile.faculty);
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _faculty.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await FirestoreService.instance.updateProfile(
        widget.profile.uid,
        fullName: _name.text.trim(),
        phone: _phone.text.trim(),
        faculty: _faculty.text.trim(),
      );
      navigator.pop();
      messenger.showSnackBar(const SnackBar(content: Text('Profile updated')));
    } on FirebaseException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.message ?? 'Could not save your profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Edit Profile', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ProfileAvatar(size: 140, photoUrl: widget.profile.photoUrl),
              const SizedBox(height: 28),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(
                    Icons.account_circle_outlined,
                    color: AppColors.maroon,
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.profile.email,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline, color: AppColors.maroon),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: AppColors.maroon,
                  ),
                ),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return null;
                  return RegExp(r'^[0-9+\-\s]{8,15}$').hasMatch(t)
                      ? null
                      : 'Enter a valid phone number';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _faculty,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Faculty',
                  prefixIcon: Icon(
                    Icons.school_outlined,
                    color: AppColors.maroon,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
