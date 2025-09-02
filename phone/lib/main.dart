import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File? _approvedMedia;
  bool _approvedIsVideo = false;
  VideoPlayerController? _approvedVideoController;

  File? _pendingMedia;
  bool _pendingIsVideo = false;
  VideoPlayerController? _pendingVideoController;

  final ImagePicker _picker = ImagePicker();
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.photos,
      Permission.storage,
      Permission.contacts,
    ].request();
  }

  // ----------------- Dial -----------------
  Future<void> _dialNumber(String number) async {
    final Uri telUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      _showSnack('Could not launch dialer');
    }
  }

  void _showDialDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dial Number'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: 'Enter phone number'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final n = controller.text.trim();
              Navigator.pop(context);
              if (n.isNotEmpty) _dialNumber(n);
            },
            child: const Text('Dial'),
          ),
        ],
      ),
    );
  }

  // ----------------- SMS -----------------
  Future<void> _sendSMS(String number, String message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: {'body': message},
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      _showSnack('Could not open SMS app');
    }
  }

  void _showMessageOptions() {
    final numberController = TextEditingController();
    final msgController = TextEditingController(text: "Hello from Flutter!");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Message"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone number"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: msgController,
              decoration: const InputDecoration(labelText: "Message"),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final n = numberController.text.trim();
              final m = msgController.text.trim();
              Navigator.pop(context);
              if (n.isNotEmpty && m.isNotEmpty) {
                _sendSMS(n, m);
              }
            },
            child: const Text("SMS"),
          ),
        ],
      ),
    );
  }

  // ----------------- Contacts -----------------
  Future<void> _fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() => _contacts = contacts);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Contacts'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                final phone = contact.phones.isNotEmpty
                    ? contact.phones.first.number
                    : 'No number';
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(contact.displayName),
                  subtitle: Text(phone),
                  onTap: () {
                    Navigator.pop(context);
                    _dialNumber(phone);
                  },
                );
              },
            ),
          ),
        ),
      );
    } else {
      _showSnack('Contacts permission denied');
    }
  }

  // ----------------- Capture / Record -----------------
  Future<void> _capturePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      _pendingVideoController?.dispose();
      setState(() {
        _pendingMedia = File(photo.path);
        _pendingIsVideo = false;
        _pendingVideoController = null;
      });
    }
  }

  Future<void> _recordVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      _pendingVideoController?.dispose();
      final controller = VideoPlayerController.file(File(video.path));
      await controller.initialize();
      controller.play();
      setState(() {
        _pendingMedia = File(video.path);
        _pendingIsVideo = true;
        _pendingVideoController = controller;
      });
    }
  }

  void _acceptMedia() {
    _approvedVideoController?.dispose();
    setState(() {
      _approvedMedia = _pendingMedia;
      _approvedIsVideo = _pendingIsVideo;
      _approvedVideoController =
      _pendingIsVideo ? _pendingVideoController : null;
      _pendingMedia = null;
      _pendingIsVideo = false;
      _pendingVideoController = null;
    });
  }

  void _discardMedia() {
    _pendingVideoController?.dispose();
    setState(() {
      _pendingMedia = null;
      _pendingIsVideo = false;
      _pendingVideoController = null;
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _approvedVideoController?.dispose();
    _pendingVideoController?.dispose();
    super.dispose();
  }

  // ----------------- UI -----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Actions")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: _showDialDialog, child: const Text("Dial Number")),
            ElevatedButton(
                onPressed: _showMessageOptions, child: const Text("Message")),
            ElevatedButton(
                onPressed: _fetchContacts, child: const Text("Open Contacts")),
            ElevatedButton(
                onPressed: _capturePhoto, child: const Text("Capture Photo")),
            ElevatedButton(
                onPressed: _recordVideo, child: const Text("Record Video")),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text("Last accepted:",
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            if (_approvedMedia == null)
              const Text("None yet")
            else
              (_approvedIsVideo
                  ? (_approvedVideoController != null &&
                  _approvedVideoController!.value.isInitialized
                  ? AspectRatio(
                aspectRatio:
                _approvedVideoController!.value.aspectRatio,
                child: VideoPlayer(_approvedVideoController!),
              )
                  : const CircularProgressIndicator())
                  : Image.file(_approvedMedia!, height: 200)),

            const Divider(height: 32),

            if (_pendingMedia != null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Preview (pending):",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 8),
              _pendingIsVideo
                  ? (_pendingVideoController != null &&
                  _pendingVideoController!.value.isInitialized
                  ? AspectRatio(
                aspectRatio:
                _pendingVideoController!.value.aspectRatio,
                child: VideoPlayer(_pendingVideoController!),
              )
                  : const CircularProgressIndicator())
                  : Image.file(_pendingMedia!, height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Accept',
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: _acceptMedia,
                  ),
                  IconButton(
                    tooltip: 'Discard',
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: _discardMedia,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
