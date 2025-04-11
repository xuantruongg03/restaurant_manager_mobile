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

  @override
  String toString() {
    return 'ReportImage(idReportImage: $idReportImage, url: $url)';
  }
}

class ReportModel {
  final String idReport;
  final String workDayStart;
  final String employeeName;
  final String note;
  final List<ReportImage> reportImages;

  ReportModel({
    required this.idReport,
    required this.workDayStart,
    required this.employeeName,
    required this.note,
    required this.reportImages,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      idReport: json['idReport'],
      note: json['note'],
      workDayStart: json['startDate'],
      employeeName: json['employeeName'],
      reportImages: (json['reportImages'] as List)
          .map((e) => ReportImage.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'ReportModel(idReport: $idReport, workDayStart: $workDayStart, employeeName: $employeeName, note: $note, reportImages: $reportImages)';
  }
}
