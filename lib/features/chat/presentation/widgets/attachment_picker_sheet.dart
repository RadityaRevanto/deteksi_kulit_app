import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/network/api_client.dart';
import '../../../history/data/datasources/history_remote_data_source.dart';
import '../../../history/data/models/history_model.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';

void showAttachmentPickerSheet({
  required BuildContext context,
  required ImagePicker imagePicker,
}) {
  const Color darkGreen = Color(0xFF008D68);

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await imagePicker.pickImage(source: source);
      if (image != null && context.mounted) {
        context.read<ChatBloc>().add(
              SendImageMessageEvent(File(image.path)),
            );
      }
    } catch (_) {}
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                pickImage(ImageSource.camera);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F8F2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.camera, color: darkGreen),
                  ),
                  const SizedBox(height: 8),
                  Text('Ambil Foto', style: GoogleFonts.roboto(fontSize: 12)),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                pickImage(ImageSource.gallery);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F8F2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.image, color: darkGreen),
                  ),
                  const SizedBox(height: 8),
                  Text('Pilih Galeri', style: GoogleFonts.roboto(fontSize: 12)),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                _showScanHistoryPickerSheet(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0FDFA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.scanLine, color: darkGreen),
                  ),
                  const SizedBox(height: 8),
                  Text('Riwayat Scan', style: GoogleFonts.roboto(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showScanHistoryPickerSheet(BuildContext parentContext) {
  const Color darkGreen = Color(0xFF008D68);

  showModalBottomSheet(
    context: parentContext,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final apiClient = parentContext.read<ApiClient>();
      final dataSource = HistoryRemoteDataSourceImpl(apiClient: apiClient);
      return FutureBuilder<List<HistoryModel>>(
        future: dataSource.getHistories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator(color: darkGreen)),
            );
          }
          final scans = snapshot.data ?? [];
          if (scans.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text('Belum ada riwayat hasil scan.', style: GoogleFonts.roboto()),
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            height: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Pilih Hasil Scan untuk Dikirim',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: scans.length,
                    itemBuilder: (context, index) {
                      final scan = scans[index];
                      final confidence = (scan.confidence * 100).toStringAsFixed(0);
                      return ListTile(
                        leading: const Icon(LucideIcons.scanLine, color: darkGreen),
                        title: Text(scan.conditionName, style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                        subtitle: Text('Akurasi $confidence% • ${scan.date.day}/${scan.date.month}/${scan.date.year}'),
                        onTap: () {
                          Navigator.pop(ctx);
                          final msg = '[DOKUMEN_HASIL_SCAN]\n📋 Kondisi: ${scan.conditionName}\n🎯 Akurasi: $confidence%\n📅 Tanggal: ${scan.date.day}/${scan.date.month}/${scan.date.year}\n\nMohon saran dan rekomendasi perawatan untuk kondisi kulit seperti ini ya.';
                          parentContext.read<ChatBloc>().add(SendTextMessageEvent(msg));
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
