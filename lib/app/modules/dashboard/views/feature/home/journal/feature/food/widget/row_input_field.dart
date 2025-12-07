import 'package:flutter/material.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/gradien_label.dart';

class RowInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final String? hintText;
  final Color fillColor;
  final bool isEditable;

  const RowInputField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.keyboardType,
    this.onTap,
    this.hintText,
    this.fillColor = const Color(0xFFFFF9C4),
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 253, 234, 175), Color(0xFFFFB74D)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 12, top: 12 , bottom: 12),
        child: Row(
          children: [
            Expanded(child: GradientLabel(title: label)),
            const SizedBox(width: 10),
            IntrinsicWidth(
              child: AnimatedIn(
                child: TextFormField(
                  controller: controller,
                  readOnly: !isEditable,
                  enabled: isEditable,
                  keyboardType: keyboardType,
                  onTap: onTap,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: hintText ?? "",
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    helperStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: isEditable ? fillColor : Colors.white,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white),
                    )
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(30),
                    //   borderSide: const BorderSide(color: Colors.white),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(30),
                    //   borderSide: const BorderSide(color: Colors.white),
                    // ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
