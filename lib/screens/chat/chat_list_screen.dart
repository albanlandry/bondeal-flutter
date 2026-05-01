import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/mock_data.dart';
import '../../theme/app_theme.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
              child: Text(
                'Messages',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
              ),
            ),
            // Chat list
            Expanded(
              child: mockChatItems.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucune conversation',
                        style: TextStyle(fontSize: 16, color: AppColors.gray),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                      itemCount: mockChatItems.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        indent: 76,
                        endIndent: AppSpacing.md,
                        color: AppColors.grayLight,
                      ),
                      itemBuilder: (context, index) {
                        final chat = mockChatItems[index];
                        return InkWell(
                          onTap: () => context.push('/chatroom'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                // Avatar
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.grayLight, width: 1.5),
                                    color: AppColors.background,
                                  ),
                                  child: const ClipOval(
                                    child: Center(
                                      child: Icon(Icons.person, size: 26, color: AppColors.gray),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                // Message content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              chat.username,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF1A1A1A),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: AppSpacing.sm),
                                          Text(
                                            chat.timestamp,
                                            style: const TextStyle(fontSize: 12, color: AppColors.gray),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        chat.messagePreview,
                                        style: const TextStyle(fontSize: 13, color: AppColors.gray, height: 1.3),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                // Optional thumbnail image
                                if (chat.hasImage && chat.imageUrl != null) ...[
                                  const SizedBox(width: AppSpacing.sm),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      imageUrl: chat.imageUrl!,
                                      width: 44,
                                      height: 36,
                                      fit: BoxFit.cover,
                                      placeholder: (_, _) => Container(
                                        width: 44,
                                        height: 36,
                                        color: AppColors.grayLight,
                                      ),
                                      errorWidget: (_, _, _) => Container(
                                        width: 44,
                                        height: 36,
                                        color: AppColors.grayLight,
                                        child: const Icon(Icons.image, size: 16, color: AppColors.gray),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
