import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sehati/app/data/models/forum_content_model.dart';
import 'package:sehati/app/data/models/forum_comment_model.dart';
import 'package:sehati/app/data/services/forum_service.dart';

class ForumController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final ForumService _service = ForumService();

  CameraController? cameraController;
  Rx<File?> selectedImage = Rx<File?>(null);

  final TextEditingController contentController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  var content = <ForumContentModel>[].obs;
  var comments = <ForumComment>[].obs;

  var isLoading = false.obs;
  var isCommentLoading = false.obs;
  var isPosting = false.obs;
  var errorMessage = ''.obs;
  var limit = 20;
  var offset = 0;
  var isMoreDataAvailable = true.obs;

  RxBool get isLoadingDetail => isCommentLoading;

  Future<void> fetchForums() async {
    try {
      errorMessage.value = '';
      isLoading.value = true;
      offset = 0;
      final data = await _service.getForum(limit: limit, offset: offset);

      if (data != null) {
        content.assignAll(data);
        isMoreDataAvailable.value = data.length == limit;
      }
    } catch (_) {
      errorMessage.value = 'Failed to load posts. Check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!isMoreDataAvailable.value) return;
    offset += limit;
    final data = await _service.getForum(limit: limit, offset: offset);

    if (data != null && data.isNotEmpty) {
      content.addAll(data);
      isMoreDataAvailable.value = data.length == limit;
    } else {
      isMoreDataAvailable.value = false;
    }
  }

  Future<void> fetchComments(String postId) async {
    try {
      isCommentLoading.value = true;
      final data = await _service.getForumDetail(postId);
      if (data != null) comments.assignAll(data);
    } finally {
      isCommentLoading.value = false;
    }
  }

  Future<void> fetchForumDetail(String postId) => fetchComments(postId);

  Future<void> addComment(String postId, String comment) async {
    final res = await _service.postComment(postId, comment);
    if (res == true) {
      comments.refresh();
      await fetchComments(postId);
      await fetchForums();
    }
  }

  Future<void> postComment(String postId) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;
    await addComment(postId, text);
    commentController.clear();
  }

  Future<void> likePost(String postId) async {
    int index = content.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = content[index];
    final res = await _service.likePost(postId);

    if (res != null) {
      final updatedPost = ForumContentModel(
        id: post.id,
        likeCount: res["like_count"],
        createdAt: post.createdAt,
        imageUrl: post.imageUrl,
        caption: post.caption,
        isLiked: res["like"],
        commentCount: post.commentCount,
        user: post.user,
      );

      content[index] = updatedPost;
      content.refresh();
    }
  }

  Future<void> toggleLike(String postId) => likePost(postId);

  Future<void> initializeCamera() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      return;
    }
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    cameraController = CameraController(cameras.first, ResolutionPreset.high);
    await cameraController!.initialize();
  }

  Future<void> takePhoto() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) selectedImage.value = File(photo.path);
  }

  Future<void> pickFromGallery() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) selectedImage.value = File(photo.path);
  }

  Future<void> submitPost(String filePath) async {
    try {
      isPosting.value = true;
      final ok = await _service.createPost(
        caption: contentController.text.trim(),
        filePath: filePath,
      );
      if (ok) {
        contentController.clear();
        selectedImage.value = null;
        await fetchForums();
        Get.offAllNamed('/dashboard');
      }
    } finally {
      isPosting.value = false;
    }
  }

  void onRefreshData() async {
    await fetchForums();
  }

  @override
  void onInit() {
    super.onInit();
    fetchForums();
  }

  @override
  void onClose() {
    contentController.dispose();
    commentController.dispose();
    cameraController?.dispose();
    super.onClose();
  }
}
