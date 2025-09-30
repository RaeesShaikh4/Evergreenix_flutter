class ApiExceptions implements Exception {
  final String message;
  ApiExceptions(this.message);

  @override
  String toString() {
    return message;
  }
}

class BadRequestException extends ApiExceptions {
  BadRequestException(super.message);
}

class UnauthorizedException extends ApiExceptions {
  UnauthorizedException(super.message);
}

class FetchDataException extends ApiExceptions {
  FetchDataException(super.message);
}
