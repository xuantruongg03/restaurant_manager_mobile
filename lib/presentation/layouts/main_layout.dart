import 'package:flutter/material.dart';
import 'package:restaurant_manager_mobile/presentation/widgets/bottom_bar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;

  const MainLayout({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.showBackButton = false,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null
          ? AppBar(
              title: Text(
                widget.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              leading: widget.showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
              actions: widget.actions,
            )
          : null,
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
