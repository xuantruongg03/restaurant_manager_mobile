class PaymentModel {
  final String partnercode;
  final String secretkey;
  final String accesskey;
  final String idPayment;
  final String idRestaurant;

  PaymentModel({
    required this.partnercode,
    required this.secretkey,
    required this.accesskey,
    required this.idPayment,
    required this.idRestaurant,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      partnercode: json['partnerCode'],
      secretkey: json['secretKey'],
      accesskey: json['accessKey'],
      idPayment: json['idPayment'],
      idRestaurant: json['idRestaurant'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partnerCode': partnercode,
      'secretKey': secretkey,
      'accessKey': accesskey,
      'idPayment': idPayment,
      'idRestaurant': idRestaurant,
    };
  }
}
