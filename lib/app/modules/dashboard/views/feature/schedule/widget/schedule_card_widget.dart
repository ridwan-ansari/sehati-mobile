// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/data/models/response/schedule_res_model.dart';

class ScheduleCardWidget extends StatelessWidget {
  final ScheduleData shedule;
  const ScheduleCardWidget({super.key ,required this.shedule});

  @override
  Widget build(BuildContext context) {
    return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            shedule.professional?.picture != null
                ? "https://your-base-url.com${shedule.professional?.picture}"
                : "",
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: Icon(Icons.person, size: 32),
            ),
          ),
        ),

        SizedBox(width: 14),

        // Text Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               shedule. professional?.fullname ?? "Unknown",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),

              Text(
               shedule. professional?.specialization ?? "-",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),

              SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.calendar_month, size: 14, color: AppColors.gold),
                  SizedBox(width: 6),
                  Text(
                  shedule.scheduleDate?? "-",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),

              SizedBox(height: 4),

              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.deepPurple),
                  SizedBox(width: 6),
                  Text(
                    shedule.scheduleTime == "00:00:00"
                        ? "Not set"
                        : shedule.scheduleTime!,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(shedule.status.toString()).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  shedule.status!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _statusColor(shedule.status!.toLowerCase()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  }
}

Color _statusColor(String status) {
  switch (status) {
    case "pending":
      return Colors.orange;
    case "approved":
      return Colors.green;
    case "cancelled":
      return Colors.red;
    default:
      return Colors.grey;
  }
}
