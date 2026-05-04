import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/common/widgets/simple_text_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/widgets/room_chat_card.dart';
import '../controllers/chatting_controller.dart';

class ChattingPage extends GetView<ChattingController> {
  const ChattingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleTextAppBar(
        title: AppStrings.get(AppStrings.menuKeyChat),
        onBack: () {
          // custom back logic
          Get.offAllNamed('/dashboard');
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.chatRooms.isEmpty) {
          return Center(child: Text(AppStrings.get(AppStrings.commonKeyNoRooms)));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: ListView.separated(
            itemCount: controller.chatRooms.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final room = controller.chatRooms[index];
              return RoomChatCardWidget(
                room: room,
                onTap: () => Get.toNamed(
                  '/chat_private',
                  arguments: {
                    "room_key": room.roomKey,
                    "receiver_id": room.receiverId,
                    "receiver_name": room.receiverName,
                    "receiver_picture": room.receiverPicture,
                    "room_id": room.roomId,
                  },
                ),
              );
            },
          ),
        );
      }),

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
