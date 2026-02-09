String mapError(Object e) {
  final msg = e.toString();

  if (msg.contains('SocketException')) {
    return 'No internet connection.';
  }

  if (msg.contains('connectTimeout')) {
    return 'Unable to connect to server.';
  }

  if (msg.contains('receiveTimeout')) {
    return 'Server took too long to respond.';
  }

  return 'Something went wrong. Please try again.';
}
