import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'manger/AuthProvider.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _selectedLanguage = authProvider.languageNo;
    });
  }

  Future<void> _changeLanguage(String languageNo) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.changeLanguage(languageNo);
    setState(() {
      _selectedLanguage = languageNo;
    });
    
    // Navigate to home screen after language selection
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose your preferred language',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            _languageOption(
              code: '1',
              name: 'English',
              flag: '🇬🇧',
            ),
            const SizedBox(height: 20),
            _languageOption(
              code: '2',
              name: 'العربية',
              flag: '🇸🇦',
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageOption({
    required String code,
    required String name,
    required String flag,
  }) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      trailing: _selectedLanguage == code
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: () => _changeLanguage(code),
    );
  }
}