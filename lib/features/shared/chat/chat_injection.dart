import '/injection_container.dart';
import 'data/datasources/chat_remote_datasource.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/usecases/chat_use_cases.dart';
import 'presentation/cubit/chat_details_cubit.dart';
import 'presentation/cubit/chat_threads_cubit.dart';

void initChatFeatureInjection() {
  final locator = ServiceLocator.instance;
  locator
    ..registerLazySingleton<ChatRemoteDataSource>(ChatRemoteDataSourceImpl.new)
    ..registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(locator()))
    ..registerLazySingleton(() => GetChatThreads(locator()))
    ..registerLazySingleton(() => GetChatHistory(locator()))
    ..registerLazySingleton(() => SendChatMessage(locator()))
    ..registerLazySingleton(() => UploadChatAttachment(locator()))
    ..registerLazySingleton(() => MarkChatRead(locator()))
    ..registerFactory(() => ChatThreadsCubit(locator(), locator()))
    ..registerFactory(
      () => ChatDetailsCubit(
        getChatHistory: locator(),
        sendChatMessage: locator(),
        uploadChatAttachment: locator(),
        markChatRead: locator(),
        realtimeService: locator(),
      ),
    );
}
