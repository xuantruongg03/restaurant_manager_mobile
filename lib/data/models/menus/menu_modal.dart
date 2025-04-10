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
  bool isSelected;

  MenuModel({
    required this.idMenu,
    required this.name,
    required this.status,
    this.createdBy = "",
    this.createdAt = "",
    this.isActive = false,
    this.color = Colors.black,
    this.isSelected = false
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      idMenu: json['idMenu'],
      name: json['name'],
      status: json['status'],
      createdBy: "truong",
      createdAt: json['createAt'],
      isActive: json['status'] == "Active",
      color: json['color'] != null 
          ? Color(json['color']) 
          : Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMenu': idMenu,
      'name': name, 
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'isActive': isActive,
      'color': color.value,
      'isSelected': isSelected,
    };
  }
}
