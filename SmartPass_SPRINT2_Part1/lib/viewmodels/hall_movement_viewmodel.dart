import 'package:material_ui/material_ui.dart';

class HallMovementViewModel extends ChangeNotifier {
  String? _selectedYear;
  String? _selectedCourse;

  String? get selectedYear => _selectedYear;
  String? get selectedCourse => _selectedCourse;

  // Mock data representing courses per year
  final Map<String, List<Map<String, String>>> _coursesByYear = {
    'Year 1': [
      {'code': 'SECJ1013', 'name': 'Programming Technique I'},
      {'code': 'SECJ1023', 'name': 'Digital Logic'},
    ],
    'Year 2': [
      {'code': 'SECJ2153', 'name': 'Data Structures'},
      {'code': 'SECJ2203', 'name': 'Software Engineering'},
    ],
    'Year 3': [
      {'code': 'SECJ3623', 'name': 'Mobile Application Programming'},
      {'code': 'SECV3113', 'name': 'Geometric Modeling'},
      {'code': 'SECR3533', 'name': 'Artificial Intelligence'},
    ],
    'Year 4': [
      {'code': 'SECJ4012', 'name': 'Final Year Project I'},
    ],
  };

  List<String> get years => _coursesByYear.keys.toList();
  
  List<Map<String, String>> get coursesForSelectedYear => 
      _selectedYear != null ? _coursesByYear[_selectedYear]! : [];

  void selectYear(String year) {
    _selectedYear = year;
    _selectedCourse = null;
    notifyListeners();
  }

  void selectCourse(String courseCode) {
    _selectedCourse = courseCode;
    notifyListeners();
  }

  void goBack() {
    if (_selectedCourse != null) {
      _selectedCourse = null;
    } else if (_selectedYear != null) {
      _selectedYear = null;
    }
    notifyListeners();
  }
}