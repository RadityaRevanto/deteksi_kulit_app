import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppStatusDialogType { success, error, info }

class AppStatusDialog extends StatelessWidget {
  final String title;
  final String message;
  final AppStatusDialogType type;
  final String buttonText;
  final VoidCallback? onPressed;

  const AppStatusDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = AppStatusDialogType.info,
    this.buttonText = 'Tutup',
    this.onPressed,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    AppStatusDialogType type = AppStatusDialogType.info,
    String? buttonText,
    VoidCallback? onPressed,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => AppStatusDialog(
        title: title,
        message: message,
        type: type,
        buttonText: buttonText ?? (type == AppStatusDialogType.success ? 'Lanjutkan' : 'Tutup'),
        onPressed: onPressed ?? () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: const Color(0xFF171A19),
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: GoogleFonts.roboto(
          fontSize: 14,
          color: const Color(0xFF5A6360),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: type == AppStatusDialogType.error
                ? Colors.red
                : const Color(0xFF00BF83),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Text(
            buttonText,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
