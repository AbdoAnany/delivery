

import 'package:delivery/features/login/presentation/widget/CustomTextField.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/image.dart';


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
      // In the AlertDialog
      title: Text(
        'Choose Language'.tr(),
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.primaryDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      titlePadding: EdgeInsetsDirectional.only(top: 30.h,
          bottom: 20.h,
          start: 20.w),
      contentPadding:  EdgeInsets.symmetric(
        horizontal: 17.w,
      ),
      actionsPadding: EdgeInsets.symmetric(vertical: 20.h,
          horizontal: 17.w,
          ),
      backgroundColor: AppColors.fillColor2,
      content: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          height: 44.h,
          width: MediaQuery.of(context).size.width,

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
      ),
      actions: [

        SizedBox(
          width: double.infinity,

          child: CustomButton(
            onPressed: () {
              widget.onLanguageSelected(_selectedLanguage);
              Navigator.pop(context);
            },
            radius: 12.sp,
            text: 'Apply'.tr(),

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
        padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
        decoration: BoxDecoration(
          color: _selectedLanguage == languageCode
              ? Color(0xFFCBFFCBF)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedLanguage == languageCode
                ? Color(0xFFC39A238)
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              image,
              width: 20,
              height: 20,
            ),
            // const SizedBox(width: 20),
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