import 'package:flutter/material.dart';
import 'dart:math';

class MenuModel {
  final String idMenu;
  final String name;
  final String status;
  final String createdBy;
  final String createdAt;
  final bool isActive;
  final Color color;

  MenuModel({
    required this.idMenu,
    required this.name,
    required this.status,
    this.createdBy = "",
    this.createdAt = "",
    this.isActive = false,
    this.color = Colors.black,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      idMenu: json['idMenu'],
      name: json['name'],
      status: json['status'],
      createdBy: "TruongLee",
      createdAt: json['createAt'],
      isActive: json['status'] == "Active",
      color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    );
  }
}
