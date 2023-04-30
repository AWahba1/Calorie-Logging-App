import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/history_item.dart';


class QuantityFieldRow extends StatelessWidget {
  // const QuantityFieldRow({Key? key}) : super(key: key);
  final HistoryItem historyItem;
  final TextEditingController _quantityController;
  final void Function(String)? onFieldChange;

  const QuantityFieldRow(
      this._quantityController, this.historyItem, this.onFieldChange);

  @override
  Widget build(BuildContext context) {
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
                onChanged: onFieldChange),
          )
        ],
      ),
    );
  }
}
