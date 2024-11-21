// import 'dart:io';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart'; // مكتبة PDF
// import 'package:excel/excel.dart'; // مكتبة Excel
//
// class VirusScannerApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Virus Scanner',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: VirusScannerPage(),
//     );
//   }
// }
//
// class VirusScannerPage extends StatefulWidget {
//   @override
//   _VirusScannerPageState createState() => _VirusScannerPageState();
// }
//
// class _VirusScannerPageState extends State<VirusScannerPage> {
//   String scanResult = "Press the button to scan a file.";
//   bool isScanning = false;
//
//   final List<String> virusSignatures = [
//     "5d41402abc4b2a76b9719d911017c592", // توقيع MD5
//     "098f6bcd4621d373cade4e832627b4f6", // توقيع آخر
//   ];
//
//   Future<void> scanFile() async {
//     setState(() {
//       isScanning = true;
//       scanResult = "Scanning...";
//     });
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles();
//       if (result != null) {
//         File file = File(result.files.single.path!);
//         String? extension = result.files.single.extension;
//
//         // قراءة الملف كـ Bytes
//         List<int> fileBytes = await file.readAsBytes();
//         String fileHash = md5.convert(fileBytes).toString();
//
//         if (virusSignatures.contains(fileHash)) {
//           setState(() {
//             scanResult = "⚠ Warning: The file is infected with a virus!";
//           });
//         } else {
//           setState(() {
//             scanResult = "✅ The file is clean and safe.";
//           });
//         }
//
//         if (extension != null) {
//           analyzeFileType(file, extension);
//         }
//       } else {
//         setState(() {
//           scanResult = "No file selected.";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         scanResult = "Error occurred: ${e.toString()}";
//       });
//     } finally {
//       setState(() {
//         isScanning = false;
//       });
//     }
//   }
//
//   void analyzeFileType(File file, String extension) {
//     switch (extension.toLowerCase()) {
//       case 'jpg':
//       case 'png':
//       case 'jpeg':
//         setState(() {
//           scanResult += "\nThis is an image file.";
//         });
//         break;
//       case 'txt':
//         scanTextFile(file);
//         break;
//       case 'pdf':
//         scanPdfFile(file);
//         break;
//       case 'html':
//         scanHtmlFile(file);
//         break;
//       case 'xlsx':
//       case 'xls':
//         scanExcelFile(file);
//         break;
//       default:
//         setState(() {
//           scanResult += "\nFile type not specifically handled.";
//         });
//     }
//   }
//
//   void scanTextFile(File file) async {
//     String content = await file.readAsString();
//     List<String> suspiciousPatterns = ["malware", "virus", "trojan", "unauthorized_access"];
//     for (var pattern in suspiciousPatterns) {
//       if (content.contains(pattern)) {
//         setState(() {
//           scanResult += "\n⚠ Suspicious content detected: $pattern";
//         });
//         return;
//       }
//     }
//     setState(() {
//       scanResult += "\n✅ No suspicious content found in the text file.";
//     });
//   }
//
//   void scanPdfFile(File file) async {
//     try {
//       PdfDocument document = PdfDocument(inputBytes: await file.readAsBytes());
//       String content = PdfTextExtractor(document).extractText();
//       List<String> suspiciousPatterns = ["malware", "virus", "trojan"];
//       for (var pattern in suspiciousPatterns) {
//         if (content.contains(pattern)) {
//           setState(() {
//             scanResult += "\n⚠ Suspicious content detected in PDF: $pattern";
//           });
//           return;
//         }
//       }
//       setState(() {
//         scanResult += "\n✅ No suspicious content found in the PDF.";
//       });
//       document.dispose();
//     } catch (e) {
//       setState(() {
//         scanResult += "\nError reading PDF: ${e.toString()}";
//       });
//     }
//   }
//
//   void scanHtmlFile(File file) async {
//     String content = await file.readAsString();
//     List<String> suspiciousPatterns = ["<script>", "eval(", "onerror=", "iframe"];
//     for (var pattern in suspiciousPatterns) {
//       if (content.contains(pattern)) {
//         setState(() {
//           scanResult += "\n⚠ Suspicious HTML content detected: $pattern";
//         });
//         return;
//       }
//     }
//     setState(() {
//       scanResult += "\n✅ No suspicious content found in the HTML file.";
//     });
//   }
//
//   void scanExcelFile(File file) async {
//     try {
//       var bytes = await file.readAsBytes();
//       var excel = Excel.decodeBytes(bytes);
//       for (var table in excel.tables.keys) {
//         for (var row in excel.tables[table]!.rows) {
//           for (var cell in row) {
//             if (cell != null && cell.value != null) {
//               String value = cell.value.toString().toLowerCase();
//               if (value.contains("virus") || value.contains("malware")) {
//                 setState(() {
//                   scanResult += "\n⚠ Suspicious content found in Excel: $value";
//                 });
//                 return;
//               }
//             }
//           }
//         }
//       }
//       setState(() {
//         scanResult += "\n✅ No suspicious content found in the Excel file.";
//       });
//     } catch (e) {
//       setState(() {
//         scanResult += "\nError reading Excel: ${e.toString()}";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Virus Scanner'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               scanResult,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18, color: Colors.black),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: isScanning ? null : scanFile,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//               ),
//               child: isScanning
//                   ? Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Text("Scanning..."),
//                 ],
//               )
//                   : Text("Scan", style: TextStyle(fontSize: 18)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(VirusScannerApp());
// }