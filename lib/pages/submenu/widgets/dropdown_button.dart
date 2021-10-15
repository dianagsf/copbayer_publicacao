import 'package:flutter/material.dart';

class CustomDropDownButton extends StatefulWidget {
  final String value;
  final List<String> list;
  final Function handleChangeValue;
  final Function handleShowAnexo;

  CustomDropDownButton(
      {this.value, this.list, this.handleChangeValue, this.handleShowAnexo});

  @override
  _CustomDropDownButtonState createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  bool showAnexo = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Center(
        child: DropdownButton(
            isExpanded: true,
            value: widget.value,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 36,
            itemHeight: 80.0,
            hint: Text(
              "Selecione ...",
            ),
            underline: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.8, color: Colors.blue)),
            ),
            items: widget.list.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
            onChanged: (value) {
              widget.handleChangeValue(value);

              if (widget.handleShowAnexo != null) widget.handleShowAnexo(value);
            }),
      ),
    );
  }
}
