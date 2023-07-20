import 'dart:io';

import 'package:client/widgets/food_item_details/add_save_button.dart';
import 'package:client/widgets/food_item_details/quantity_field_row.dart';
import 'package:client/widgets/food_item_details/ring.dart';
import 'package:client/widgets/food_item_details/weight_field_row.dart';
import 'package:client/widgets/util_views/error_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/history_item.dart';
import '../../models/user_history_model.dart';
import '../util_views/snackbar_builder.dart';

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
  String _previousWeightText = '';

  @override
  void initState() {
    super.initState();
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

  void _onWeightValueChanged() {
    final newText = _weightController.text;
    if (!RegExp(r'^(?:\d{1,5}(\.\d{0,2})?)?$').hasMatch(newText)) {
      setState(() {
        _weightController.text = _previousWeightText;
      });
    } else {
      _previousWeightText = newText;
    }
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

  void onAddSaveButtonPress() async {
    setState(() {
      _isLoading = true;
    });
    final isSuccess = widget.isCameraPageCaller
        ? await history.addHistoryItem(historyItem)
        : await history.modifyHistoryItem(historyItem);
    setState(() {
      _isLoading = false;
    });
    if (isSuccess) {
      Navigator.of(context).pop();
      final successSnackBar = buildSnackBar(
          '${widget.isCameraPageCaller?"Added":"Edited"} Successfully', Colors.green, const Duration(seconds: 1));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
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
                      child: historyItem.imagePath!.startsWith('http') ||
                              historyItem.imagePath!.startsWith('https')
                          ? Image.network(
                              historyItem.imagePath!,
                              fit: BoxFit.cover,
                              // filterQuality: FilterQuality.high,
                            )
                          : Image.file(File(historyItem.imagePath!),
                              fit: BoxFit.cover)),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Ring(
                            innerText: "${historyItem.calories}\n kcal",
                            label: "Calories",
                            color: Colors.purple),
                        Ring(
                            innerText:
                                "${historyItem.carbs.toStringAsFixed(1)} g",
                            label: "Carbs",
                            color: Colors.red),
                        Ring(
                            innerText:
                                "${historyItem.protein.toStringAsFixed(1)} g",
                            label: "Protein",
                            color: Colors.orange),
                        Ring(
                            innerText:
                                "${historyItem.fats.toStringAsFixed(1)} g",
                            label: "Fats",
                            color: Colors.green),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 25,
                  ),
                  QuantityFieldRow(
                    _quantityController,
                    historyItem,
                    (val) {
                      setState(() {
                        if (val.isEmpty) val = "0";
                        historyItem.quantity = int.parse(val);
                      });
                    },
                  ),
                  const Divider(
                    thickness: 1,
                    height: 25,
                  ),
                  WeightFieldRow(_weightController, historyItem,
                      onTextFieldChange: (val) {
                        setState(() {
                          if (val.isEmpty) val = "0";
                          historyItem.weight = double.parse(val);
                        });
                      },
                      chosenWeightUnit: chosenWeightUnit,
                      onWeightUnitChange: (newValue) {
                        setState(() {
                          historyItem.weightUnit =
                              WeightUnitExtension.fromString(newValue!) ??
                                  WeightUnit.g;
                        });
                      }),
                  AddSaveButton(
                      isLoading: _isLoading,
                      buttonText: widget.isCameraPageCaller
                          ? "Add Item"
                          : "Save Changes",
                      onButtonPress: _isLoading ? null : onAddSaveButtonPress)
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
