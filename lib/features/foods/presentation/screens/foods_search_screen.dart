import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/food_form_controller.dart';
import '../controllers/foods_search_controller.dart';
import '../widgets/food_search_results.dart';
import '../widgets/food_search_tile.dart';
import '../../domain/entities/food_item.dart';
import 'food_form_screen.dart';

class FoodsSearchScreen extends ConsumerStatefulWidget {
  const FoodsSearchScreen({super.key, this.onPicked});

  /// When set, tapping a food returns it instead of opening detail.
  final ValueChanged<FoodItem>? onPicked;

  @override
  ConsumerState<FoodsSearchScreen> createState() => _FoodsSearchScreenState();
}

class _FoodsSearchScreenState extends ConsumerState<FoodsSearchScreen> {
  final _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _search() {
    ref
        .read(foodsSearchControllerProvider.notifier)
        .search(_queryController.text);
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null || !mounted) return;
    final item = await ref
        .read(foodFormControllerProvider.notifier)
        .uploadPhoto(picked.path);
    if (!mounted || item == null) return;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => FoodFormScreen(existing: item)));
    if (mounted) _search();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(foodsSearchControllerProvider, (previous, next) {
      final error = next.asError?.error;
      if (error != null) showFoodSnack(context, error.toString());
    });
    ref.listen(foodFormControllerProvider, (previous, next) {
      final error = next.asError?.error;
      if (error != null) showFoodSnack(context, error.toString());
    });
    final results = ref.watch(foodsSearchControllerProvider);
    final uploading = ref.watch(foodFormControllerProvider).isLoading;

    final picking = widget.onPicked != null;
    return Scaffold(
      appBar: AppBar(title: Text(picking ? 'Pick a food' : 'Foods')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _queryController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                labelText: 'Search English or Arabic',
                suffixIcon: IconButton(
                  tooltip: 'Search',
                  onPressed: _search,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          if (!picking)
            FoodEntryButtons(
              onManual: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FoodFormScreen()),
                );
                if (mounted) _search();
              },
              onPhoto: _pickPhoto,
              photoBusy: uploading,
            ),
          const SizedBox(height: 8),
          Expanded(
            child: FoodSearchResults(
              results: results,
              onPicked: widget.onPicked,
            ),
          ),
        ],
      ),
    );
  }
}
