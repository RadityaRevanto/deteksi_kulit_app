import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/doctor.dart';

class SchedulePickerBottomSheet extends StatefulWidget {
  final Doctor doctor;
  final VoidCallback onConfirm;

  const SchedulePickerBottomSheet({
    super.key,
    required this.doctor,
    required this.onConfirm,
  });

  @override
  State<SchedulePickerBottomSheet> createState() =>
      _SchedulePickerBottomSheetState();
}

class _SchedulePickerBottomSheetState
    extends State<SchedulePickerBottomSheet> {
  int _selectedMethodIndex = 0;
  int _selectedTimeIndex = 0;

  final List<Map<String, dynamic>> _methods = [
    {'title': 'Chat Text', 'icon': LucideIcons.messageSquare, 'sub': 'Sesi Chat 30 menit'},
    {'title': 'Video Call', 'icon': LucideIcons.video, 'sub': 'Tatap muka online'},
  ];

  final List<String> _timeSlots = [
    'Hari ini, 19:30 WIB',
    'Hari ini, 20:00 WIB',
    'Besok, 09:00 WIB',
    'Besok, 10:30 WIB',
  ];

  @override
  Widget build(BuildContext context) {
    final feeFormatted =
        'Rp ${widget.doctor.consultationFee.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]}.',
            )}';
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Konfirmasi Konsultasi',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF151918),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F8F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.userCheck,
                  color: Color(0xFF008D68),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor.name,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF151918),
                      ),
                    ),
                    Text(
                      widget.doctor.specialist,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: const Color(0xFF7B8581),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Metode Konsultasi',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF151918),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(_methods.length, (index) {
              final isSelected = _selectedMethodIndex == index;
              final item = _methods[index];
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMethodIndex = index),
                  child: Container(
                    margin: EdgeInsets.only(right: index == 0 ? 8 : 0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE6F8F2)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF00BF83)
                            : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 20,
                          color: isSelected
                              ? const Color(0xFF008D68)
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['title'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? const Color(0xFF008D68)
                                : const Color(0xFF151918),
                          ),
                        ),
                        Text(
                          item['sub'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            color: const Color(0xFF7B8581),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text(
            'Pilih Jadwal Konsultasi',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF151918),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_timeSlots.length, (index) {
              final isSelected = _selectedTimeIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTimeIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF008D68)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _timeSlots[index],
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF334155),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BF83),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Konfirmasi & Bayar ($feeFormatted)',
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
  }
}