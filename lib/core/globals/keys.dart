import 'package:flutter/material.dart';

/// Global key for accessing the root ScaffoldMessenger state
/// Used for showing SnackBars from anywhere in the app (e.g. Dio interceptors)
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
