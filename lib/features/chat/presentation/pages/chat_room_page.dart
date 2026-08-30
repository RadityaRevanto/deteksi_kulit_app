import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../dokter/domain/entities/doctor.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../domain/entities/chat_message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/ai_consent_dialog.dart';
import '../widgets/attachment_picker_sheet.dart';
import '../widgets/chat_bubble.dart';

class ChatRoomPage extends StatefulWidget {
  final Doctor doctor;
  final String? conversationUuid;
  final String? initialMessage;

  const ChatRoomPage({
    super.key,
    required this.doctor,
    this.conversationUuid,
    this.initialMessage,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  static const Color primaryGreen = Color(0xFF00BF83);
  static const Color darkGreen = Color(0xFF008D68);
  static const Color textColor = Color(0xFF101828);

  int _previousMessageCount = 0;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isNearBottom() {
    if (!_scrollController.hasClients) return true;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return (maxScroll - currentScroll) <= 150;
  }

  void _scrollToBottom([bool animated = true]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          if (animated) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          } else {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final apiClient = context.read<ApiClient>();
        final dataSource = ChatRemoteDataSourceImpl(apiClient: apiClient);
        return ChatBloc(remoteDataSource: dataSource)
          ..add(InitChatEvent(
            doctorUuid: widget.doctor.id,
            conversationUuid: widget.conversationUuid,
            isAiBot: widget.doctor.isAiBot,
            initialMessage: widget.initialMessage,
          ));
      },
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.needsAiConsent) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showAiConsentDialog(context);
            });
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: const Color(0xFFEF4444),
              ),
            );
          }
          if (state.status == ChatStatus.success && state.messages.isNotEmpty) {
            final hasNewMessages = state.messages.length > _previousMessageCount;
            final isFirstLoad = _previousMessageCount == 0;

            if (isFirstLoad) {
              _scrollToBottom(false);
            } else if (hasNewMessages && _isNearBottom()) {
              _scrollToBottom(true);
            }
            _previousMessageCount = state.messages.length;
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(LucideIcons.chevronLeft, color: textColor),
              ),
              titleSpacing: 0,
              title: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.doctor.isAiBot
                              ? const Color(0xFFF0FDFA)
                              : const Color(0xFFE6F8F2),
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: (widget.doctor.avatarUrl.isNotEmpty &&
                                  widget.doctor.avatarUrl.startsWith('http'))
                              ? Image.network(
                                  widget.doctor.avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    widget.doctor.isAiBot
                                        ? LucideIcons.bot
                                        : LucideIcons.userCheck,
                                    color: darkGreen,
                                    size: 20,
                                  ),
                                )
                              : Icon(
                                  widget.doctor.isAiBot
                                      ? LucideIcons.bot
                                      : LucideIcons.userCheck,
                                  color: darkGreen,
                                  size: 20,
                                ),
                        ),
                      ),
                      if (widget.doctor.isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: GoogleFonts.roboto(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.doctor.isAiBot
                              ? 'Asisten AI SkinCek 24/7'
                              : widget.doctor.specialist,
                          style: GoogleFonts.roboto(
                            fontSize: 11,
                            color: darkGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Builder(
              builder: (context) {
                final sortedMessages = List<ChatMessage>.from(state.messages)
                  ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

                return Column(
                  children: [
                    // Chat Message List
                    Expanded(
                      child: state.status == ChatStatus.loading && state.messages.isEmpty
                          ? const LoadingWidget(message: 'Memuat percakapan...')
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              itemCount: sortedMessages.length,
                              itemBuilder: (context, index) {
                                final msg = sortedMessages[index];
                                return ChatBubble(message: msg);
                              },
                            ),
                    ),

                    if (state.isSending)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: darkGreen,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.doctor.isAiBot
                                  ? 'Aura Skin AI sedang memproses & mengetik balasan...'
                                  : 'Mengirim pesan...',
                              style: GoogleFonts.roboto(fontSize: 11, color: darkGreen, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),

                    // Bottom Input Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => showAttachmentPickerSheet(
                                context: context,
                                imagePicker: _picker,
                              ),
                              icon: const Icon(
                                LucideIcons.paperclip,
                                color: Color(0xFF64748B),
                                size: 22,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: TextField(
                                  controller: _messageController,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    hintText: widget.doctor.isAiBot
                                        ? 'Tanyakan sesuatu ke Aura Skin AI...'
                                        : 'Tulis pesan untuk dokter...',
                                    hintStyle: GoogleFonts.roboto(
                                      fontSize: 13,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (text) {
                                    if (text.trim().isNotEmpty) {
                                      context.read<ChatBloc>().add(
                                            SendTextMessageEvent(text),
                                          );
                                      _messageController.clear();
                                      _scrollToBottom(true);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                final text = _messageController.text.trim();
                                if (text.isNotEmpty) {
                                  context.read<ChatBloc>().add(
                                        SendTextMessageEvent(text),
                                      );
                                  _messageController.clear();
                                  _scrollToBottom(true);
                                }
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.send,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
