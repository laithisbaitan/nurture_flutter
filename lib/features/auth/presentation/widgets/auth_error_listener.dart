import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';

/// Shows auth failures as a SnackBar without cluttering the screens.
void listenForAuthErrors(BuildContext context, WidgetRef ref) {
  ref.listen(authControllerProvider, (previous, next) {
    final error = next.asError?.error;
    if (error == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(error.toString())));
  });
}
