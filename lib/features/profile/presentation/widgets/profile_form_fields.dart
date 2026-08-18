import 'package:flutter/material.dart';

import '../../../auth/presentation/widgets/auth_text_field.dart';
import 'profile_fields.dart';

class ProfileFormFields extends StatelessWidget {
  const ProfileFormFields({
    super.key,
    required this.email,
    required this.nameController,
    required this.ageController,
    required this.heightController,
    required this.weightController,
    required this.goalController,
    required this.sex,
    required this.activityLevel,
    required this.onSexChanged,
    required this.onActivityChanged,
  });

  final String email;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController goalController;
  final String? sex;
  final String? activityLevel;
  final ValueChanged<String?> onSexChanged;
  final ValueChanged<String?> onActivityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(controller: nameController, label: 'Name'),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            initialValue: email,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
        ),
        AuthTextField(
          controller: ageController,
          label: 'Age',
          keyboardType: TextInputType.number,
          validator: validateOptionalInt,
        ),
        ProfileDropdown(
          label: 'Sex',
          value: sex,
          options: sexOptions,
          labels: sexLabels,
          onChanged: onSexChanged,
        ),
        AuthTextField(
          controller: heightController,
          label: 'Height (cm)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validateOptionalPositive,
        ),
        AuthTextField(
          controller: weightController,
          label: 'Weight (kg)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validateOptionalPositive,
        ),
        ProfileDropdown(
          label: 'Activity level',
          value: activityLevel,
          options: activityLevelOptions,
          labels: activityLevelLabels,
          onChanged: onActivityChanged,
        ),
        AuthTextField(
          controller: goalController,
          label: 'Goal',
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
