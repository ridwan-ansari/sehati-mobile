import 'package:flutter/material.dart';

class YesNoSwitch extends StatelessWidget {
  final bool? value; // null = belum dipilih
  final ValueChanged<bool> onChanged;

  const YesNoSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Color _backgroundColor() {
    if (value == null) return Colors.grey;    // default belum dipilih
    if (value == true) return Colors.green;   // YES
    return Colors.red;                         // NO
  }

  String _labelText() {
    if (value == null) return "?";            // default
    return value! ? "YES" : "NO";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!(value ?? false)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _labelText(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
