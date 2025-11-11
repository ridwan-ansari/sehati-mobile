import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/modules/profile/controllers/profile_controller.dart';

class ChangePhotoDialog extends StatefulWidget {
  final ProfileController controller;
  const ChangePhotoDialog({super.key, required this.controller});

  @override
  State<ChangePhotoDialog> createState() => _ChangePhotoDialogState();
}

class _ChangePhotoDialogState extends State<ChangePhotoDialog> {
  File? selectedImage;
  bool isUploading = false;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => selectedImage = File(pickedFile.path));
    }
  }

  Future<void> uploadPhoto() async {
    if (selectedImage == null) return;

    setState(() => isUploading = true);
    final success = await widget.controller.uploadPhoto(selectedImage!.path);
    setState(() => isUploading = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPhoto = widget.controller.dataProfile.value?.picture;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Change Photo",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage: selectedImage != null
                ? FileImage(selectedImage!)
                : (currentPhoto != null && currentPhoto.isNotEmpty)
                ? NetworkImage('${BASE_URL + currentPhoto}')
                : null,
            child:
                (selectedImage == null &&
                    (currentPhoto == null || currentPhoto.isEmpty))
                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: isUploading
                ? null
                : selectedImage == null
                ? pickImage
                : uploadPhoto,
            icon: Icon(
              selectedImage == null ? Icons.photo_library : Icons.cloud_upload,
            ),
            label: Text(
              isUploading
                  ? "Mengunggah..."
                  : selectedImage == null
                  ? "Selected Photo"
                  : "Upload Photo",
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedImage == null
                  ? AppColors.orangeLight
                  : Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (isUploading) const SizedBox(height: 12),
          if (isUploading) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
