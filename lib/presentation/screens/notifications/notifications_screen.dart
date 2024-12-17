import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/models/noti/noti_modal.dart';
import 'package:restaurant_manager_mobile/presentation/controllers/noti/noti_controller.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/utils/formats.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class NotificationsScreen extends GetView<NotiController> {
  const NotificationsScreen({super.key});

  Widget _itemNoti(NotiModal noti) {
    return GestureDetector(
      onTap: () {
        if (!noti.isRead.value) {
          controller.markAsRead(noti.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => noti.isRead.value
                ? const SizedBox(width: 16)
                : Padding(
                    padding: const EdgeInsets.only(top: 6, right: 8),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        noti.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!Functions.isToday(DateTime.parse(noti.date)))
                        Text(
                          formatDate(DateTime.parse(noti.date)),
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    noti.content,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatTime(DateTime.parse(noti.time)),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotiList() {
    final groupedNotis = controller.groupNotifications();

    return ListView.builder(
      itemCount: groupedNotis.length,
      itemBuilder: (context, index) {
        String groupTitle = groupedNotis.keys.elementAt(index);
        List<NotiModal> notifications = groupedNotis[groupTitle]!;

        // Chỉ hiển thị nhóm khi có thông báo
        if (notifications.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (groupedNotis["Hôm nay"]!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        groupTitle,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ...notifications.map((noti) => _itemNoti(noti)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoNoti() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/no_noti.png"),
            const SizedBox(height: 20),
            const Text(
              "Không có thông báo",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text("Không có thông báo nào cho bạn gần đây"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Header(
            title: "Thông báo",
            showNotificationButton: true,
            onNotificationPressed: () {
              controller.markReadAll();
            },
            showSettingButton: true,
            onSettingPressed: () {},
          ),
          if (controller.notis.isEmpty)
            _buildNoNoti()
          else
            Expanded(child: _buildNotiList()),
        ],
      ),
    );
  }
}
