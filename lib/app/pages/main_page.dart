import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';
import '../bloc/navigation/navigation_state.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/dokter/presentation/pages/konfirmasi_dokter_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color inactiveColor = Color(0xFF9A9A9A);

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomePage(),
      HistoryPage(),
      KonfirmasiDokterPage(),
      ProfilePage(),
    ];

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,

          body: IndexedStack(index: state.currentIndex, children: pages),

          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFF0F0F0), width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 68,
                child: Row(
                  children: [
                    Expanded(
                      child: _NavItem(
                        label: 'Home',
                        icon: LucideIcons.house,
                        activeIcon: LucideIcons.house,
                        isSelected: state.currentIndex == 0,
                        onTap: () {
                          context.read<NavigationBloc>().add(
                            NavigationTabChanged(0),
                          );
                        },
                      ),
                    ),

                    Expanded(
                      child: _NavItem(
                        label: 'Riwayat',
                        icon: LucideIcons.clock3,
                        activeIcon: LucideIcons.clock3,
                        isSelected: state.currentIndex == 1,
                        onTap: () {
                          context.read<NavigationBloc>().add(
                            NavigationTabChanged(1),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        label: 'Konsultasi',
                        icon: LucideIcons.messageSquare,
                        activeIcon: LucideIcons.messageSquare,
                        isSelected: state.currentIndex == 2,
                        onTap: () {
                          context.read<NavigationBloc>().add(
                            NavigationTabChanged(2),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _NavItem(
                        label: 'Profil',
                        icon: LucideIcons.userRound,
                        activeIcon: LucideIcons.userRound,
                        isSelected: state.currentIndex == 3,
                        onTap: () {
                          context.read<NavigationBloc>().add(
                            NavigationTabChanged(3),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color inactiveColor = Color(0xFF929292);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.08 : 1,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 20,
                color: isSelected ? primaryGreen : inactiveColor,
              ),
            ),

            const SizedBox(height: 4),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: GoogleFonts.roboto(
                fontSize: 11,
                height: 1.6,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? primaryGreen : inactiveColor,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
