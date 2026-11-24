import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WayGoLoading extends StatelessWidget {
  final String message;
  final double size;

  const WayGoLoading({
    super.key,
    this.message = "Please wait...",
    this.size = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.directions_bus_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: size,
            width: size,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.secondary,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class WayGoLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String message;

  const WayGoLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message = "Please wait...",
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        if (isLoading) ...[
          const ModalBarrier(
            dismissible: false,
            color: Colors.black54,
          ),

          WayGoLoading(message: message),
        ],
      ],
    );
  }
}