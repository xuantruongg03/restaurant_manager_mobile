import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notis = [
    {
      "title": "Thông báo nè",
      "content": "Bạn có đơn hàng mới ở bàn 1",
      "time": "19:35",
      "date": "1/12/2024",
      "isRead": false,
    },
    {
      "title": "Thông báo nè",
      "content": "Bạn có đơn hàng mới ở bàn 2",
      "time": "19:35",
      "date": "8/12/2024",
      "isRead": false,
    },
    {
      "title": "Thông báo nè",
      "content": "Bạn có đơn hàng mới ở bàn 2",
      "time": "19:35",
      "date": "8/12/2024",
      "isRead": true,
    },
    {
      "title": "Thông báo nè",
      "content": "Bạn có đơn hàng mới ở bàn 2",
      "time": "19:35",
      "date": "8/12/2024",
      "isRead": false,
    },
  ];

  Map<String, List<Map<String, dynamic>>> _groupNotifications() {
    final Map<String, List<Map<String, dynamic>>> grouped = {
      "Hôm nay": [],
      "Trước đó": [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var noti in notis) {
      // Parse date string (assuming format is dd/MM/yyyy)
      final parts = noti["date"].split('/');
      final notiDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );

      if (notiDate.isAtSameMomentAs(today)) {
        grouped["Hôm nay"]!.add(noti);
      } else {
        grouped["Trước đó"]!.add(noti);
      }
    }

    return grouped;
  }

  Widget _itemNoti(String title, String content, String time, bool isRead,
      String date, bool isLast) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isRead)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 8),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            )
          else
            const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!isLast)
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
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
    );
  }

  Widget _buildNotiList() {
    final groupedNotis = _groupNotifications();

    return ListView.builder(
      itemCount: groupedNotis.length,
      itemBuilder: (context, index) {
        String groupTitle = groupedNotis.keys.elementAt(index);
        List<Map<String, dynamic>> notifications = groupedNotis[groupTitle]!;

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
                  ...notifications
                      .map((noti) => _itemNoti(
                            noti["title"],
                            noti["content"],
                            noti["time"],
                            noti["isRead"],
                            noti["date"],
                            index == 0,
                          ))
                      ,
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
      body: Expanded(
        child: Column(
          children: [
            Header(
              title: "Thông báo",
              showNotificationButton: true,
              onNotificationPressed: () {},
              showSettingButton: true,
              onSettingPressed: () {},
            ),
            if (notis.isEmpty)
              _buildNoNoti()
            else
              Expanded(child: _buildNotiList()),
          ],
        ),
      ),
    );
  }
}
