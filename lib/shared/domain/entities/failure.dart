class Failure<T> {

  final String? message;
  final T? data;

  const Failure({
    this.message, 
    this.data,
  });
}