import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController emailController = TextEditingController();

  final Color maroon = const Color(0xFFA00000);

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your university email address.'),
        ),
      );
      return;
    }

    // Call the ViewModel to handle the Firebase logic
    final success = await context.read<AuthViewModel>().resetPassword(email);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'If an account exists for this email, a reset link will be sent.',
          ),
          backgroundColor: Colors.green,
        ),
      );
      // Optional: clear the text field after success
      emailController.clear();
    } else {
      final errorMsg =
          context.read<AuthViewModel>().errorMessage ??
          'Unable to send reset link.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the ViewModel to show loading state on the button
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // UTM Logo
                Image.asset(
                  'assets/images/utm_logo.png',
                  width: 110,
                  height: 65,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 35),

                // Security Icon
                Icon(Icons.shield_outlined, color: maroon, size: 105),
                const SizedBox(height: 20),

                // Page Heading
                Text(
                  'Forgot your password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: maroon,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "Don't worry! Enter your registered university "
                  "email address and we'll send you a link to "
                  "reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: maroon, fontSize: 12),
                ),
                const SizedBox(height: 40),

                // Email Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'University Email Address',
                    style: TextStyle(
                      color: maroon,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Email Field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your registered email',
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.email_outlined, color: maroon),
                    filled: true,
                    fillColor: const Color(0xFFEEEEEE),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Send Reset Link Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading ? null : sendResetLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: maroon,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Send Reset Link'),
                  ),
                ),
                const SizedBox(height: 30),

                // Back to Login
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '← Back to Login',
                    style: TextStyle(
                      color: maroon,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
