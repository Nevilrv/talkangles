
class ApiException implements Exception {
  final _prefix;
  final _message;

  ApiException([this._prefix, this._message]);

  @override
  String toString() {
    return "$_prefix: $_message";
  }
}

class ResponseException extends ApiException {
  ResponseException([message]) : super("Error in response", message);
}

class BadRequestException extends ApiException {
  BadRequestException([message]) : super("Invalid request", message);
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([message]) : super("Unauthorised", message);
}

class InvalidInputException extends ApiException {
  InvalidInputException([message]) : super("Invalid input", message);
}
