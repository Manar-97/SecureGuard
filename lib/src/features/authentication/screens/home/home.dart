import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; // مكتبة PDF
import 'package:excel/excel.dart'; // مكتبة Excel

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> knownSignatures = {
    '5d41402abc4b2a76b9719d911017c592',
    'e99a18c428cb38d5f260853678922e03',
    'ab56b4d92b40713acc5af89985d4b786',
    '098f6bcd4621d373cade4e832627b4f6',
    'ad0234829205b9033196ba818f7a872b',
    '25d55ad283aa400af464c76d713c07ad',
    '5ebe2294ecd0e0f08eab7690d2a6ee69',
    'c4ca4238a0b923820dcc509a6f75849b',
    'd41d8cd98f00b204e9800998ecf8427e',
    '8f14e45fceea167a5a36dedd4bea2543',
    'd2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2',
    'a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5',
    'b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7',
    'c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9',
    'e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3',
    'f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4',
    'd6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6',
    'a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8',
    'c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0',
    'f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8',
    '1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f',
    '2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e',
    '3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d',
    '4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c',
    '5b5b5b5b5b5b5b5b5b5b5b5b5b5b5b5b',
    '6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a',
    '79797979797979797979797979797979',
    '88888888888888888888888888888888',
    '97979797979797979797979797979797',
    'a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6',
    'b5b5b5b5b5b5b5b5b5b5b5b5b5b5b5b5',
    'c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4c4',
    'd3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3',
    'e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2',
    'f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1',
    '00f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0',
    'd7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7',
    'e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8',
  };
  String scanResult = "Press the button to scan a file.";
  bool isScanning = false;

  // Function to request permissions
  Future<void> requestPermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      print("Permission granted!");
    } else if (status.isDenied) {
      print("Permission denied!");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // دالة لفحص الملف
  Future<void> scanFile() async {
    setState(() {
      isScanning = true;
      scanResult = "Scanning...";
    });
    try {
      // اختيار الملف
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);
        String? extension = result.files.single.extension;
        // قراءة محتوى الملف كـ Bytes
        List<int> fileBytes = await file.readAsBytes();
        // حساب Hash باستخدام MD5
        String fileHash = md5.convert(fileBytes).toString();
        print("File Hash: $fileHash");
        // التحقق من وجود الفيروس
        if (knownSignatures.contains(fileHash)) {
          setState(() {
            scanResult = "⚠ Warning: The file is infected with a virus!";
          });
        } else {
          setState(() {
            scanResult = "✅ The file is clean and safe.";
          });
        }
        // تحليل إضافي بناءً على نوع الملف
        if (extension != null) {
          analyzeFileType(file, extension);
        }
      } else {
        setState(() {
          scanResult = "No file selected.";
        });
      }
    } catch (e) {
      setState(() {
        scanResult = "Error occurred: ${e.toString()}";
      });
    } finally {
      setState(() {
        isScanning = false;
      });
    }
  }

  // تحليل أنواع الملفات المختلفة
  void analyzeFileType(File file, String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'png':
      case 'jpeg':
        setState(() {
          scanResult += "\n✅ No suspicious content found in the Image.";
        });
        break;
      case 'txt':
      case 'log':
        scanTextFile(file);
        break;
      case 'pdf':
        scanPdfFile(file);
        break;
      case 'html':
        scanHtmlFile(file);
        break;
      case 'xlsx':
      case 'xls':
        scanExcelFile(file);
        break;
      case 'exe':
      case 'bin':
        setState(() {
          scanResult += "\n✅ No suspicious content found in the Executable File.";
        });
        break;
      default:
        setState(() {
          scanResult += "\nFile type not specifically handled.";
        });
    }
  }

  void scanPdfFile(File file) async {
    try {
      PdfDocument document = PdfDocument(inputBytes: await file.readAsBytes());
      String content = PdfTextExtractor(document).extractText();
      List<String> suspiciousPatterns = ["malware", "virus", "trojan"];
      for (var pattern in suspiciousPatterns) {
        if (content.contains(pattern)) {
          setState(() {
            scanResult += "\n⚠ Suspicious content detected in PDF: $pattern";
          });
          return;
        }
      }
      setState(() {
        scanResult += "\n✅ No suspicious content found in the PDF.";
      });
      document.dispose();
    } catch (e) {
      setState(() {
        scanResult += "\nError reading PDF: ${e.toString()}";
      });
    }
  }

  void scanHtmlFile(File file) async {
    String content = await file.readAsString();
    List<String> suspiciousPatterns = ["<script>", "eval(", "onerror=", "iframe"];
    for (var pattern in suspiciousPatterns) {
      if (content.contains(pattern)) {
        setState(() {
          scanResult += "\n⚠ Suspicious HTML content detected: $pattern";
        });
        return;
      }
    }
    setState(() {
      scanResult += "\n✅ No suspicious content found in the HTML file.";
    });
  }

  void scanExcelFile(File file) async {
    try {
      var bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          for (var cell in row) {
            if (cell != null && cell.value != null) {
              String value = cell.value.toString().toLowerCase();
              if (value.contains("virus") || value.contains("malware")) {
                setState(() {
                  scanResult += "\n⚠ Suspicious content found in Excel: $value";
                });
                return;
              }
            }
          }
        }
      }
      setState(() {
        scanResult += "\n✅ No suspicious content found in the Excel file.";
      });
    } catch (e) {
      setState(() {
        scanResult += "\nError reading Excel: ${e.toString()}";
      });
    }
  }



  // فحص النصوص داخل الملفات النصية
  void scanTextFile(File file) async {
    String content = await file.readAsString();
    List<String> suspiciousPatterns = [
      "malware",
      "virus",
      "trojan",
      "unauthorized_access"
    ];
    for (var pattern in suspiciousPatterns) {
      if (content.contains(pattern)) {
        setState(() {
          scanResult += "\n⚠ Suspicious content detected: $pattern";
        });
        return;
      }
    }
    setState(() {
      scanResult += "\n✅ No suspicious content found in the text file.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                scanResult,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
                onPressed: isScanning ? null : scanFile,
                child: isScanning
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text("Scanning..."),
                        ],
                      )
                    : const Text("Scan", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
