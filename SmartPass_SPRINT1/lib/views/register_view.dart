import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import 'auth_wrapper.dart';
import 'login_view.dart';
import 'role_selection_view.dart';

class StudentRegisterView extends StatefulWidget {
  const StudentRegisterView({super.key});

  @override
  State<StudentRegisterView> createState() => _StudentRegisterViewState();
}

class _StudentRegisterViewState extends State<StudentRegisterView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final staffIdController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;

  final Color maroon = const Color(0xFFA00000);
  final Color fieldColor = const Color(0xFFEEEEEE);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    staffIdController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget buildInputField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && isPasswordHidden,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 11),
        filled: true,
        fillColor: fieldColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: maroon, width: 1),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: maroon,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Extracted the registration logic here to keep the UI clean
  Future<void> _handleSignUp() async {
    final viewModel = context.read<AuthViewModel>();
    viewModel.clearError();

    // Check all registration fields
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        staffIdController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields before continuing.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Open role selection page
    final selectedRole = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const RoleSelectionView()),
    );

    if (!mounted || selectedRole == null) return;

    // Call ViewModel to handle Role Detection, matching, and Firebase creation
    final success = await viewModel.register(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      fullName: nameController.text.trim(),
      universityId: staffIdController.text,
      phone: phoneController.text.trim(),
      selectedRole: selectedRole,
    );

    if (success && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Registration Successful!'),
          content: const Text(
            'Your Smart-Pass account has been created successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthWrapper()),
                  (route) => false,
                );
              },
              child: const Text(
                'Go to Login',
                style: TextStyle(color: Color(0xFFA00000)),
              ),
            ),
          ],
        ),
      );
    } else if (mounted && viewModel.errorMessage != null) {
      // Show error from ViewModel (e.g., ID format mismatch)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 25),
              // UTM Logo
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudentLoginView(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFFA00000),
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/utm_logo.png',
                    width: 110,
                    height: 65,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 25),
              // Page Heading
              Text(
                'Create New\nAccount',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: maroon,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  height: 0.95,
                ),
              ),
              const SizedBox(height: 12),
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already Registered? ',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudentLoginView(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log in here.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Name
              buildFieldLabel('NAME'),
              buildInputField(hint: 'Fullname', controller: nameController),
              const SizedBox(height: 7),
              // Email
              buildFieldLabel('EMAIL'),
              buildInputField(
                hint: 'Email@utm.my',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 7),
              // University ID
              buildFieldLabel('UNIVERSITY ID'),
              buildInputField(hint: 'XXXXXXX', controller: staffIdController),
              const SizedBox(height: 7),
              // Phone Number
              buildFieldLabel('PHONE NUMBER'),
              buildInputField(
                hint: '012 - 3456789',
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 7),
              // Password
              buildFieldLabel('PASSWORD'),
              buildInputField(
                hint: 'Enter password',
                controller: passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 25),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
