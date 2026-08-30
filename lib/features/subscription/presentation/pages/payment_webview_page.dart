import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/subscription_remote_data_source.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/payment_method_option.dart';
import '../widgets/payment_method_tile.dart';
import '../widgets/price_summary_breakdown.dart';
import '../widgets/selected_payment_method_tile.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebViewPage({super.key, required this.paymentUrl});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color textColor = Color(0xFF101828);
  static const Color orangeColor = Color(0xFFF97316);

  WebViewController? _webViewController;
  bool _showInAppWebView = false;
  bool _isLoadingWebView = true;
  bool _showMethodPicker = false;
  bool _isCreatingCheckout = false;
  String _activePaymentUrl = '';
  Timer? _loadingTimeoutTimer;

  PaymentMethodOption _selectedMethod = PaymentMethodOption.allOptions.first;

  @override
  void initState() {
    super.initState();
    _activePaymentUrl = widget.paymentUrl;
    if (_activePaymentUrl.isNotEmpty) {
      _initWebView();
    }
  }

  @override
  void dispose() {
    _loadingTimeoutTimer?.cancel();
    super.dispose();
  }

  void _initWebView() {
    if (_activePaymentUrl.isNotEmpty) {
      final targetUrl = '$_activePaymentUrl${_selectedMethod.snapAnchor}';
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              if (mounted) setState(() => _isLoadingWebView = true);
              _startLoadingTimeout();
            },
            onProgress: (int progress) {
              if (progress >= 35 && _isLoadingWebView && mounted) {
                setState(() => _isLoadingWebView = false);
              }
            },
            onPageFinished: (String url) {
              if (mounted) setState(() => _isLoadingWebView = false);
            },
            onWebResourceError: (WebResourceError error) {
              if (mounted) setState(() => _isLoadingWebView = false);
            },
          ),
        )
        ..loadRequest(Uri.parse(targetUrl));
    }
  }

  void _startLoadingTimeout() {
    _loadingTimeoutTimer?.cancel();
    _loadingTimeoutTimer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted && _isLoadingWebView) {
        setState(() => _isLoadingWebView = false);
      }
    });
  }

  Future<void> _openExternalBrowser() async {
    if (_activePaymentUrl.isEmpty) return;
    try {
      final targetUrl = '$_activePaymentUrl${_selectedMethod.snapAnchor}';
      final uri = Uri.parse(targetUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _openInAppSnapPayment() async {
    if (_activePaymentUrl.isEmpty) {
      setState(() => _isCreatingCheckout = true);
      try {
        final apiClient = context.read<ApiClient>();
        final dataSource = SubscriptionRemoteDataSourceImpl(apiClient: apiClient);
        final checkoutResult = await dataSource.checkout();
        if (mounted) {
          setState(() {
            _activePaymentUrl = checkoutResult.redirectUrl;
            _isCreatingCheckout = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isCreatingCheckout = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal membuat transaksi: ${e.toString().replaceAll('Exception: ', '')}'),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
        return;
      }
    }

    _initWebView();
    setState(() => _showInAppWebView = true);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 30));
    final startDateStr = '${now.day} ${DateFormat('MMM').format(now)} ${now.year}';
    final endDateStr = '${endDate.day} ${DateFormat('MMM').format(endDate)} ${endDate.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            if (_showInAppWebView) {
              setState(() => _showInAppWebView = false);
            } else if (_showMethodPicker) {
              setState(() => _showMethodPicker = false);
            } else {
              context.pop();
            }
          },
          icon: const Icon(LucideIcons.chevronLeft, color: textColor),
        ),
        title: Text(
          _showInAppWebView
              ? 'Pembayaran ${_selectedMethod.name}'
              : (_showMethodPicker ? 'Metode Pembayaran' : 'Cek Pesanan'),
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: false,
        actions: _showInAppWebView
            ? [
                IconButton(
                  tooltip: 'Buka di Browser',
                  onPressed: _openExternalBrowser,
                  icon: const Icon(LucideIcons.externalLink, color: textColor, size: 20),
                ),
              ]
            : null,
      ),
      body: _showInAppWebView
          ? Stack(
              children: [
                if (_webViewController != null)
                  WebViewWidget(controller: _webViewController!),
                if (_isLoadingWebView)
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: primaryGreen),
                          const SizedBox(height: 16),
                          Text(
                            'Membuka Instruksi Pembayaran ${_selectedMethod.name}...',
                            style: GoogleFonts.roboto(fontSize: 13, color: const Color(0xFF475569)),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : _showMethodPicker
              ? PaymentMethodPickerList(
                  selectedMethod: _selectedMethod,
                  onSelectMethod: (method) {
                    setState(() {
                      _selectedMethod = method;
                      _showMethodPicker = false;
                    });
                  },
                )
              : _buildOrderSummary(startDateStr, endDateStr),
    );
  }

  Widget _buildOrderSummary(String startDateStr, String endDateStr) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderSummaryCard(
                  startDateStr: startDateStr,
                  endDateStr: endDateStr,
                ),
                const SizedBox(height: 20),
                SelectedPaymentMethodTile(
                  method: _selectedMethod,
                  onChangeTap: () {
                    setState(() => _showMethodPicker = true);
                  },
                ),
                const SizedBox(height: 24),
                const PriceSummaryBreakdown(),
              ],
            ),
          ),
        ),

        // Bottom Action Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            boxShadow: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isCreatingCheckout ? null : _openInAppSnapPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orangeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isCreatingCheckout
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Memproses Pesanan...',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Bayar dengan ${_selectedMethod.name}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    context.go(AppRouter.main);
                  },
                  child: Text(
                    'Kembali ke Beranda',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
