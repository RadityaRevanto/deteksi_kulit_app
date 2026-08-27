import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/datasources/doctor_remote_data_source.dart';
import '../../domain/entities/doctor.dart';
import '../widgets/doctor_card.dart';
import '../widgets/schedule_picker_bottom_sheet.dart';

class KonfirmasiDokterPage extends StatefulWidget {
  const KonfirmasiDokterPage({super.key});

  @override
  State<KonfirmasiDokterPage> createState() => _KonfirmasiDokterPageState();
}

class _KonfirmasiDokterPageState extends State<KonfirmasiDokterPage> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  bool _isLoading = true;
  List<Doctor> _allDoctors = [];
  String? _errorMessage;

  final List<String> _categories = [
    'Semua',
    'Aura Skin AI',
    'Spesialis Kulit',
    'Dermatologi',
  ];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiClient = context.read<ApiClient>();
      final dataSource = DoctorRemoteDataSourceImpl(apiClient: apiClient);
      final doctors = await dataSource.getDoctors();
      setState(() {
        _allDoctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data dokter: $e';
        _isLoading = false;
      });
    }
  }

  List<Doctor> get _filteredDoctors {
    return _allDoctors.where((doctor) {
      final matchesSearch = doctor.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          doctor.specialist.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_selectedCategoryIndex == 0) return matchesSearch;
      if (_selectedCategoryIndex == 1) {
        return matchesSearch && doctor.isAiBot;
      }
      if (_selectedCategoryIndex == 2) {
        return matchesSearch && doctor.specialist.toLowerCase().contains('kulit');
      }
      if (_selectedCategoryIndex == 3) {
        return matchesSearch && doctor.specialist.toLowerCase().contains('dermatologi');
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
      appBar: AppBar(
        backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0.5,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Text(
              'Konsultasi Dokter & AI',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF151918),
              ),
            ),
            centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
          Expanded(
              child: _isLoading
                  ? const LoadingWidget(message: 'Memuat data dokter...')
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                LucideIcons.alertCircle,
                                size: 44,
                                color: Color(0xFFEF4444),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _fetchDoctors,
                                icon: const Icon(
                                  LucideIcons.rotateCw,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                label: const Text('Coba Lagi'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00BF83),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                'Rekomendasi Dokter Spesialis & AI',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF151918),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _filteredDoctors.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: Text(
                                          'Tidak ada dokter yang sesuai pencarian.',
                                          style: GoogleFonts.roboto(
                                            fontSize: 13,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: _filteredDoctors.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 14),
                                      itemBuilder: (context, index) {
                                        final doctor = _filteredDoctors[index];
                                        return DoctorCard(
                                          doctor: doctor,
                                          onConsultTap: () =>
                                              context.push(AppRouter.chatRoom, extra: doctor),
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