import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/data/services/auth_service.dart';
import 'package:restaurant_manager_mobile/data/services/storage_service.dart';

class ConfirmPhoneScreen extends StatefulWidget {
  const ConfirmPhoneScreen({super.key});

  @override
  State<ConfirmPhoneScreen> createState() => _ConfirmPhoneScreenState();
}

class _ConfirmPhoneScreenState extends State<ConfirmPhoneScreen> {
  final _phoneController = TextEditingController();
  final _authService = AuthService();
  late StorageService storage;
  bool _isLoading = false;
  String? username;
  String? password;

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    _phoneController.text = "0981793201";
    // storage = await StorageService.getInstance();
    // setState(() {
    //   username = storage.getString('username');
    //   password = storage.getString('password'); 
    // });
    
    // if (username != null && password != null) {
    //   // Có thể gọi API để lấy số điện thoại từ server
    //   try {
    //     final response = await _authService.getPhone(username!, password!);
    //     if (response['success']) {
    //       setState(() {
    //         _phoneController.text = response['data']['phone'] ?? '';
    //       });
    //     }
    //   } catch (e) {
    //     debugPrint('Error getting phone: $e');
    //   }
    // }
  }

  Future<void> _handleConfirmPhone() async {
    setState(() {
      _isLoading = true;
    });
    final response = await _authService.sendOTP(_phoneController.text);
    if (response['success']) {
      Navigator.pushNamed(context, RouteNames.verify, arguments: {
        'phone': _phoneController.text
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'EASTERY',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KaiseiDecol',
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'The best your choise',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontFamily: 'KaiseiDecol',
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                child: Image.asset('assets/images/confirm-phone.png'),
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Nhập số điện thoại',
                  filled: true,
                  fillColor: Colors.grey[100],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Đây có phải số điện thoại của bạn không?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleConfirmPhone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Tiếp tục',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                          ),
                        ),
                  )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
