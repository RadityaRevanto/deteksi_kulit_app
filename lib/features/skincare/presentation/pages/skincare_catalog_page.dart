import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/datasources/skincare_remote_data_source.dart';
import '../bloc/skincare_bloc.dart';
import '../bloc/skincare_event.dart';
import '../bloc/skincare_state.dart';
import '../widgets/skincare_product_card.dart';

class SkincareCatalogPage extends StatefulWidget {
  const SkincareCatalogPage({super.key});

  @override
  State<SkincareCatalogPage> createState() => _SkincareCatalogPageState();
}

class _SkincareCatalogPageState extends State<SkincareCatalogPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedConcernUuid;

  static const Color darkGreen = Color(0xFF008D68);
  static const Color textColor = Color(0xFF101828);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final apiClient = context.read<ApiClient>();
        final dataSource = SkincareRemoteDataSourceImpl(apiClient: apiClient);
        return SkincareBloc(remoteDataSource: dataSource)
          ..add(const FetchSkincareCatalogEvent());
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.chevronLeft, color: textColor),
              ),
              title: Text(
                'Katalog Skincare Medis',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              centerTitle: false,
            ),
            body: Column(
              children: [
                // Top Search & Filter Bar
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            icon: const Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 18),
                            hintText: 'Cari produk skincare atau bahan aktif...',
                            hintStyle: GoogleFonts.roboto(fontSize: 13, color: const Color(0xFF94A3B8)),
                            border: InputBorder.none,
                          ),
                          onChanged: (query) {
                            context.read<SkincareBloc>().add(FetchSkincareCatalogEvent(
                                  concernUuid: _selectedConcernUuid,
                                  searchQuery: query,
                                ));
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Concern Filter Chips
                      BlocBuilder<SkincareBloc, SkincareState>(
                        builder: (context, state) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                FilterChip(
                                  selected: _selectedConcernUuid == null,
                                  showCheckmark: false,
                                  label: const Text('Semua'),
                                  labelStyle: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: _selectedConcernUuid == null ? Colors.white : const Color(0xFF475569),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  selectedColor: darkGreen,
                                  backgroundColor: const Color(0xFFF1F5F9),
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedConcernUuid = null;
                                    });
                                    context.read<SkincareBloc>().add(FetchSkincareCatalogEvent(
                                          searchQuery: _searchController.text,
                                        ));
                                  },
                                ),
                                const SizedBox(width: 8),
                                ...state.concerns.map((concern) {
                                  final isSelected = _selectedConcernUuid == concern.uuid;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      selected: isSelected,
                                      showCheckmark: false,
                                      label: Text(concern.name),
                                      labelStyle: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: isSelected ? Colors.white : const Color(0xFF475569),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      selectedColor: darkGreen,
                                      backgroundColor: const Color(0xFFF1F5F9),
                                      side: BorderSide.none,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      onSelected: (_) {
                                        setState(() {
                                          _selectedConcernUuid = concern.uuid;
                                        });
                                        context.read<SkincareBloc>().add(FetchSkincareCatalogEvent(
                                              concernUuid: concern.uuid,
                                              searchQuery: _searchController.text,
                                            ));
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

                // Skincare Products Grid List
                Expanded(
                  child: BlocBuilder<SkincareBloc, SkincareState>(
                    builder: (context, state) {
                      if (state.status == SkincareStatus.loading && state.products.isEmpty) {
                        return const LoadingWidget(message: 'Memuat katalog produk...');
                      }

                      if (state.products.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(LucideIcons.packageX, size: 48, color: Color(0xFF94A3B8)),
                              const SizedBox(height: 12),
                              Text(
                                'Tidak ada produk skincare ditemukan.',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          return SkincareProductCard(
                            product: product,
                            onTap: () {
                              context.push(
                                AppRouter.skincareDetail,
                                extra: product,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
