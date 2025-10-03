import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'default_button.dart';
import 'alternative_button.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final bool showSecondaryButton;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const CustomAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.showSecondaryButton = true,
    required this.primaryButtonText,
    this.secondaryButtonText,
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.mainWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.mainBlue, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.mainBlue,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            if (message != null) ...[
              const SizedBox(height: 30),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.mainBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.mainBlue,
                ),
              ),
            ],

            const SizedBox(height: 30),

            if (showSecondaryButton && secondaryButtonText != null) ...[
              SizedBox(
                width: double.infinity,
                child: AlternativeButton(
                  text: secondaryButtonText!,
                  onPressed: onSecondaryPressed,
                  height: 48,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: DefaultButton(
                  text: primaryButtonText,
                  onPressed: onPrimaryPressed,
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: DefaultButton(
                  text: primaryButtonText,
                  onPressed: onPrimaryPressed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> showCustomDialog(
  BuildContext context, {
  required String title,
  String? message,
  bool showSecondaryButton = true,
  required String primaryButtonText,
  String? secondaryButtonText,
  required VoidCallback onPrimaryPressed,
  VoidCallback? onSecondaryPressed,
  VoidCallback? onMessagePressed,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        title: title,
        message: message,
        showSecondaryButton: showSecondaryButton,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
      );
    },
  );
}

void showSuccessSnackBar(
  BuildContext context, {
  required String action,
  required String resource,
  required String gender,
  String? resourceName,
}) {
  final message = resourceName != null
      ? 'Se $action $gender $resource "$resourceName" correctamente'
      : 'Se $action $gender $resource correctamente';

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.green[800],
      duration: const Duration(seconds: 3),
    ),
  );
}
