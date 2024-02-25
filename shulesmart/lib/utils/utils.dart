class Result<T, E> {
  T? value;
  E? error;

  Result({this.error, this.value});

  factory Result.ok(T value) {
    return Result(value: value);
  }

  factory Result.err(E error) {
    return Result(error: error);
  }
}
