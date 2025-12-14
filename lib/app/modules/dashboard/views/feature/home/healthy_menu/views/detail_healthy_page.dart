// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
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
  void _downloadPDF(String url) async {
    final fullUrl = url;
    if (await canLaunch(fullUrl)) {
      await launch(fullUrl);
    } else {
      throw 'Could not launch $fullUrl';
    }
  }

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
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        title: Text(widget.recipe.title),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.recipe.imageUrl.isNotEmpty)
              AnimatedIn(
                child: Image.network(
                  '$BASE_URL${widget.recipe.imageUrl}',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            AnimatedIn(
              child: Text(
                widget.recipe.title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedIn(
              child: Text(
                widget.recipe.category,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedIn(
              child: Text(
                widget.recipe.description,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
            if (widget.recipe.fileUrl.isNotEmpty)
              SizedBox(
                height: 512,
                child: AnimatedIn(
                  child: SfPdfViewer.network(
                    "$BASE_URL${widget.recipe.fileUrl}",
                    key: pdfViewerKey,
                  ),
                ),
              ),

            if (widget.recipe.fileUrl.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () =>
                    _downloadPDF("$BASE_URL${widget.recipe.fileUrl}"),
                icon: const Icon(Icons.download),
                label: AnimatedIn(child: const Text('Download')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangeLight,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
              ),
            const SizedBox(height: 52.0),
          ],
        ),
      ),
    );
  }
}
