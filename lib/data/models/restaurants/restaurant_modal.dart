import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String address;
  final Color color;
  final bool isSelected;
  final String status;


  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.color,
    required this.isSelected,
    required this.status,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['idRestaurant'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      color: json['color'] ?? Colors.white,
      isSelected: json['selected'] ?? false,
      status: json['status'] ?? "active",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'status': status,
    };
  }
}


