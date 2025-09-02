import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'models/contact.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final DBHelper dbHelper = DBHelper();

  Future<void> _saveContact() async {
    if (_nameController.text.isEmpty || _numberController.text.isEmpty) return;

    final newContact = Contact(
      name: _nameController.text,
      number: _numberController.text,
    );

    await dbHelper.insertContact(newContact);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contact')),
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
              onPressed: _saveContact,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}