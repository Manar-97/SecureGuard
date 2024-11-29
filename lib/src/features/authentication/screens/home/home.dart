import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // إضافة المكتبة الخاصة بالأذونات
import '../../../../../data/api/malware_scan_api.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VirusTotalAPI virusTotalAPI = VirusTotalAPI();
  String result = "Scan result will appear here.";
  bool isLoading = false;
  String fileReport = "";

  // دالة لاختيار الملف بعد التحقق من الأذونات
  Future<void> pickAndScanFile(BuildContext context) async {
    // طلب إذن الوصول إلى التخزين
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // إذا تم منح الإذن، اختر الملف
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
      if (pickedFile != null && pickedFile.files.single.path != null) {
        String filePath = pickedFile.files.single.path!;
        File file = File(filePath);

        setState(() {
          isLoading = true;
          result = "Uploading and scanning...";
        });

        String? fileHash = await VirusTotalAPI.uploadFile(file);

        if (fileHash != null) {
          await Future.delayed(const Duration(seconds: 10)); // انتظار النتيجة

          String? report = await VirusTotalAPI.getFileReport(fileHash);
          setState(() {
            if (report != null) {
              // تحليل التقرير لمعرفة عدد النتائج المشبوهة
              int maliciousCount = _extractMaliciousCount(report);

              if (maliciousCount == 0) {
                fileReport = "The file is safe. No threats detected.";
              } else {
                fileReport =
                    "The file contains $maliciousCount threat(s). It is malicious.";
              }
              result = "File uploaded successfully.";
            } else {
              fileReport = "No report found.";
              result = "Failed to retrieve the scan report.";
            }
            isLoading = false;
          });

          // إظهار تقرير الفحص في مربع حوار
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Scan Report",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      fileReport.isNotEmpty
                          ? Text(
                              fileReport,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[400]),
                            )
                          : Container(),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            result = "Failed to upload file.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          result = "No file selected.";
          isLoading = false;
        });
      }
    } else {
      // إذا تم رفض الإذن
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission to access files is denied.")),
      );
    }
  }

  // دالة لتحليل التقرير واستخراج عدد التهديدات
  int _extractMaliciousCount(String report) {
    try {
      Map<String, dynamic> jsonReport = jsonDecode(report);
      return jsonReport['malicious'] ?? 0; // افترض أن المفتاح "malicious" موجود
    } catch (e) {
      debugPrint("Error parsing report: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Virus Scanner")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? const LinearProgressIndicator() // شريط التقدم
                  : Column(
                      children: [
                        Text(
                          result,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 10,
                          shadowColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 40,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Scan Report",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.blue),
                                ),
                                const SizedBox(height: 10),
                                const Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    fileReport.isEmpty
                                        ? "No report available yet."
                                        : fileReport,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[600]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: () => pickAndScanFile(context),
                          icon: const Icon(Icons.upload_file),
                          label: const Text("Pick and Scan File"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                            backgroundColor: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
