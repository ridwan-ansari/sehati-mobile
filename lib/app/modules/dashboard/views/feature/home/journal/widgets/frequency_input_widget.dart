import 'package:flutter/material.dart';

class FrequencyInputWidget extends StatefulWidget {
  final int initialValue;
  final Function(int) onChanged;

  const FrequencyInputWidget({
    Key? key,
    this.initialValue = 0,
    required this.onChanged,
  }) : super(key: key);

  @override
  _FrequencyInputWidgetState createState() => _FrequencyInputWidgetState();
}

class _FrequencyInputWidgetState extends State<FrequencyInputWidget> {
  late int _value;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller = TextEditingController(text: _value.toString());
  }

  void _onTextChanged(String text) {
    final int? newValue = int.tryParse(text);
    if (newValue != null) {
      setState(() {
        _value = newValue;
        widget.onChanged(_value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 32,
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: _onTextChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
