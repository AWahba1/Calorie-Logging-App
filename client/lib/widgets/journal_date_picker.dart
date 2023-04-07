import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalDatePicker extends StatelessWidget {
  //const JournalDatePicker({Key? key}) : super(key: key);

  DateTime currentDate;

  VoidCallback onNextDay;
  VoidCallback onPreviousDay;
  VoidCallback onCalendarPress;


  JournalDatePicker(
      {required this.currentDate, required this.onNextDay, required this.onPreviousDay,
      required this.onCalendarPress});


  String get getCurrentDate {
    final now = DateTime.now();
    final differenceDates = currentDate
        .difference(now)
        .inDays;
    switch (differenceDates) {
      case 0:
        return "Today";
      case 1:
        return "Tomorrow";
      case -1:
        return "Yesterday";
      default:
        return DateFormat('dd MMM, yyyy').format(currentDate);
    }
  }



  Widget buildDateButton({required IconData icon, required onPressHandler}) {
    return Container(
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: IconButton(
          icon: Icon(icon),
          onPressed: onPressHandler,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildDateButton(
              icon: Icons.navigate_before_rounded,
              onPressHandler: onPreviousDay),
          SizedBox(width: 40),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: Text(getCurrentDate),
              onPressed: onCalendarPress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 40),
          buildDateButton(
              icon: Icons.navigate_next_outlined,
              onPressHandler: onNextDay)
        ],
      ),
    );
  }
}
