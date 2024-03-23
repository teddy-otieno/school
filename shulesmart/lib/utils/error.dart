
sealed class ShuleSmartError {
  String error;
  StackTrace? trace;

  ShuleSmartError({required this.error, this.trace});
}

class ServerError extends ShuleSmartError {
  ServerError({required super.error});
}

class NetworkError extends ShuleSmartError { 
  NetworkError(): super(error: "Network Error");
}
