import 'package:flutter/material.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo và tiêu đề
              const Center(
                child: Column(
                  children: [
                    Text(
                      'EASTERY',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KaiseiDecol',
                      ),
                    ),
                    Text(
                      'The best your choise',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontFamily: 'KaiseiDecol',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Tiêu đề xác nhận
              const Text(
                'Xác nhận tài khoản',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Đảm bảo an toàn cho bạn!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // Verify image
              Center(
                child: Image.asset(
                'assets/images/verify-icon.png',
                width: 100,
                height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),

              // Input OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      index < 3 ? ['5', '4', '8'][index] : '-',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Thời gian còn lại
              Center(
                child: Text(
                'Gửi lại sau 01:15',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Nút xác nhận
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
