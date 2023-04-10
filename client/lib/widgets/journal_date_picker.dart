import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/history_model.dart';

class JournalDatePicker extends StatelessWidget {
  //const JournalDatePicker({Key? key}) : super(key: key);

  //VoidCallback onCalendarPress;
  late HistoryModel history;

  //JournalDatePicker({required this.onCalendarPress});



  String get getCurrentDate {
    final now = DateTime.now();
    final currentDate = history.currentDate;

    final nowDate = DateTime(now.year, now.month, now.day);
    final historyDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

    final differenceDates = historyDate.difference(nowDate).inDays;
    switch (differenceDates) {
      case 0:
        return "Today";
      case 1:
        return "Tomorrow";
      case -1:
        return "Yesterday";
      default:
        return DateFormat('dd MMM, yyyy').format(history.currentDate);
    }
  }

  void onCalendarPress(BuildContext context) async {
    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: history.currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(history.currentDate.year + 3),
    );

    if (chosenDate == null) return;
    history.setDate(chosenDate);
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
    history = Provider.of<HistoryModel>(context, listen:false);

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDateButton(
              icon: Icons.navigate_before_rounded,
              onPressHandler: () => history
                  .setDate(history.currentDate.add(const Duration(days: -1)))),
          const SizedBox(width: 40),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: Text(getCurrentDate),
              onPressed: ()=>onCalendarPress(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
          buildDateButton(
              icon: Icons.navigate_next_outlined,
              onPressHandler: () => history
                  .setDate(history.currentDate.add(const Duration(days: 1))))
        ],
      ),
    );
  }
}
