// Configurarea serviciului Web (REST API).
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://test-api-jlbn.onrender.com/lab2026/v2';

  // GET -> datele ecranului principal
  static const String feedPath = '/feed';

  // GET -> detaliile programarii
  static const String feedDetailsPath = '/feed/details';

  // Serverul de pe Render "adoarme" si porneste greu la primul request
  static const Duration timeout = Duration(seconds: 60);
}
