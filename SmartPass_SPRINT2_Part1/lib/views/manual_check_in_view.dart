import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../viewmodels/manual_check_in_viewmodel.dart';

class ManualCheckInView extends StatefulWidget {
  final String examId; 
  final int maxQuota; 

  const ManualCheckInView({super.key, required this.examId, this.maxQuota = 2});

  @override
  State<ManualCheckInView> createState() => _ManualCheckInViewState();
}

class _ManualCheckInViewState extends State<ManualCheckInView> {
  final _formKey = GlobalKey<FormState>();
  final _matricController = TextEditingController();
  final _seatController = TextEditingController();
  
  bool _metalDetector = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManualCheckInViewModel>();

    // Handle Success/Limit States
    if (viewModel.successStatus != null) {
      return _buildResultScreen(viewModel.successStatus!);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF990000),
        foregroundColor: Colors.white,
        title: const Text('Manual Check-In'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('New Log', style: TextStyle(fontSize: 20, color: Colors.black54)),
              const SizedBox(height: 20),
              
              // Maroon Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF990000),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildInputField('MATRIC NUMBER', _matricController, 'e.g. A20CS0000'),
                    const SizedBox(height: 15),
                    _buildInputField('SEAT NUMBER', _seatController, 'e.g. 123'),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Metal Detector Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Done Metal Detector Check', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _metalDetector,
                    onChanged: (val) => setState(() => _metalDetector = val),
                    activeThumbColor: const Color(0xFF990000),
                  ),
                ],
              ),

              if (viewModel.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(viewModel.error!, style: const TextStyle(color: Colors.red)),
                ),

              const SizedBox(height: 20),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                                child: ElevatedButton(
                  // If loading OR switch is off, disable the button entirely
                  onPressed: (viewModel.isLoading || !_metalDetector)
                      ? null 
                      : () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.submitCheckIn(
                              examId: widget.examId,
                              matric: _matricController.text.trim(),
                              seat: _seatController.text.trim(),
                              metalDetector: _metalDetector,
                              maxQuota: widget.maxQuota,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    // Button becomes grey if disabled
                    backgroundColor: (viewModel.isLoading || !_metalDetector) 
                        ? Colors.grey 
                        : const Color(0xFF990000), 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

    Widget _buildResultScreen(String status) {
    final isSuccess = status == 'success';
    final isNotFound = status == 'not_found';
    final isLimitReached = status == 'limit_reached';
    
    // Set the text and icon based on the status
    String title = isSuccess 
        ? 'Active Out\nupdated' 
        : (isNotFound ? 'Student Not\nFound' : 'Limit\nreached');
    
    IconData icon = isSuccess 
        ? Icons.check 
        : (isNotFound ? Icons.person_off : Icons.remove);
        
    String? subtitle = isLimitReached
        ? 'This student(s) have to wait until there\nis availability.'
        : (isNotFound ? 'The entered Matric Number does not\nexist in our records.' : null);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF990000),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(icon, color: Colors.white, size: 70),
              ),
              const SizedBox(height: 30),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF990000),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (subtitle != null)
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ManualCheckInViewModel>().resetStatus();
                    if (isSuccess) {
                      Navigator.pop(context); // Go back to dashboard only on success
                    }
                    // If it's an error (limit/not found), it just resets the screen to try again
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF990000),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(isSuccess ? 'Return to Dashboard' : 'Try Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}