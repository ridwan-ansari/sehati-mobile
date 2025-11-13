import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/boolean_question_widget.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/multiple_choice_question_widget.dart';
import '../controllers/exercise_controller.dart';

class ExerciseView extends GetView<ExerciseController> {
  const ExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.exerciseList.isEmpty) {
          return const Center(child: Text('Tidak ada data'));
        }

        int totalSoal = controller.exerciseList.length;
        int jawabanTerisi = controller.exerciseList
            .where((q) => q.selectedOption != null || q.answerText != null)
            .length;

        PageController pageController = PageController();

        return WillPopScope(
          onWillPop: () async {
            bool? exit = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Konfirmasi"),
                content: const Text(
                  "Jika Anda keluar, semua jawaban yang telah diisi akan hilang. Apakah Anda yakin ingin keluar?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Batal"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Keluar"),
                  ),
                ],
              ),
            );
            return exit ?? false;
          },
          child: SafeArea(
            child: Column(
              children: [
                // Header Progress
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: jawabanTerisi / totalSoal,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          color: AppColors.orangeLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "$jawabanTerisi / $totalSoal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // PageView soal
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: totalSoal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = controller.exerciseList[index];

                      switch (item.questionType) {
                        case "multiple_choice":
                          return MultipleChoiceQuestionWidget(
                            question: item,
                            index: index,
                            totalSoal: totalSoal,
                            pageController: pageController,
                            controller: controller,
                          );
                        case "boolean":
                          return BooleanQuestionWidget(
                            question: item,
                            index: index,
                            totalSoal: totalSoal,
                            pageController: pageController,
                            controller: controller,
                          );
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }
}
