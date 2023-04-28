import 'package:client/widgets/util_views/error_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/history_model.dart';

class FoodItemPage extends StatefulWidget {
  static const route = '/food-item';

  final bool isCameraPageCaller;
  final HistoryItem historyItem;

  const FoodItemPage(
      {required this.isCameraPageCaller, required this.historyItem});

  @override
  State<FoodItemPage> createState() => _FoodItemPageState();
}

class _FoodItemPageState extends State<FoodItemPage> {
  late HistoryItem historyItem;
  late UserHistoryModel history;
  late TextEditingController _quantityController;
  late TextEditingController _weightController;
  bool initialized = false;
  late String chosenWeightUnit; // 'g' or 'kg'

  late bool isCameraPageCaller;

  bool _isLoading = false;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
  }

  void _onWeightValueChanged() {
    final newText = _weightController.text;
    if (!RegExp(r'^(?:\d{1,5}(\.\d{0,2})?)?$').hasMatch(newText)) {
      setState(() {
        _weightController.text = _previousText;
      });
    } else {
      _previousText = newText;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initialized) return;

    historyItem = HistoryItem.clone(widget.historyItem);
    history = Provider.of<UserHistoryModel>(context, listen: false);

    _quantityController =
        TextEditingController(text: '${historyItem.quantity}');
    _weightController = TextEditingController(text: '${historyItem.weight}');
    chosenWeightUnit = historyItem.weightUnit == WeightUnit.g ? 'g' : 'kg';
    _weightController.addListener(_onWeightValueChanged);
    initialized = true;
  }

  Widget buildRing(String innerText, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: color,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: FittedBox(
                  child: Text(
                    innerText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Text(label)
        ],
      ),
    );
  }

  Widget addQuantityRow(HistoryItem historyItem) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 70,
      child: Row(
        children: [
          const Expanded(child: Text("Quantity")),
          Container(
            width: 100,
            child: TextField(
              textAlign: TextAlign.center,
              controller: _quantityController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  //TODO: macros recalculation
                  if (val.isEmpty) val = "0";
                  historyItem.quantity = int.parse(val);
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget addWeightRow(HistoryItem historyItem) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 80,
      child: Row(
        children: [
          const Expanded(child: Text("Weight")),
          Container(
            width: 100,
            margin: const EdgeInsets.only(right: 5),
            child: TextField(
              textAlign: TextAlign.center,
              controller: _weightController,
              // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{1,5}(\.\d{0,2})?$'))],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  if (val.isEmpty) val = "0";
                  historyItem.weight = double.parse(val);
                });
              },
            ),
          ),
          Container(
            width: 70,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              alignment: Alignment.center,
              value: chosenWeightUnit,
              onChanged: (newValue) {
                setState(() {
                  historyItem.weightUnit =
                      WeightUnitExtension.fromString(newValue!) ?? WeightUnit.g;
                });
              },
              items: ['g', 'kg']
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  void onDelete() async {
    setState(() {
      _isLoading = true;
    });
    final isSuccess = await history.removeHistoryItem(historyItem.id!);
    setState(() {
      _isLoading = false;
    });

    if (isSuccess) {
      Navigator.of(context).pop();
    } else {
      showErrorAlertDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(historyItem.foodItemDetails.name),
        actions: [
          if (!widget.isCameraPageCaller)
            IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete item',
                onPressed: _isLoading ? null : onDelete)
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Image.network(
                      historyItem.imageURL!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        buildRing("${historyItem.calories}\n kcal", "Calories",
                            Colors.purple),
                        buildRing("${historyItem.carbs.toStringAsFixed(1)}.g",
                            "Carbs", Colors.red),
                        buildRing("${historyItem.protein.toStringAsFixed(1)}g",
                            "Protein", Colors.orange),
                        buildRing("${historyItem.fats.toStringAsFixed(1)}g",
                            "Fats", Colors.green),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 25,
                  ),
                  addQuantityRow(historyItem),
                  const Divider(
                    thickness: 1,
                    height: 25,
                  ),
                  addWeightRow(historyItem),
                  Container(
                    // alignment: Alignment.center,
                    height: 70,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              final isSuccess = await history
                                  .modifyOrAddHistoryItem(historyItem);
                              setState(() {
                                _isLoading = false;
                              });
                              if (isSuccess) {
                                Navigator.of(context).pop();
                              } else {
                                showErrorAlertDialog(context);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Text(widget.isCameraPageCaller
                              ? "Add Item"
                              : "Save Changes"),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _weightController.removeListener(_onWeightValueChanged);
    _weightController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
