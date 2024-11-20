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
  String? selectedFilePath;

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

  // Function to pick a file
  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          selectedFilePath = result.files.single.path;
        });
        print("Selected file: $selectedFilePath");
      } else {
        print("No file selected.");
      }
    } catch (e) {
      print("Error while picking the file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await requestPermission();
                      await pickFile();
                    },
                    child: const Text('Scan Files'))),
            if (selectedFilePath != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Selected File: $selectedFilePath",
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
