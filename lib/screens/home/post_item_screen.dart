import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';

class PostItemScreen extends StatefulWidget {
  const PostItemScreen({super.key});

  @override
  State<PostItemScreen> createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(text: '350000');
  final TextEditingController _tagInputController = TextEditingController();

  int _listingTypeIndex = 0; // 0=Vendre, 1=Partager, 2=Echanger
  String? _selectedCategory;
  String? _selectedCondition;
  final List<String> _selectedTags = [];
  final List<String> _uploadedImages = [
    'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=200&h=200&fit=crop&crop=center',
    'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=200&h=200&fit=crop&crop=center',
  ];

  final List<String> _listingTypes = ['Vendre', 'Partager', 'Echanger'];

  final List<String> _categories = [
    'Electronique',
    'Vetements',
    'Maison & Jardin',
    'Vehicules',
    'Immobilier',
    'Sports & Loisirs',
    'Livres & Medias',
    'Autres',
  ];

  final List<String> _conditions = [
    'Neuf',
    'Tres bon etat',
    'Bon etat',
    'Etat correct',
    'A reparer',
  ];

  final List<String> _popularTags = [
    'Urgent',
    'Bon prix',
    'Negociable',
    'Livraison',
    'Echange possible',
    'Comme neuf',
    'Rare',
    'Collection',
    'Vintage',
    'Moderne',
  ];

  List<String> get _tagSuggestions {
    final input = _tagInputController.text.toLowerCase();
    if (input.isEmpty) return [];
    return _popularTags
        .where((tag) =>
            tag.toLowerCase().contains(input) && !_selectedTags.contains(tag))
        .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Categorie',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const Divider(height: 1),
              ..._categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ListTile(
                  title: Text(
                    cat,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : const Color(0xFF333333),
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedCategory = cat);
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  void _showConditionPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Etat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const Divider(height: 1),
              ..._conditions.map((cond) {
                final isSelected = _selectedCondition == cond;
                return ListTile(
                  title: Text(
                    cond,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : const Color(0xFF333333),
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedCondition = cond);
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  void _addTag(String tag) {
    if (_selectedTags.length >= 5) return;
    if (_selectedTags.contains(tag)) return;
    setState(() {
      _selectedTags.add(tag);
      _tagInputController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() => _selectedTags.remove(tag));
  }

  void _removeImage(int index) {
    setState(() => _uploadedImages.removeAt(index));
  }

  bool _validate() {
    if (_titleController.text.trim().isEmpty) {
      _showError('Le titre est obligatoire');
      return false;
    }
    if (_selectedCategory == null) {
      _showError('Veuillez choisir une categorie');
      return false;
    }
    if (_selectedCondition == null) {
      _showError("Veuillez choisir l'etat de l'article");
      return false;
    }
    if (_priceController.text.trim().isEmpty && _listingTypeIndex == 0) {
      _showError('Le prix est obligatoire pour une vente');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _publish() {
    if (!_validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Annonce publiee avec succes !'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back, size: 24, color: Color(0xFF333333)),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Brouillon enregistre'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                    child: const Text(
                      'Enregistrer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),

                  // Title input
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Titre',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFBBBBBB),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Description input
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFBBBBBB),
                        height: 1.5,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Listing type selector
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.grayLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: List.generate(_listingTypes.length, (index) {
                        final isActive = _listingTypeIndex == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _listingTypeIndex = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  _listingTypes[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isActive ? AppColors.white : AppColors.gray,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Image upload grid
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      ..._uploadedImages.asMap().entries.map((entry) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                entry.value,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(entry.key),
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      // Add button
                      GestureDetector(
                        onTap: () {
                          // Placeholder for image picker
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.gray,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt_outlined, size: 24, color: AppColors.gray),
                              const SizedBox(height: 2),
                              Text(
                                '${_uploadedImages.length}/10',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.gray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Category picker
                  _FieldPicker(
                    label: 'Categorie *',
                    value: _selectedCategory,
                    placeholder: 'Choisir une categorie',
                    onTap: _showCategoryPicker,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Condition picker
                  _FieldPicker(
                    label: 'Etat *',
                    value: _selectedCondition,
                    placeholder: "Choisir l'etat",
                    onTap: _showConditionPicker,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Tags section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tags',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        'Maximum 5 tags (${_selectedTags.length}/5)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Selected tags
                  if (_selectedTags.isNotEmpty)
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: _selectedTags.map((tag) {
                        return Chip(
                          label: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                            ),
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          deleteIconColor: AppColors.primary,
                          onDeleted: () => _removeTag(tag),
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: AppColors.primary, width: 0.5),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: AppSpacing.sm),

                  // Tag input
                  if (_selectedTags.length < 5)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _tagInputController,
                          onChanged: (_) => setState(() {}),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              _addTag(value.trim());
                            }
                          },
                          style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                          decoration: InputDecoration(
                            hintText: 'Ajouter un tag...',
                            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFBBBBBB)),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: AppColors.grayLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: AppColors.grayLight),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: AppColors.primary),
                            ),
                            suffixIcon: _tagInputController.text.trim().isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      if (_tagInputController.text.trim().isNotEmpty) {
                                        _addTag(_tagInputController.text.trim());
                                      }
                                    },
                                    child: const Icon(Icons.add_circle, color: AppColors.primary),
                                  )
                                : null,
                          ),
                        ),
                        // Tag suggestions
                        if (_tagSuggestions.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: AppSpacing.xs),
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.grayLight),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _tagSuggestions.map((tag) {
                                return GestureDetector(
                                  onTap: () => _addTag(tag),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.md),

                  // Popular tags
                  const Text(
                    'Tags populaires',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _popularTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            _removeTag(tag);
                          } else {
                            _addTag(tag);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.grayLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? AppColors.primary : AppColors.gray,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),

          // Bottom bar
          Container(
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.sm,
              bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Price input
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grayLight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Prix',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFBBBBBB),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const Text(
                          'FCFA',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Publish button
                ElevatedButton(
                  onPressed: _publish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Publier',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldPicker extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  const _FieldPicker({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grayLight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? placeholder,
                  style: TextStyle(
                    fontSize: 14,
                    color: value != null ? const Color(0xFF333333) : const Color(0xFFBBBBBB),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.gray),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
