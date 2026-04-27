class ApiConstants {
  static const String baseUrl = "http://127.0.0.1:8080";

  static const String login = "$baseUrl/auth/login";
  static const String me = "$baseUrl/auth/me";

  static const String readings = "$baseUrl/readings";
  static const String generateReading = "$baseUrl/readings/generate";
}
