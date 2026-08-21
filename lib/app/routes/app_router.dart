import 'package:go_router/go_router.dart';

import '../pages/main_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/scan_kulit/presentation/pages/scan_kulit_page.dart';
import '../../features/scan_kulit/presentation/pages/hasil_scan_page.dart';
import '../../features/dokter/presentation/pages/konfirmasi_dokter_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String scanKulit = '/scan-kulit';
  static const String hasilScan = '/hasil-scan';
  static const String konfirmasiDokter = '/konfirmasi-dokter';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: main,
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: scanKulit,
        builder: (context, state) => const ScanKulitPage(),
      ),
      GoRoute(
        path: hasilScan,
        builder: (context, state) => const HasilScanPage(),
      ),
      GoRoute(
        path: konfirmasiDokter,
        builder: (context, state) => const KonfirmasiDokterPage(),
      ),
    ],
  );
}