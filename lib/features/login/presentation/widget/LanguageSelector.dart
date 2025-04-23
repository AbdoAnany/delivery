

import 'package:delivery/features/login/presentation/widget/CustomTextField.dart';
import 'package:flutter/material.dart';

import '../../../../core/AppColor.dart';


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
      title:  Text('Choose Language',

        style: TextStyle(
          fontSize: 12,
          color: AppColors.primaryDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.fillColor2,
      content: SizedBox(
        height: 44,
        width:MediaQuery.of(context).size.width,

        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Expanded(
              child: _buildLanguageOption(
                languageCode: 'ar',
                image: AppImages.arabic,
                displayName: 'العربية',
                englishName: 'Arabic',
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: _buildLanguageOption(
                languageCode: 'en',
                image: AppImages.english,

                displayName: 'English',
                englishName: 'English',
              ),
            ),
          ],
        ),
      ),
      actions: [

        SizedBox(
          width: double.infinity,

          child: CustomButton(
            onPressed: () {
              widget.onLanguageSelected(_selectedLanguage);
              Navigator.pop(context);
            },
            radius: 12,
            text: 'Apply',

          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String image,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          color: _selectedLanguage == languageCode
              ? Color(0xFFCBFFCBF)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedLanguage == languageCode
                ? Color(0xFFC39A238)
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: _selectedLanguage == languageCode
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  englishName,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}