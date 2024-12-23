  class UserupdateRequest {
    final String? idAccount;
    final String? name;
     String? avt;
    final DateTime? birthdate;
  UserupdateRequest({
    this.idAccount,
    this.birthdate,
    this.name,
    this.avt
  });
  
 // Chuyển đổi toàn bộ dữ liệu thành JSON
  Map<String, dynamic> toJson() => {
        'idAccount': idAccount,
        'name': name,
        'avt': avt,
        'birthdate': birthdate?.toIso8601String(), // Định dạng ngày thành chuỗi ISO 8601
      };

  // Chuyển đổi chỉ các trường không null thành JSON
  Map<String, dynamic> toPartialJson() {
    final data = <String, dynamic>{};
    if (idAccount != null) data['idAccount'] = idAccount;
    if (name != null) data['name'] = name;
    if (avt != null) data['avt'] = avt;
    if (birthdate != null) data['birthdate'] = birthdate?.toIso8601String();
    return data;
  }
}