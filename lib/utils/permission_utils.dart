import 'package:get/get.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';
import 'package:restaurant_manager_mobile/presentation/screens/modals/permission_denied_modal.dart';
import 'package:restaurant_manager_mobile/utils/constant.dart';

class PermissionUtils {
  // Kiểm tra quyền owner
  static Future<bool> checkOwnerPermission() async {
    final storageService = await StorageService.getInstance();
    final role = storageService.getString(StorageKeys.role);
    return role == 'Owner';
  }

  // Kiểm tra quyền owner và hiển thị modal nếu không có quyền
  static Future<bool> checkOwnerPermissionWithModal() async {
    final hasPermission = await checkOwnerPermission();
    if (!hasPermission) {
      Get.dialog(const PermissionDeniedModal());
    }
    return hasPermission;
  }

  // Kiểm tra quyền owner và điều hướng đến route nếu có quyền
  static Future<void> navigateIfOwner(String routeName) async {
    if (await checkOwnerPermissionWithModal()) {
      Get.toNamed(routeName);
    }
  }

  // Kiểm tra nhiều loại quyền khác nhau
  static Future<bool> checkPermission(List<String> allowedRoles) async {
    final storageService = await StorageService.getInstance();
    final userRole = storageService.getString(StorageKeys.role);
    return allowedRoles.contains(userRole);
  }

  // Kiểm tra nhiều loại quyền và hiển thị modal
  static Future<bool> checkPermissionWithModal(List<String> allowedRoles) async {
    final hasPermission = await checkPermission(allowedRoles);
    if (!hasPermission) {
      Get.dialog(const PermissionDeniedModal());
    }
    return hasPermission;
  }

  // Kiểm tra nhiều loại quyền và điều hướng
  static Future<void> navigateIfHasPermission(
    String routeName,
    List<String> allowedRoles,
  ) async {
    if (await checkPermissionWithModal(allowedRoles)) {
      Get.toNamed(routeName);
    }
  }

  // Kiểm tra quyền xóa
  static Future<bool> checkDeletePermission() async {
    final storageService = await StorageService.getInstance();
    final role = storageService.getString(StorageKeys.role);
    return role == 'Owner' || role == 'Manager';
  }

  // Kiểm tra quyền xóa với modal
  static Future<bool> checkDeletePermissionWithModal() async {
    final hasPermission = await checkDeletePermission();
    if (!hasPermission) {
      Get.dialog(const PermissionDeniedModal());
    }
    return hasPermission;
  }

  // Kiểm tra quyền chọn chính (primary)
  static Future<bool> checkPrimarySelectionPermission() async {
    final storageService = await StorageService.getInstance();
    final role = storageService.getString(StorageKeys.role);
    return role == 'Owner' || role == 'Manager';
  }

  // Kiểm tra quyền chọn chính với modal
  static Future<bool> checkPrimarySelectionPermissionWithModal() async {
    final hasPermission = await checkPrimarySelectionPermission();
    if (!hasPermission) {
      Get.dialog(const PermissionDeniedModal());
    }
    return hasPermission;
  }
}