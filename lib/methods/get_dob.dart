import 'package:chat_buddy/models/user_model.dart';

String dob = '';

class DOB {
  String getDOB(DateTime? date) {
    if (date == null) {
      return UserModel.dob.toString();
    } else {
      String? day = date.day.toString();
      String? month = date.month.toString();
      String? year = date.year.toString();

      if (month.length == 1 && day.length == 1) {
        day = '0$day';
        month = '0$month';
      }
      if (day.length == 1) {
        day = '0$day';
      }
      if (month.length == 1) {
        month = '0$month';
      }
      dob = '$day/$month/$year';
      return dob;
    }
  }
}
