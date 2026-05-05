// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/recipe_model.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/healthy_menu/controllers/healthy_menu_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailPage extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final HealthyMenuController controller = Get.find();
  bool _isPointClaimed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels != 0 &&
          !_isPointClaimed) {
        _isPointClaimed = true;
        controller.claimPoint(widget.recipe.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.richBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.recipe.title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.recipe.imageUrl.isNotEmpty)
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: '$BASE_URL${widget.recipe.imageUrl}',
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey[200]),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.orangeLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.recipe.category.toUpperCase(),
                      style: const TextStyle(color: AppColors.orangeLight, fontWeight: FontWeight.w800, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.recipe.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.recipe.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  if (widget.recipe.fileUrl.isNotEmpty) ...[
                    Text(
                      AppStrings.get(AppStrings.recipeKeyGuide),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SfPdfViewer.network("$BASE_URL${widget.recipe.fileUrl}", key: pdfViewerKey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () => _downloadPDF("$BASE_URL${widget.recipe.fileUrl}"),
                        icon: const Icon(Icons.download_rounded),
                        label: Text(AppStrings.getOr('Download PDF', 'Unduh PDF')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orangeLight,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadPDF(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
