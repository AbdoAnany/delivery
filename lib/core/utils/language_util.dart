class LanguageUtil {
  static const String ARABIC = "1";
  static const String ENGLISH = "2";

  static String getCurrentLanguage() {
    // This could be fetched from shared preferences or device locale
    // For now, returning English as default
    return ENGLISH;
  }
}
