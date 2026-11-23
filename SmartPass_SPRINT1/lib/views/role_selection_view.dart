import 'package:material_ui/material_ui.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  final Color maroon = const Color(0xFFA00000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
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
                      Navigator.pop(context);
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
              const SizedBox(height: 35),

              // SmartPass Logo
              Image.asset(
                'assets/images/smartpass_logo.png',
                width: 120,
                height: 110,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 5),
              Text(
                'SmartPass',
                style: TextStyle(
                  color: maroon,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Smart Examination Management',
                style: TextStyle(color: maroon, fontSize: 14),
              ),
              const Spacer(),

              // Select Role Heading
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Role',
                  style: TextStyle(
                    color: maroon,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose your role as Student or\nInvigilator',
                  style: TextStyle(color: maroon, fontSize: 13),
                ),
              ),
              const SizedBox(height: 25),

              // Student Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'Student');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Student'),
                ),
              ),
              const SizedBox(height: 20),

              // Invigilator Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'Invigilator');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Invigilator'),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
