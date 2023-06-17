class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;
  Language({
    required this.id,
    required this.flag,
    required this.name,
    required this.languageCode,
  });
  static List<Language> languageList() {
    return <Language>[
      Language(id: 1, flag: "🇰🇿", name: "Қазақша", languageCode: "kk"),
      Language(id: 2, flag: "🇺🇸", name: "English", languageCode: "en"),
      Language(id: 3, flag: "🇷🇺", name: "Русский", languageCode: "ru")
    ];
  }
}
