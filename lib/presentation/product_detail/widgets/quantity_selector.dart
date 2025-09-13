import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final int maxQuantity;
  final ValueChanged<int> onQuantityChanged;

  const QuantitySelector({
    super.key,
    this.initialQuantity = 1,
    this.maxQuantity = 99,
    required this.onQuantityChanged,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _textController = TextEditingController(text: _quantity.toString());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity >= 1 && newQuantity <= widget.maxQuantity) {
      setState(() {
        _quantity = newQuantity;
        _textController.text = _quantity.toString();
      });
      widget.onQuantityChanged(_quantity);

      // Haptic feedback for quantity changes
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          GestureDetector(
            onTap: _quantity > 1 ? () => _updateQuantity(_quantity - 1) : null,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: _quantity > 1
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'remove',
                  size: 20,
                  color: _quantity > 1
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),

          // Quantity input
          Container(
            width: 16.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.symmetric(
                vertical: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: TextField(
              controller: _textController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final newQuantity = int.tryParse(value);
                  if (newQuantity != null) {
                    _updateQuantity(newQuantity);
                  }
                }
              },
              onSubmitted: (value) {
                if (value.isEmpty) {
                  _updateQuantity(1);
                } else {
                  final newQuantity = int.tryParse(value);
                  if (newQuantity == null || newQuantity < 1) {
                    _updateQuantity(1);
                  } else if (newQuantity > widget.maxQuantity) {
                    _updateQuantity(widget.maxQuantity);
                  }
                }
              },
            ),
          ),

          // Increase button
          GestureDetector(
            onTap: _quantity < widget.maxQuantity
                ? () => _updateQuantity(_quantity + 1)
                : null,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: _quantity < widget.maxQuantity
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'add',
                  size: 20,
                  color: _quantity < widget.maxQuantity
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
