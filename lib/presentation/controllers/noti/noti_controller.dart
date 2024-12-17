import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/models/noti/noti_modal.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';
import 'package:restaurant_manager_mobile/utils/functions.dart';

class NotiController extends GetxController {
  final RxList<NotiModal> notis = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    fetchNotis();
  }

  Future<void> fetchNotis() async {
    final StorageService storageService = await StorageService.getInstance();
    final notisData = storageService.getList("notis");
    if (notisData != null) {
      notis.value = RxList.from(notisData.map((item) => NotiModal.fromJson(item as Map<String, dynamic>)).toList());
      notis.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date))); 
    }
}

  Future<void> handleNotification(String data) async {
    final StorageService storageService = await StorageService.getInstance();
    final noti = NotiModal(
      id: Functions.generateRandomString(10),
      title: "Thông báo từ nhà hàng ${storageService.getString(StorageKeys.restaurantName)}",
      content: data,
      time: DateTime.now().toString(),
      isRead: false,
      date: DateTime.now().toString(),
    );
    notis.add(noti);
    final notisList = notis.map((n) => n.toJson()).toList();
    storageService.setList("notis", notisList);
  }

  Map<String, List<NotiModal>> groupNotifications() {
    final Map<String, List<NotiModal>> grouped = {
      "Hôm nay": [],
      "Trước đó": [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var noti in notis) {
      final notiDate = DateTime.parse(noti.date);
      final date = DateTime(notiDate.year, notiDate.month, notiDate.day);

      if (date.isAtSameMomentAs(today)) {
        grouped["Hôm nay"]!.add(noti);
      } else {
        grouped["Trước đó"]!.add(noti);
      }
    }

    return grouped;
  }

  void markReadAll() async {
    final StorageService storageService = await StorageService.getInstance();
    final notisList = notis.map((n) => n.toJson()).toList();
    for (var i = 0; i < notisList.length; i++) {
      notisList[i]['isRead'] = true;
    }
    storageService.setList("notis", notisList);
  }

  void markAsRead(String id) async {
    final StorageService storageService = await StorageService.getInstance();
    final notisList = notis.map((n) => n.toJson()).toList();
    for (var i = 0; i < notisList.length; i++) {
      if (notisList[i]['id'] == id) {
        notisList[i]['isRead'] = true;
        break;
      }
    }
    storageService.setList("notis", notisList);
  }
}
