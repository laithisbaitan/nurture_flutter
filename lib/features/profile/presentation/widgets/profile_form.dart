import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_user.dart';
import '../controllers/profile_controller.dart';
import 'profile_fields.dart';
import 'profile_form_fields.dart';

/// Editable profile form, seeded once from the signed-in user.
class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({super.key, required this.user});

  final AuthUser user;

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _goalController;
  late String? _sex;
  late String? _activityLevel;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _nameController = TextEditingController(text: user.name);
    _ageController = TextEditingController(text: '${user.age ?? ''}');
    _heightController = TextEditingController(text: '${user.heightCm ?? ''}');
    _weightController = TextEditingController(text: '${user.weightKg ?? ''}');
    _goalController = TextEditingController(text: user.goal ?? '');
    _sex = user.sex;
    _activityLevel = user.activityLevel;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final goal = _goalController.text.trim();
    final ok = await ref
        .read(profileControllerProvider.notifier)
        .save(
          name: _nameController.text.trim(),
          age: parseOptionalInt(_ageController.text),
          sex: _sex,
          heightCm: parseOptionalDouble(_heightController.text),
          weightKg: parseOptionalDouble(_weightController.text),
          activityLevel: _activityLevel,
          goal: goal.isEmpty ? null : goal,
        );
    if (ok && mounted) showSnack(context, 'Profile saved');
  }

  @override
  Widget build(BuildContext context) {
    listenForProfileErrors(context, ref);
    final isSaving = ref.watch(profileControllerProvider).isLoading;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileFormFields(
              email: widget.user.email,
              nameController: _nameController,
              ageController: _ageController,
              heightController: _heightController,
              weightController: _weightController,
              goalController: _goalController,
              sex: _sex,
              activityLevel: _activityLevel,
              onSexChanged: (value) => _sex = value,
              onActivityChanged: (value) => _activityLevel = value,
            ),
            FilledButton(
              onPressed: isSaving ? null : _save,
              child: isSaving
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
