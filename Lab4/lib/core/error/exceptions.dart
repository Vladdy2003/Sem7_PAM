// Exceptiile aruncate de stratul Data (data source).
// Repository-ul le prinde si le transforma in Failure-uri pentru Domain.

// Serverul a raspuns, dar cu un cod HTTP diferit de 200.
class ServerException implements Exception {
  final int statusCode;
  final String message;
  const ServerException(this.statusCode, this.message);

  @override
  String toString() => 'ServerException($statusCode): $message';
}

// Nu s-a putut ajunge la server (fara internet, timeout, CORS etc.).
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

// Raspunsul a venit, dar JSON-ul nu are formatul asteptat.
class ParsingException implements Exception {
  final String message;
  const ParsingException(this.message);

  @override
  String toString() => 'ParsingException: $message';
}
