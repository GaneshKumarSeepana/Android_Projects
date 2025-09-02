import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter File Save Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Text Saver App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  /// ✅ Check storage permission
  Future<bool> _checkPermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage Permission Denied")),
      );
      return false;
    }
  }

  /// ✅ Get file from external storage
  Future<File?> _getLocalFile(String filename) async {
    if (!await _checkPermission()) return null;
    final dir = await getExternalStorageDirectory();
    print("External Storage Directory: ${dir?.path}");
    return File("${dir!.path}/$filename");
  }

  /// ✅ Save text
  Future<void> _saveTextToFile() async {
    final file = await _getLocalFile("saved_text.txt");
    if (file == null) return;

    await file.writeAsString(_controller.text);

    print("=== SAVE ACTION ===");
    print("File Path: ${file.path}");
    print("Saved Text: ${_controller.text}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Text Saved to File")),
    );
  }

  /// ✅ Read text
  Future<void> _readTextFromFile() async {
    try {
      final file = await _getLocalFile("saved_text.txt");
      if (file == null) return;

      String contents = await file.readAsString();

      setState(() {
        _controller.text = contents;
      });

      print("=== RETRIEVE ACTION ===");
      print("File Path: ${file.path}");
      print("Retrieved Text: $contents");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Text Retrieved from File")),
      );
    } catch (e) {
      print("Error reading file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file found to retrieve")),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your text here...",
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveTextToFile,
                    child: const Text("Save"),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _readTextFromFile,
                    child: const Text("Retrieve"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}