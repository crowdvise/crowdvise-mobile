import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:logger/logger.dart';

void logg(String str){
   Logger().i(str);
}


String formattedDate(DateTime dateTime) {
  String formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);

  return formattedDate;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String formatTime(DateTime time) {
  String formattedTime = DateFormat('hh:mm a').format(time);
  return formattedTime;
}

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;


