class ManualCheckInModel {
  final String matricNumber;
  final String seatNumber;
  final String studentName;
  final String gender; // 'Male' or 'Female'
  final bool metalDetectorChecked;

  ManualCheckInModel({
    required this.matricNumber,
    required this.seatNumber,
    required this.studentName,
    required this.gender,
    required this.metalDetectorChecked,
  });
}