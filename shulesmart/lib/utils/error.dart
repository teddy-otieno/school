
sealed class ShuleSmartError {}

class ServerError extends ShuleSmartError {
  String error;

  ServerError({required this.error});
}

class NetworkError extends ShuleSmartError { }
