import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'models/contact.dart';

class DeleteContactScreen extends StatefulWidget {
  const DeleteContactScreen({super.key});

  @override
  State<DeleteContactScreen> createState() => _DeleteContactScreenState();
}

class _DeleteContactScreenState extends State<DeleteContactScreen> {
  final DBHelper dbHelper = DBHelper();
  late Contact contact;

  final _nameController = TextEditingController();
  final _numberController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contact = ModalRoute.of(context)!.settings.arguments as Contact;
    _nameController.text = contact.name;
    _numberController.text = contact.number;
  }

  Future<void> _updateContact() async {
    final updated = Contact(
      id: contact.id,
      name: _nameController.text,
      number: _numberController.text,
    );
    await dbHelper.updateContact(updated);
    Navigator.pop(context, true);
  }

  Future<void> _deleteContact() async {
    await dbHelper.deleteContact(contact.id!);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteContact,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(labelText: 'Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateContact,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}