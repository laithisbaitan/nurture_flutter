import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../../foods/domain/entities/food_item.dart';
import '../../../foods/presentation/widgets/food_search_tile.dart';
import '../controllers/diary_controller.dart';
import '../widgets/diary_widgets.dart';

class AddFoodLogScreen extends ConsumerStatefulWidget {
  const AddFoodLogScreen({super.key, required this.food});

  final FoodItem food;

  @override
  ConsumerState<AddFoodLogScreen> createState() => _AddFoodLogScreenState();
}

class _AddFoodLogScreenState extends ConsumerState<AddFoodLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');
  String? _mealType;
  var _saving = false;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(diaryControllerProvider.notifier)
          .addLog(
            foodItemId: widget.food.id,
            quantity: parseNumber(_quantityController.text),
            mealType: _mealType,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log food')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              widget.food.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _quantityController,
              label: 'Servings',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: validatePositiveNumber,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButtonFormField<String?>(
                initialValue: _mealType,
                decoration: const InputDecoration(labelText: 'Meal'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Not set')),
                  ...mealTypeOptions.map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(mealTypeLabels[value]!),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _mealType = value),
              ),
            ),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add to diary'),
            ),
          ],
        ),
      ),
    );
  }
}
