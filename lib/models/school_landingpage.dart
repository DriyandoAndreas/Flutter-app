
class SchoolLandingpageModel {
  String? npsn;
  String? url;

  SchoolLandingpageModel({
    this.npsn,
    this.url,
  });

  factory SchoolLandingpageModel.fromJson(Map<String, dynamic> json) {
    return SchoolLandingpageModel(
      npsn: json['npsn'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
