import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_contact.dart';
import 'delete_contact.dart';
import 'models/contact.dart';

void main() {
  runApp(const PhoneBookApp());
}

class PhoneBookApp extends StatelessWidget {
  const PhoneBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhoneBook',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add': (context) => const AddContactScreen(),
        '/delete': (context) => const DeleteContactScreen(),
      },
    );
  }
}