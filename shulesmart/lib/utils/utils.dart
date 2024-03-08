// ignore_for_file: non_constant_identifier_names

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

  bool is_okay() {
    return value != null;
  }

  T unwrap() {
    if (value != null) {
      return value!;
    }

    throw Error();
  }
}
