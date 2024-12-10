import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/config/routes/route_names.dart';

class CreateRestaurantModal extends StatefulWidget {
  const CreateRestaurantModal({super.key});

  @override
  State<CreateRestaurantModal> createState() => _CreateRestaurantModalState();
}

class _CreateRestaurantModalState extends State<CreateRestaurantModal> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Khởi tạo nhà hàng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 20),
                Form(
                    key: formKey,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Tên nhà hàng',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên nhà hàng';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _createRestaurant();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    'Tạo',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createRestaurant() {
    if (formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, RouteNames.home);
    }
  }
}
