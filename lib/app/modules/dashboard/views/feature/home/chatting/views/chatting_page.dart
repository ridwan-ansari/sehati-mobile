import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/widgets/room_chat_card.dart';
import '../controllers/chatting_controller.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';

class ChattingPage extends GetView<ChattingController> {
  const ChattingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.chatIcon,
        onSearchChanged: (value) {},
        onProfileTap: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: ListView.separated(
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) =>  RoomChatCardWidget( onTap: ()=> Get.toNamed('/chat_private')),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3B2B27),
        onPressed: () => Get.toNamed('/add_room_chat'),
        child: AppAssetUtils.svg(
          AppAssets.chatIcon,
          width: 24,
          height: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
