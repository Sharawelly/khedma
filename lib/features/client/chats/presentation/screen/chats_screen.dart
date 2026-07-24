import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/routes/app_routes.dart';
import '/core/widgets/no_data_found.dart';
import '/core/widgets/app_shimmer.dart';
import '/features/shared/chat/domain/entities/chat_entities.dart';
import '/features/shared/chat/presentation/cubit/chat_threads_cubit.dart';
import '/injection_container.dart';
import '../widgets/chat_thread_card.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.instance<ChatThreadsCubit>()..load(),
      child: BlocBuilder<ChatThreadsCubit, ChatThreadsState>(
        builder: (context, state) {
          if (state is ChatThreadsLoading || state is ChatThreadsInitial) {
            return AppShimmer(
              child: Container(color: colors.lightBackGroundColor),
            );
          }
          if (state is ChatThreadsFailure) {
            return Center(
              child: SelectableText.rich(
                TextSpan(
                  text: state.message,
                  style: TextStyle(color: colors.errorColor),
                ),
              ),
            );
          }
          final threads = (state as ChatThreadsSuccess).threads;
          if (threads.isEmpty) {
            return const NoDataFound();
          }
          return RefreshIndicator(
            onRefresh: context.read<ChatThreadsCubit>().load,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsetsDirectional.all(16.r),
              itemCount: threads.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final ChatThreadEntity thread = threads[index];
                return ChatThreadCard(
                  thread: thread,
                  onTap: () =>
                      context.push(Routes.chatDetailsRoute, extra: thread),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
