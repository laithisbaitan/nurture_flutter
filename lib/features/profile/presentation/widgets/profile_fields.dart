import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/profile_controller.dart';

const sexOptions = ['male', 'female'];

const activityLevelOptions = [
  'sedentary',
  'light',
  'moderate',
  'active',
  'very_active',
];

const sexLabels = {'male': 'Male', 'female': 'Female'};

const activityLevelLabels = {
  'sedentary': 'Sedentary',
  'light': 'Light',
  'moderate': 'Moderate',
  'active': 'Active',
  'very_active': 'Very active',
};

class ProfileDropdown extends StatelessWidget {
  const ProfileDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.labels,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> options;
  final Map<String, String> labels;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String?>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: [
          const DropdownMenuItem(value: null, child: Text('Not set')),
          ...options.map(
            (option) => DropdownMenuItem(
              value: option,
              child: Text(labels[option] ?? option),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

String? validateOptionalInt(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return null;
  final parsed = int.tryParse(text);
  if (parsed == null || parsed <= 0) return 'Enter a whole number';
  return null;
}

String? validateOptionalPositive(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return null;
  final parsed = num.tryParse(text);
  if (parsed == null || parsed <= 0) return 'Enter a positive number';
  return null;
}

int? parseOptionalInt(String value) {
  final text = value.trim();
  if (text.isEmpty) return null;
  return int.tryParse(text);
}

double? parseOptionalDouble(String value) {
  final text = value.trim();
  if (text.isEmpty) return null;
  return double.tryParse(text);
}

void listenForProfileErrors(BuildContext context, WidgetRef ref) {
  ref.listen(profileControllerProvider, (previous, next) {
    final error = next.asError?.error;
    if (error == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(error.toString())));
  });
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
