class ReportImage {
  final String idReportImage;
  final String url;

  ReportImage({
    required this.idReportImage,
    required this.url,
  });

  factory ReportImage.fromJson(Map<String, dynamic> json) {
    return ReportImage(
      idReportImage: json['idReportImage'],
      url: json['url'],
    );
  }
}

class ReportDetailResponse {
  final String idReport;
  final String note;
  final List<ReportImage> reportImages;

  ReportDetailResponse({
    required this.idReport,
    required this.note,
    required this.reportImages,
  });

  factory ReportDetailResponse.fromJson(Map<String, dynamic> json) {
    return ReportDetailResponse(
      idReport: json['idReport'],
      note: json['note'],
      reportImages: (json['reportImages'] as List)
          .map((e) => ReportImage.fromJson(e))
          .toList(),
    );
  }
}
