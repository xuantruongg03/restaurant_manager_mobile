class CreateReportRequest {
  // final String idReport;
  final String idWorkDay;
  final String note;
  final List<String> imageUrls;

  CreateReportRequest({
    // required this.idReport,
    required this.idWorkDay,
    required this.note,
    required this.imageUrls,
  });

  Map<String, Object> toJson() {
    return {
      // 'idReport': idReport,
      'idWorkDay': idWorkDay,
      'note': note,
      'imageUrls': imageUrls,
    };
  }
}
