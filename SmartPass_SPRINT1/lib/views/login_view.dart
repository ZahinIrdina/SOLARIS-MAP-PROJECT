import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'register_view.dart';
import 'forgot_password_view.dart';

class StudentLoginView extends StatefulWidget {
  const StudentLoginView({super.key});

  @override
  State<StudentLoginView> createState() => _StudentLoginViewState();
}

class _StudentLoginViewState extends State<StudentLoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;

  final Color maroon = const Color(0xFFA00000);
  final Color fieldColor = const Color(0xFFEEEEEE);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    // Clear previous errors
    context.read<AuthViewModel>().clearError();

    final success = await context.read<AuthViewModel>().login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (success && mounted) {
      // AuthWrapper automatically handles navigation upon success.
      // We just show a quick success message before it switches.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
    }
  }

  Widget buildTextField({
    required String hint,
    required IconData prefixIcon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && isPasswordHidden,
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Icon(prefixIcon, color: maroon, size: 21),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: maroon,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: fieldColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the ViewModel to update UI based on loading state and errors
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              // Official UTM Logo
              Center(
                child: Image.asset(
                  'assets/images/utm_logo.png',
                  width: 120,
                  height: 65,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 45),
              // SmartPass Logo
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/smartpass_logo.png',
                      width: 120,
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'SmartPass',
                      style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold, color: maroon),
                    ),
                    Text(
                      'Smart Examination Management',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: maroon),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 85),
              // Welcome Heading
              Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: maroon),
              ),
              const SizedBox(height: 8),
              Text(
                'Please log in to access your account.',
                style: TextStyle(fontSize: 14, color: maroon),
              ),
              const SizedBox(height: 30),
              // Email Field
              buildTextField(
                hint: 'Email',
                prefixIcon: Icons.mail_outline,
                controller: emailController,
              ),
              const SizedBox(height: 15),
              // Password Field
              buildTextField(
                hint: 'Password',
                prefixIcon: Icons.lock,
                controller: passwordController,
                isPassword: true,
              ),
              
              // Error Message Display
              if (viewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to the new view
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordView()),
                    );
                  },
                  child: Text(
                    'Forgot your password?',
                    style: TextStyle(
                      color: maroon,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading ? null : loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StudentRegisterView()),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(color: maroon, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}