import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ScanDocumentCard extends StatelessWidget {
  final String content;

  const ScanDocumentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    String condition = 'Kondisi Kulit';
    String accuracy = '87%';
    String dateStr = '';
    String userNote = '';

    final lines = content.split('\n');
    for (final line in lines) {
      if (line.contains('Kondisi:')) {
        condition = line.replaceAll('📋 Kondisi:', '').replaceAll('Kondisi:', '').trim();
      } else if (line.contains('Akurasi:') || line.contains('Tingkat Kepercayaan:')) {
        accuracy = line.replaceAll('🎯 Akurasi:', '').replaceAll('Tingkat Kepercayaan:', '').replaceAll('🎯', '').trim();
      } else if (line.contains('Tanggal:')) {
        dateStr = line.replaceAll('📅 Tanggal:', '').replaceAll('Tanggal:', '').replaceAll('📅', '').trim();
      } else if (!line.startsWith('[') && !line.startsWith('Halo') && !line.contains(':')) {
        if (line.trim().isNotEmpty) {
          userNote += '${line.trim()} ';
        }
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00BF83).withValues(alpha: 0.4), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF008D68),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.fileCheck2, color: Colors.white, size: 15),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'DOKUMEN HASIL SCAN KULIT',
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Verified',
                    style: GoogleFonts.roboto(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kondisi Terdeteksi:',
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            condition,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF101828),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F8F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF00BF83).withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Akurasi $accuracy',
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF008D68),
                        ),
                      ),
                    ),
                  ],
                ),
                if (dateStr.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 12, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        'Tanggal Scan: $dateStr',
                        style: GoogleFonts.roboto(fontSize: 10, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
                if (userNote.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 6),
                  Text(
                    userNote.trim(),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
