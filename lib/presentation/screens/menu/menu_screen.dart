import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/presentation/layouts/main_layout.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/header.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Widget _buildMenuItem({
    required String title,
    required String createdBy,
    required String createdAt,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'By: $createdBy\nCreated at: $createdAt',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(
          Icons.more_vert,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          // Header with actions
          const Header(
              title: "Menu", showActionButton: true, showBackButton: true),

          // Menu list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildMenuItem(
                    title: 'Menu 20k',
                    createdBy: 'Thoangtv',
                    createdAt: '21/08/2024',
                    color: Colors.orange,
                  ),
                  _buildMenuItem(
                    title: 'Menu 50k',
                    createdBy: 'Thoangtv',
                    createdAt: '21/08/2024',
                    color: Colors.purple,
                  ),
                  _buildMenuItem(
                    title: 'Menu 100k',
                    createdBy: 'Thoangtv',
                    createdAt: '21/08/2024',
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
