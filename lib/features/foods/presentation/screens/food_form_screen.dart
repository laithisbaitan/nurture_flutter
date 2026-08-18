import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_item.dart';
import '../../domain/foods_repository.dart';
import '../controllers/food_form_controller.dart';
import '../widgets/food_form_controllers.dart';
import '../widgets/food_form_fields.dart';
import '../widgets/food_search_tile.dart';

/// Manual create, or step 2 of the photo flow (PATCH nutrition + source=manual).
class FoodFormScreen extends ConsumerStatefulWidget {
  const FoodFormScreen({super.key, this.existing});

  final FoodItem? existing;

  @override
  ConsumerState<FoodFormScreen> createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends ConsumerState<FoodFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final FoodFormControllers _fields;

  bool get _isPhotoComplete => widget.existing?.isPhotoPending ?? false;

  @override
  void initState() {
    super.initState();
    _fields = FoodFormControllers(widget.existing);
  }

  @override
  void dispose() {
    _fields.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final draft = FoodWrite(
      nameEn: _fields.nameEn.text.trim(),
      nameAr: _fields.nameAr.text.trim(),
      servingSize: parseNumber(_fields.servingSize.text),
      servingUnit: _fields.servingUnit.text.trim(),
      calories: parseNumber(_fields.calories.text),
      proteinG: parseNumber(_fields.protein.text),
      carbsG: parseNumber(_fields.carbs.text),
      fatG: parseNumber(_fields.fat.text),
      source: _isPhotoComplete ? FoodSource.manual : null,
    );
    final saved = await ref
        .read(foodFormControllerProvider.notifier)
        .save(draft, id: widget.existing?.id);
    if (!mounted || saved == null) return;
    showFoodSnack(context, 'Food saved');
    Navigator.of(context).pop(saved);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(foodFormControllerProvider, (previous, next) {
      final error = next.asError?.error;
      if (error != null) showFoodSnack(context, error.toString());
    });
    final isSaving = ref.watch(foodFormControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isPhotoComplete ? 'Complete nutrition' : 'New food'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FoodFormFields(
                nameEn: _fields.nameEn,
                nameAr: _fields.nameAr,
                servingSize: _fields.servingSize,
                servingUnit: _fields.servingUnit,
                calories: _fields.calories,
                protein: _fields.protein,
                carbs: _fields.carbs,
                fat: _fields.fat,
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
      ),
    );
  }
}
