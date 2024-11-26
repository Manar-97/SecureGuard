import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../data/api/malware_scan_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String scanResult = "Press the button to scan all files.";
  bool isScanning = false;
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Text(
                scanResult,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),

            // شريط التقدم أثناء الفحص
            isScanning
                ? Column(
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        color: Colors.blue,
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Scanning... ${(progress * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  )
                : Container(),

            const Spacer(),

            // زر "Scan All Files"
            SizedBox(
              height: 170,
              width: 170,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  backgroundColor: Colors.brown,
                ),
                onPressed: isScanning
                    ? null
                    : () async {
                        await requestPermission(); // طلب الأذونات قبل بدء الفحص
                        startScan(); // بدء الفحص
                      },
                child: Text(
                  isScanning ? "Scanning..." : "Scan All Files",
                  style: const TextStyle(fontSize: 18,color: Colors.black),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  // دالة لتحديث التقدم خلال الفحص (محاكاة)
  Future<void> startScan() async {
    setState(() {
      isScanning = true;
      progress = 0.0; // إعادة تعيين التقدم عند بداية الفحص
    });

    // محاكاة عملية الفحص: يتم تأخير التقدم بشكل تدريجي لتمثيل عملية الفحص
    await Future.delayed(const Duration(seconds: 1));
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(
          const Duration(milliseconds: 30)); // تأخير لتحديث شريط التقدم
      setState(() {
        progress = i / 100; // تحديث شريط التقدم
      });
    }

    // بعد إتمام الفحص، استدعاء الـAPI
    String result = await MalwareScanApi.scanAllFiles();
    setState(() {
      scanResult = result; // تحديث النتيجة بناءً على الرد من الـAPI
      isScanning = false; // إيقاف شريط التقدم بعد انتهاء الفحص
    });
  }

  // طلب إذن للوصول إلى التخزين
  Future<void> requestPermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      print("Permission granted!");
    } else if (status.isDenied) {
      print("Permission denied!");
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // فتح إعدادات التطبيق لتمكين الأذونات
    }
  }
}
