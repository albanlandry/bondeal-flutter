import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({super.key, required this.width, required this.height, this.borderRadius = 4});

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Color.lerp(const Color(0xFFE0E0E0), const Color(0xFFF0F0F0), _controller.value),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

class ListSkeletonItem extends StatelessWidget {
  const ListSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          const SkeletonBox(width: 120, height: 120, borderRadius: 8),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: double.infinity, height: 16),
                SizedBox(height: 8),
                SkeletonBox(width: 140, height: 12),
                SizedBox(height: 8),
                SkeletonBox(width: 100, height: 16),
                SizedBox(height: 8),
                SkeletonBox(width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
