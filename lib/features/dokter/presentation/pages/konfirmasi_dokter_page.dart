import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/datasources/doctor_remote_data_source.dart';
import '../../domain/entities/doctor.dart';
import '../widgets/doctor_card.dart';
import '../widgets/scan_summary_banner.dart';
import '../widgets/schedule_picker_bottom_sheet.dart';

class KonfirmasiDokterPage extends StatefulWidget {
  const KonfirmasiDokterPage({super.key});

  @override
  State<KonfirmasiDokterPage> createState() => _KonfirmasiDokterPageState();
}

class _KonfirmasiDokterPageState extends State<KonfirmasiDokterPage> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  final List<String> _categories = [
    'Semua',
    'Spesialis Kulit (Sp.KK)',
    'Dermatologi',
    'Jerawat',
  ];

  List<Doctor> get _filteredDoctors {
    return DoctorRemoteDataSource.dummyDoctors.where((doctor) {
      final matchesSearch = doctor.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          doctor.specialist.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_selectedCategoryIndex == 0) return matchesSearch;
      if (_selectedCategoryIndex == 1) {
        return matchesSearch && doctor.specialist.contains('Sp.KK');
      }
      if (_selectedCategoryIndex == 2) {
        return matchesSearch && doctor.specialist.contains('Dermatologi');
      }
      if (_selectedCategoryIndex == 3) {
        return matchesSearch && doctor.specialist.contains('Jerawat');
      }
      return matchesSearch;
    }).toList();
  }

  void _showScheduleBottomSheet(Doctor doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SchedulePickerBottomSheet(
          doctor: doctor,
          onConfirm: () {
            Navigator.pop(context);
            _showSuccessDialog(doctor);
          },
        );
      },
    );
  }

  void _showSuccessDialog(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F8F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.checkCircle2,
                  color: Color(0xFF00BF83),
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Janji Konsultasi Berhasil!',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF151918),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Anda telah menjadwalkan konsultasi dengan ${doctor.name}. Hasil analisis AI Anda telah dilampirkan.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  height: 1.4,
                  color: const Color(0xFF7B8581),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.pop(); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BF83),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Kembali ke Beranda',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header App Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      LucideIcons.chevronLeft,
                      size: 24,
                      color: Color(0xFF151918),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Konfirmasi dengan Dokter',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF151918),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScanSummaryBanner(
                      conditionName: 'Acne / Jerawat',
                      confidencePercentage: '87%',
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'Cari spesialis atau nama dokter...',
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                          icon: const Icon(
                            LucideIcons.search,
                            size: 18,
                            color: Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final isSelected = _selectedCategoryIndex == index;
                          return GestureDetector(
                            onTap: () => setState(
                              () => _selectedCategoryIndex = index,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF00BF83)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF00BF83)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: Text(
                                _categories[index],
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Rekomendasi Dokter Spesialis Kulit',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF151918),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredDoctors.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final doctor = _filteredDoctors[index];
                        return DoctorCard(
                          doctor: doctor,
                          onConsultTap: () => _showScheduleBottomSheet(doctor),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}