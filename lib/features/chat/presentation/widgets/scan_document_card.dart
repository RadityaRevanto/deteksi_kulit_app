import 'dart:io';
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
    String otherProbsStr = '';
    String imageUrl = '';
    String userNote = '';

    final lines = content.split('\n');
    for (final line in lines) {
      if (line.contains('Kondisi:')) {
        condition = line.replaceAll('📋 Kondisi:', '').replaceAll('Kondisi:', '').trim();
      } else if (line.contains('Akurasi:') || line.contains('Tingkat Kepercayaan:')) {
        accuracy = line.replaceAll('🎯 Akurasi:', '').replaceAll('Tingkat Kepercayaan:', '').replaceAll('🎯', '').trim();
      } else if (line.contains('Probabilitas Lain:')) {
        otherProbsStr = line.replaceAll('📊 Probabilitas Lain:', '').replaceAll('Probabilitas Lain:', '').trim();
      } else if (line.contains('Tanggal:')) {
        dateStr = line.replaceAll('📅 Tanggal:', '').replaceAll('Tanggal:', '').replaceAll('📅', '').trim();
      } else if (line.contains('Foto:')) {
        imageUrl = line.replaceAll('🖼️ Foto:', '').replaceAll('Foto:', '').trim();
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
          // Header Card
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
                    'SkinCek Verified',
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
                // Scanned Image & Condition Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 54,
                          height: 54,
                          color: const Color(0xFFF1F5F9),
                          child: imageUrl.startsWith('http')
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(LucideIcons.image, size: 24, color: Color(0xFF94A3B8)),
                                )
                              : Image.file(
                                  File(imageUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(LucideIcons.image, size: 24, color: Color(0xFF94A3B8)),
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Kondisi Terdeteksi:',
                                  style: GoogleFonts.roboto(
                                    fontSize: 10,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F8F2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFF00BF83).withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  'Akurasi $accuracy',
                                  style: GoogleFonts.roboto(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF008D68),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            condition,
                            style: GoogleFonts.roboto(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF101828),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Probabilitas Lain Breakdown Section
                if (otherProbsStr.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.barChart2, size: 12, color: Color(0xFF008D68)),
                            const SizedBox(width: 4),
                            Text(
                              'Kemungkinan Kondisi Lain:',
                              style: GoogleFonts.roboto(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          otherProbsStr,
                          style: GoogleFonts.roboto(
                            fontSize: 11,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (dateStr.isNotEmpty) ...[
                  const SizedBox(height: 8),
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
                      fontSize: 11.5,
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
