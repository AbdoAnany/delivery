

import 'package:flutter/material.dart';


class LanguageSelector extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageSelected;

  const LanguageSelector({
    super.key,
    required this.currentLanguage,
    required this.onLanguageSelected,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption(
            languageCode: 'ar',
            displayName: 'العربية',
            englishName: 'Arabic',
          ),
          const SizedBox(height: 16),
          _buildLanguageOption(
            languageCode: 'en',
            displayName: 'English',
            englishName: 'English',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onLanguageSelected(_selectedLanguage);
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String displayName,
    required String englishName,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = languageCode;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _selectedLanguage == languageCode
              ? Colors.blue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedLanguage == languageCode
                ? Colors.blue
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Text(
              displayName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: _selectedLanguage == languageCode
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              englishName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            if (_selectedLanguage == languageCode)
              const Icon(Icons.check, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}