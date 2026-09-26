import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class OrderStatusWidget extends StatelessWidget {
  final String currentStatus;

  const OrderStatusWidget({super.key, required this.currentStatus});

  static const List<String> steps = [
    'pending',
    'accepted',
    'preparing',
    'delivering',
    'completed',
  ];

  static const Map<String, String> labels = {
    'pending': 'Order Placed',
    'accepted': 'Accepted',
    'preparing': 'Preparing',
    'delivering': 'On the way',
    'completed': 'Completed',
  };

  int get _currentIndex {
    final idx = steps.indexOf(currentStatus);
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final active = i <= _currentIndex;
        final last = i == steps.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? AppColors.primary : AppColors.divider,
                  ),
                  child: Icon(
                    active ? Icons.check : Icons.circle_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                if (!last)
                  Container(
                    width: 3,
                    height: 40,
                    color: i < _currentIndex
                        ? AppColors.primary
                        : AppColors.divider,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                labels[steps[i]] ?? steps[i],
                style: TextStyle(
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  color: active ? AppColors.textDark : AppColors.textLight,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
