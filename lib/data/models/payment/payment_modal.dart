class PaymentModel {
  final String partnercode;
  final String secretkey;
  final String accesskey;

  PaymentModel({
    required this.partnercode,
    required this.secretkey,
    required this.accesskey,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      partnercode: json['partnercode'],
      secretkey: json['secretkey'],
      accesskey: json['accesskey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partnercode': partnercode,
      'secretkey': secretkey,
      'accesskey': accesskey,
    };
  }
}
