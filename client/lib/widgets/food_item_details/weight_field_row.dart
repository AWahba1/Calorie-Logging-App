import 'package:client/models/user_history_model.dart';
import 'package:flutter/material.dart';

import '../../models/history_item.dart';

class WeightFieldRow extends StatelessWidget {
  // const WeightFieldRow({Key? key}) : super(key: key);
  final HistoryItem historyItem;
  final TextEditingController _weightController;
  final void Function(String)? onTextFieldChange;
  final void Function(String?)? onWeightUnitChange;
  final String chosenWeightUnit;

  const WeightFieldRow(this._weightController, this.historyItem,
      {required this.onTextFieldChange,
      required this.chosenWeightUnit,
      required this.onWeightUnitChange});

  @override
  Widget build(BuildContext context) {
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
              onChanged: onTextFieldChange,
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
              onChanged: onWeightUnitChange,
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
}
