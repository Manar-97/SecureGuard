class ScanResult {
  final String status;
  final String details;

  ScanResult({required this.status, required this.details});

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      status: json['status'],
      details: json['details'],
    );
  }
}
