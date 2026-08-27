import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/chat_message.dart';
import 'scan_document_card.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isUserSender;
    String formattedTime = '';
    try {
      formattedTime = DateFormat('HH:mm').format(message.createdAt);
    } catch (_) {}

    final isScanDoc = message.content.contains('📋 Kondisi:') ||
        message.content.contains('Kondisi Terdeteksi:') ||
        message.content.contains('[DOKUMEN_HASIL_SCAN]');

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFE6F8F2) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: Border.all(
            color: isMe
                ? const Color(0xFF00BF83).withValues(alpha: 0.25)
                : const Color(0xFFE2E8F0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              Text(
                message.senderName,
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF008D68),
                ),
              ),
              const SizedBox(height: 4),
            ],
            if (message.mediaUrl != null && message.mediaUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: message.mediaUrl!.startsWith('http')
                    ? Image.network(
                        message.mediaUrl!,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(message.mediaUrl!),
                        fit: BoxFit.cover,
                      ),
              ),
              if (message.content.isNotEmpty) const SizedBox(height: 6),
            ],
            if (message.content.isNotEmpty)
              isScanDoc
                  ? ScanDocumentCard(content: message.content)
                  : Text(
                      message.content,
                      style: GoogleFonts.roboto(
                        fontSize: 13.5,
                        height: 1.4,
                        color: const Color(0xFF101828),
                      ),
                    ),
            const SizedBox(height: 4),
            Text(
              formattedTime,
              style: GoogleFonts.roboto(
                fontSize: 10,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
