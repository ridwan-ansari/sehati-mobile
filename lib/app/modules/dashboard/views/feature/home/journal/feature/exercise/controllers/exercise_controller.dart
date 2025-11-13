import 'package:get/get.dart';
import 'package:sehati/app/data/models/response/exercise_question_model.dart';
import 'package:sehati/app/data/services/exercise_service.dart';

class ExerciseController extends GetxController {
  final ExerciseService _service = ExerciseService();

  final isLoading = false.obs;
  final RxList<ExerciseQuestionModel> exerciseList =
      <ExerciseQuestionModel>[].obs;
  Future<void> fetchExerciseQuestions() async {
    try {
      isLoading.value = true;
      final data = await _service.getExerciseQuestions();
      exerciseList.assignAll(data ?? []);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAllAnswers() async {
    List<Map<String, dynamic>> answers = [];

    for (var question in exerciseList) {
      answers.add({
        "question_id": question.id,
        "selected_option": question.selectedOption,
        "answer_text": question.answerText,
      });
    }

    final success = await _service.submitExerciseAnswersBatch(answers: answers);

    if (success) {
      Get.toNamed('/journal');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchExerciseQuestions();
  }

  @override
  void onClose() {
    super.onClose();

    exerciseList.clear();
  }
}
