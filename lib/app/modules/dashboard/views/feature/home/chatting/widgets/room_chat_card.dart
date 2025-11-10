import 'package:flutter/material.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';

class RoomChatCardWidget extends StatelessWidget {
  final void Function() onTap;
  const RoomChatCardWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                'https://example.com/room_chat.jpg',
              ), // Ganti dengan URL gambar room chat
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Fanes Setiawan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  'hallo, apa kabar?',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            // time dan status read bisa ditambahkan di sini
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:  [
                Text(
                  '12:45 PM',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 4.0),
                AppAssetUtils.svg(AppAssets.read2Chat , width: 24 , height: 24)
              ],
            ),
          ],
        ),
      ),
    );
  }
}