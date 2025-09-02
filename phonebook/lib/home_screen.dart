import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'models/contact.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper dbHelper = DBHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final data = await dbHelper.getContacts();
    setState(() => contacts = data);
  }

  Future<void> _navigateToAdd() async {
    final added = await Navigator.pushNamed(context, '/add');
    if (added == true) _loadContacts();
  }

  Future<void> _navigateToDelete(Contact contact) async {
    final updated = await Navigator.pushNamed(
      context,
      '/delete',
      arguments: contact,
    );
    if (updated == true) _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PhoneBook')),
      body: contacts.isEmpty
          ? const Center(child: Text('No contacts found.'))
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final c = contacts[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(c.name),
            subtitle: Text(c.number),
            onTap: () => _navigateToDelete(c),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}