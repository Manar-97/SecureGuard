import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? filePath;
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
    'd2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2',
    'a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5',
    'b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7',
    'c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9',
    'e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3',
    'f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4',
    'd6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6',
    'a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8a8',
    'c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0',
    'd7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7',
    'e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8',
  };
  String scanResult = '';

  // Function to generate Signature
  String generateSignature(List<int> contentBytes) {
    var digest = md5.convert(contentBytes);
    return digest.toString(); // ارجع التوقيع كـ string
  }

// دالة لفحص الملف بناءً على توقيعه
  bool isFileSafe(List<int> contentBytes) {
    String signature = generateSignature(contentBytes);
    return !knownSignatures
        .contains(signature); // إذا كان التوقيع غير موجود في التوقيعات المعروفة
  }

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

  // دالة لاختيار ملف
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        filePath = File(result.files.single.path!);
      });
      scanFile(filePath!.path);
    }
  }

// دالة لفحص الملف
  Future<void> scanFile(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes(); // قراءة الملف كـ bytes

      final extension = filePath.split('.').last.toLowerCase();

      // التحقق إذا كان الملف يحتوي على توقيع معروف
      if (isFileSafe(bytes)) {
        setState(() {
          scanResult = '${extension.toUpperCase()} file is safe';
        });
      } else {
        setState(() {
          scanResult = '${extension.toUpperCase()} file is infected';
        });
      }
    } catch (e) {
      setState(() {
        scanResult = 'Error reading the file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
                onPressed: () async {
                  await requestPermission();
                  await pickFile();
                },
                child: const Text('Scan File'),
              ),
            ),
            const SizedBox(height: 20),
            scanResult.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        color: scanResult == 'File is infected'
                            ? Colors.redAccent
                            : Colors.green,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              scanResult.contains('infected')
                                  ? Icons.warning_amber_rounded
                                  : Icons.check_circle_outline,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              scanResult,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
