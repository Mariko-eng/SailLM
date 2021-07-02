import 'package:flutter/material.dart';

Pattern emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

// Add commas to string numbers
RegExp numReg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]},';

var textFormFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(20.0),
  fillColor: Colors.grey[900],
  hintStyle: TextStyle(color: Colors.grey),
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40.0),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40.0),
    borderSide: BorderSide.none,
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40.0),
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
);

var textAreaDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(20.0),
  fillColor: Colors.grey[900],
  hintStyle: TextStyle(color: Colors.grey),
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide.none,
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.pink,
      width: 2.0,
    ),
  ),
);

const List<String> months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec',
];

final monthsItems = months.map<DropdownMenuItem<int>>((String value) {
  return DropdownMenuItem<int>(
    value: (months.indexOf(value) + 1),
    child: Text(
      value,
      style: TextStyle(color: Colors.white),
    ),
  );
}).toList();

List<DropdownMenuItem<int>> upcomingYears(int year) {
  List<int> years = List<int>.generate(20, (index) => year + index);

  return years.map<DropdownMenuItem<int>>((int value) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        '$value',
        style: TextStyle(color: Colors.white),
      ),
    );
  }).toList();
}

List<DropdownMenuItem<int>> getDates(int year, int month) {
  var dateNow = DateTime(year, month);
  List<int> dates =
      List<int>.generate(daysInMonth(dateNow), (index) => index + 1);

  return dates.map<DropdownMenuItem<int>>((int value) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        '$value',
        style: TextStyle(color: Colors.white),
      ),
    );
  }).toList();
}

List<DropdownMenuItem<int>> getNumbers(int number) {
  List<int> hours = List<int>.generate(number, (index) => index);

  return hours.map<DropdownMenuItem<int>>((int value) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        value <= 9 ? '0$value' : '$value',
        style: TextStyle(color: Colors.white),
      ),
    );
  }).toList();
}

int daysInMonth(DateTime date) {
  var firstDayThisMonth = DateTime(date.year, date.month, date.day);
  var firstDayNextMonth = DateTime(firstDayThisMonth.year,
      firstDayThisMonth.month + 1, firstDayThisMonth.day);
  return firstDayNextMonth.difference(firstDayThisMonth).inDays;
}
