import 'package:flutter/material.dart';
import '../../models/history_model.dart';
import 'journal_chart.dart';
import 'journal_date_picker.dart';
import 'journal_food_item.dart';
import 'package:provider/provider.dart';

import '../predicting_food/camera_page.dart';

class JournalPage extends StatefulWidget {
  static const route = '/journal';

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late Future<List<HistoryItem>?> _historyItemsFuture;

  @override
  void initState() {
    super.initState();
    final history = Provider.of<UserHistoryModel>(context, listen: false);
    _historyItemsFuture = history.fetchAndSetHistoryList();
  }

  Widget buildEmptyHistoryView() {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.all(20),
            child: Image.asset('assets/empty_journal.jpg')),
        Container(
          margin: const EdgeInsets.all(10),
          child: const Text(
            "History is empty!",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          ),
        ),
        const Text(
          "Click the add button \n and start logging your food intake.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.black54),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    //final history = Provider.of<UserHistoryModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal"),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CameraPage.route);
        },
        tooltip: "Add new item",
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: FutureBuilder<List<HistoryItem>?>(
        future: _historyItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            //error message
            print('error');
            return const Placeholder();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<UserHistoryModel>(
              builder: (context, history, child) => Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      width: mediaQuery.size.width,
                      child: JournalDatePicker(),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: history.historyItems!.isEmpty
                        ? buildEmptyHistoryView()
                        : ListView(
                            children: [
                              JournalChart(
                                totalCalories: history.totalCalories,
                                totalFats: history.totalFats,
                                totalCarbs: history.totalCarbs,
                                totalProteins: history.totalProteins,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: history.historyItems!.length,
                                  itemBuilder: (context, index) {
                                    return JournalFoodItem(index);
                                  }),
                            ],
                          ),
                  ),
                ],
              ),
            );
          }
          return const Placeholder();
        },
      ),
    );
  }
}
