import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_manager_mobile/core/theme/color_schemes.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/textfield_custom.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  String? selectedCategory;
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _images.add(File(image.path));
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Widget _buildImageGrid() {
    List<Widget> items = [
      ..._images.asMap().entries.map((entry) {
        int idx = entry.key;
        File image = entry.value;
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: FileImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: GestureDetector(
                onTap: () => _removeImage(idx),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      if (_images.length < 5)
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.add, size: 24),
          ),
        ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1,
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Header(
            title: 'Thêm món ăn',
            showBackButton: true,
            showActionButton: true,
            actionButtonText: 'Thêm',
            onActionPressed: () {
              print('Add food');
            },
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tên món:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  const TextFieldCustom(
                    hintText: 'Nhập tên món...',
                    // contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  const SizedBox(height: 12),
                  const Text('Giá món:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  const TextFieldCustom(
                    hintText: 'Nhập giá món...',
                    // contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  const SizedBox(height: 12),
                  const Text('Loại:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _showCategoryDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedCategory ?? 'Chọn loại món ăn',
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedCategory == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Hình ảnh:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  _buildImageGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCategoryDialog(BuildContext context) async {
    final List<String> categories = ['Đồ ăn', 'Đồ uống', 'Tráng miệng', 'Khác'];

    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Chọn loại món ăn'),
          children: categories.map((String category) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, category),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: selectedCategory == category
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedCategory = result;
      });
    }
  }
}
