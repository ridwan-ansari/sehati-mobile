import 'package:flutter/material.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/data/models/recipe_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailPage extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  void _downloadPDF(String url) async {
    final fullUrl =
        'https://yourdomain.com$url'; // ganti dengan base URL servermu
    if (await canLaunch(fullUrl)) {
      await launch(fullUrl);
    } else {
      throw 'Could not launch $fullUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.gold,
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.imageUrl.isNotEmpty)
              Image.network(
                '$BASE_URL${recipe.imageUrl}',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              recipe.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              recipe.category,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(recipe.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _downloadPDF("$BASE_URL${recipe.fileUrl}"),
              icon: const Icon(Icons.download),
              label: const Text('Download Recipe PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeLight,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
