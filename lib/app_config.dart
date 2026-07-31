class AppConfig {
  int version;
  String codeName;
  Uri updateUri = Uri.parse(
    'https://api.github.com/repos/hendrilmendes/Orbit-Music/releases/latest',
  );
  AppConfig({required this.version, required this.codeName});
}
