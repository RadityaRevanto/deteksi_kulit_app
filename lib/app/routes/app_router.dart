import 'package:go_router/go_router.dart';

import '../pages/main_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/scan_kulit/presentation/pages/scan_kulit_page.dart';
import '../../features/scan_kulit/presentation/pages/hasil_scan_page.dart';
import '../../features/dokter/presentation/pages/konfirmasi_dokter_page.dart';

import '../../features/dokter/domain/entities/doctor.dart';
import '../../features/chat/presentation/pages/chat_room_page.dart';
import '../../features/profile/domain/entities/user_profile.dart';
import '../../features/profile/presentation/pages/account_settings_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/verify_email_otp_page.dart';

import '../../features/scan_kulit/domain/entities/scan_result.dart';
import '../../features/skincare/domain/entities/skincare_product.dart';
import '../../features/skincare/presentation/pages/skincare_catalog_page.dart';
import '../../features/skincare/presentation/pages/skincare_detail_page.dart';

import '../../features/subscription/presentation/pages/subscription_plan_page.dart';
import '../../features/subscription/presentation/pages/payment_webview_page.dart';
import '../../features/subscription/presentation/pages/subscription_history_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String scanKulit = '/scan-kulit';
  static const String hasilScan = '/hasil-scan';
  static const String konfirmasiDokter = '/konfirmasi-dokter';
  static const String editProfile = '/edit-profile';
  static const String accountSettings = '/account-settings';
  static const String verifyEmailOtp = '/verify-email-otp';
  static const String chatRoom = '/chat-room';
  static const String skincareCatalog = '/skincare-catalog';
  static const String skincareDetail = '/skincare-detail';
  static const String subscriptionPlan = '/subscription-plan';
  static const String paymentWebview = '/payment-webview';
  static const String subscriptionHistory = '/subscription-history';

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
        builder: (context, state) {
          final scanResult = state.extra as ScanResult?;
          return HasilScanPage(scanResult: scanResult);
        },
      ),
      GoRoute(
        path: konfirmasiDokter,
        builder: (context, state) => const KonfirmasiDokterPage(),
      ),
      GoRoute(
        path: editProfile,
        builder: (context, state) {
          final profile = state.extra as UserProfile?;
          return EditProfilePage(profile: profile);
        },
      ),
      GoRoute(
        path: accountSettings,
        builder: (context, state) {
          final profile = state.extra as UserProfile?;
          return AccountSettingsPage(profile: profile);
        },
      ),
      GoRoute(
        path: verifyEmailOtp,
        builder: (context, state) {
          final email = state.extra as String?;
          return VerifyEmailOtpPage(email: email);
        },
      ),
      GoRoute(
        path: skincareCatalog,
        builder: (context, state) => const SkincareCatalogPage(),
      ),
      GoRoute(
        path: skincareDetail,
        builder: (context, state) {
          final product = state.extra as SkincareProduct;
          return SkincareDetailPage(product: product);
        },
      ),
      GoRoute(
        path: subscriptionPlan,
        builder: (context, state) => const SubscriptionPlanPage(),
      ),
      GoRoute(
        path: paymentWebview,
        builder: (context, state) {
          final url = state.extra as String? ?? '';
          return PaymentWebViewPage(paymentUrl: url);
        },
      ),
      GoRoute(
        path: subscriptionHistory,
        builder: (context, state) => const SubscriptionHistoryPage(),
      ),
      GoRoute(
        path: chatRoom,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Doctor) {
            return ChatRoomPage(doctor: extra);
          } else if (extra is Map<String, dynamic>) {
            final doctor = extra['doctor'] as Doctor;
            final convUuid = extra['conversationUuid'] as String?;
            final initialMsg = extra['initialMessage'] as String?;
            return ChatRoomPage(
              doctor: doctor,
              conversationUuid: convUuid,
              initialMessage: initialMsg,
            );
          }
          return ChatRoomPage(
            doctor: Doctor(
              id: '',
              name: 'Aura Skin AI',
              specialist: 'Kecerdasan Buatan',
              hospital: 'SkinCek AI',
              rating: 5.0,
              reviewCount: 100,
              experienceYears: 10,
              consultationFee: 0,
              isOnline: true,
              avatarUrl: '',
              isAiBot: true,
            ),
          );
        },
      ),
    ],
  );
}