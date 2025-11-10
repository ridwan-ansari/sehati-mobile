import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/controllers/chatting_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/chatting/widgets/contact_card.dart';

class AddRoomChatPage extends GetView<ChattingController> {
  const AddRoomChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        logoSvg: AppAssets.peopleIcon,
        onSearchChanged: (value) {},
        onProfileTap: () {},
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ContactCardWidget(onTap: () => Get.toNamed('/chat_private')),
            ],
          ),
        ),
      ),
    );
  }
}
