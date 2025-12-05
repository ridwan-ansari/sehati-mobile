import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/data/config/api_config.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/controllers/chatting_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/widgets/contact_card.dart';

class AddRoomChatPage extends GetView<ChattingController> {
  const AddRoomChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.userList.clear();
      controller.getAllUsers();
    });
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.peopleIcon,
        onSearchChanged: (value) {
          controller.onSearchChanged(value);
        },
        onProfileTap: () {},
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.separated(
                  controller: controller.userScrollController,
                  itemCount: controller.userList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final user = controller.userList[index];
                    final imageUrl = "$BASE_URL${user.picture}";
                    return ContactCardWidget(
                      profileUrl: imageUrl,
                      name: user.fullname,
                      status: "online",
                      onTap: () => Get.toNamed(
                        '/chat_private',
                        arguments: {
                          "room_key": "",
                          "receiver_id": user.id.toString(),
                          "receiver_name": user.nickname,
                          "receiver_picture": user.picture,
                          "room_id": "",
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
