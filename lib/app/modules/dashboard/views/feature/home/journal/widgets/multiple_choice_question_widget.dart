// ignore_for_file: unnecessary_to_list_in_spreads, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/data/models/response/exercise_question_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/feature/exercise/controllers/exercise_controller.dart';

class MultipleChoiceQuestionWidget extends StatefulWidget {
  final ExerciseQuestionModel question;
  final int index;
  final int totalSoal;
  final PageController pageController;
  final ExerciseController controller;

  const MultipleChoiceQuestionWidget({
    super.key,
    required this.question,
    required this.index,
    required this.totalSoal,
    required this.pageController,
    required this.controller,
  });

  @override
  State<MultipleChoiceQuestionWidget> createState() =>
      _MultipleChoiceQuestionWidgetState();
}

class _MultipleChoiceQuestionWidgetState
    extends State<MultipleChoiceQuestionWidget> {
  late String formattedQuestion = "";

  @override
  void initState() {
    super.initState();
    String data =
        "{\"1\":\"Saya sedikit melakukan aktivitas fisik untuk mengisi sebagian besar waktu luang saya\",\"2\":\"Saya kadang-kadang (1-2 kali dalam seminggu terakhir) melakukan kegiatan fisik diwaktu luang (misalnya berolahraga, lari, berenang, bersepada, senam aerobik)\",\"3\":\"Saya sering (3-4 kali dalam seminggu terakhir) melakukan kegiatan fisik di waktu luang\\n\",\"4\":\"Saya sangat sering (5-6 kali dalam seminggu terakhir_ melakukan kegiatan fisik di waktu luang\",\"5\":\"Saya sangat sering sekali (7 kali atau lebih dalam seminggu terakhir) melakukan kegiatan fisik di waktu luang\\n\"}";
    // formattedQuestion = _formatQuestion(widget.question.question);
    print(data);
    if (isJsonString(widget.question.question)) {
      print("DATA JSON");
      Map<String, dynamic> decodedData = jsonDecode(data);
      printMapPretty(decodedData);
    } else {
      print("DATA LANGSUNG");
      formattedQuestion = widget.question.question;
      setState(() {});
      print("Data bukan JSON valid");
    }
  }

  bool isJsonString(String input) {
    try {
      final decoded = jsonDecode(input);
      return decoded is Map || decoded is List;
    } catch (e) {
      return false;
    }
  }

  void printMapPretty(Map<String, dynamic> data) {
    data.forEach((key, value) {
      formattedQuestion = "$key: $value\n";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    int jawabanTerisi = widget.controller.exerciseList
        .where((q) => q.selectedOption != null || q.answerText != null)
        .length;
    bool semuaTerisi = jawabanTerisi == widget.totalSoal;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE082), Color(0xFFFFB74D)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.yellow.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: nomor soal + poin
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${widget.index + 1} / ${widget.totalSoal}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  // AnimatedIn(
                  //   child: Row(
                  //     children: [
                  //       const Icon(Icons.monetization_on, color: Colors.amber),
                  //       const SizedBox(width: 4),
                  //       Text(
                  //         '+${widget.question.rewardPoints}',
                  //         style: const TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.amber,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              // Teks soal
              AnimatedIn(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    child: Text(
                      formattedQuestion,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tombol pilihan jawaban
              ...widget.question.options.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: AnimatedIn(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            widget.question.selectedOption == entry.key
                            ? AppColors.orangeLight
                            : const Color(0xFF3D2C1C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          widget.question.selectedOption = entry.key;
                          widget.question.answerText = entry.value;
                          widget.controller.exerciseList.refresh();
                        });
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(entry.value),
                      ),
                    ),
                  ),
                );
              }).toList(),
              const Spacer(),
              // Tombol navigasi Previous / Next / Submit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.index > 0)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFFFB74D),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: Color(0xFFFFB74D),
                      ),
                      onPressed: () => widget.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text("Previous"),
                    ),
                  if (widget.index < widget.totalSoal - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangeLight,
                      ),
                      onPressed: () => widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text("Next"),
                    ),
                  if (widget.index == widget.totalSoal - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: semuaTerisi
                            ? AppColors.orangeLight
                            : Colors.grey,
                      ),
                      onPressed: semuaTerisi
                          ? () => widget.controller.submitAllAnswers()
                          : null,
                      child: const Text("Submit"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
