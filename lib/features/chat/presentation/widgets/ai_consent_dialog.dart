import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';

void showAiConsentDialog(BuildContext context) {
  const Color primaryGreen = Color(0xFF00BF83);
  const Color darkGreen = Color(0xFF008D68);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(LucideIcons.bot, color: darkGreen, size: 24),
          const SizedBox(width: 8),
          Text(
            'Persetujuan Aura Skin AI',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        'Dengan menyetujui, kamu mengizinkan SkinCek membagikan isi pesan teks chat-mu ke penyedia kecerdasan buatan (Google Gemini) agar Aura Skin dapat menjawab pertanyaanmu.',
        style: GoogleFonts.roboto(fontSize: 13, height: 1.45),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            context.pop();
          },
          child: Text('Batal', style: GoogleFonts.roboto(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            context.read<ChatBloc>().add(AcceptAiConsentEvent());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text('Setujui', style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}
