class StaffModal {
  final String name;
  final int phone;
  final String position;
  final String wage;
  final String salarytypel;
  final String Bank;
  
  StaffModal({
    required this.name,
    required this.phone,
    required this.position,
    required this.wage,
    required this.salarytypel,
    required this.Bank,
  });

  factory StaffModal.fromJson(Map<String, dynamic> json) {
    return StaffModal(
      name: json['name'],
      phone: json['phone'],
      position: json['position'],
      wage: json['wage'],
      salarytypel: json['salarytypel'],
      Bank: json['Bank'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'position': position,
      'wage': wage,
      'salarytypel': salarytypel,
      'Bank': Bank,
    };
  }
}


