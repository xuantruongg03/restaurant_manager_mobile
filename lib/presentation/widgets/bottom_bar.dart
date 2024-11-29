import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8,
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconSize: 24,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: '',
              ),
            ],
          ),
        ),
        Positioned(
          top: -30,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // Add your action here
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
