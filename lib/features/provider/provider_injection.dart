import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/provider/data/datasources/provider_location_datasource.dart';
import 'package:khedma/features/provider/data/datasources/provider_remote_datasource.dart';
import 'package:khedma/features/provider/data/repositories/provider_repository_impl.dart';
import 'package:khedma/features/provider/domain/repositories/provider_repository.dart';
import 'package:khedma/features/provider/domain/usecases/provider_use_cases.dart';
import 'package:khedma/features/provider/presentation/cubit/provider_finance_cubit.dart';
import 'package:khedma/features/provider/presentation/cubit/provider_jobs_cubit.dart';
import 'package:khedma/features/provider/presentation/cubit/provider_reviews_cubit.dart';
import 'package:khedma/features/provider/presentation/cubit/provider_services_cubit.dart';
import 'package:khedma/features/provider/home/presentation/cubit/provider_navigation_cubit/provider_navigation_cubit.dart';
import 'package:khedma/injection_container.dart';

final _sl = ServiceLocator.instance;

void initProviderFeatureInjection() {
  _sl
    ..registerLazySingleton<ProviderRemoteDataSource>(
      ProviderRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<ProviderLocationDataSource>(
      ProviderLocationDataSourceImpl.new,
    )
    ..registerLazySingleton<ProviderRepository>(
      () => ProviderRepositoryImpl(_sl(), _sl()),
    )
    ..registerLazySingleton(() => GetPendingJobs(_sl()))
    ..registerLazySingleton(() => AcceptProviderJob(_sl()))
    ..registerLazySingleton(() => RejectProviderJob(_sl()))
    ..registerLazySingleton(() => CompleteProviderJob(_sl()))
    ..registerLazySingleton(() => MarkProviderJobEnRoute(_sl()))
    ..registerLazySingleton(() => MarkProviderJobArrived(_sl()))
    ..registerLazySingleton(() => MarkProviderJobInProgress(_sl()))
    ..registerLazySingleton(() => UpdateProviderAvailability(_sl()))
    ..registerLazySingleton(() => GetProviderCurrentPosition(_sl()))
    ..registerLazySingleton(() => WatchProviderPosition(_sl()))
    ..registerLazySingleton(() => PublishProviderLocation(_sl()))
    ..registerLazySingleton(() => GetProviderEarnings(_sl()))
    ..registerLazySingleton(() => GetProviderWallet(_sl()))
    ..registerLazySingleton(() => RequestProviderPayout(_sl()))
    ..registerLazySingleton(() => ReplyToProviderReview(_sl()))
    ..registerFactory(
      () => ProviderJobsCubit(
        getPendingJobs: _sl(),
        getBookingHistory: _sl(),
        getBooking: _sl(),
        acceptJob: _sl(),
        rejectJob: _sl(),
        completeJob: _sl(),
        markEnRoute: _sl(),
        markArrived: _sl(),
        markInProgress: _sl(),
        updateAvailability: _sl(),
        getCurrentPosition: _sl(),
        watchPosition: _sl(),
        publishLocation: _sl(),
        getRoute: _sl(),
        getProfile: _sl(),
        realtimeService: _sl(),
      ),
    )
    ..registerLazySingleton(() => GetProviderServices(_sl()))
    ..registerLazySingleton(() => UpdateProviderServices(_sl()))
    ..registerFactory(
      () => ProviderServicesCubit(getServices: _sl(), updateServices: _sl()),
    )
    ..registerFactory(
      () => ProviderFinanceCubit(
        getEarnings: _sl(),
        getWallet: _sl(),
        requestPayout: _sl(),
      ),
    )
    ..registerFactory(
      () => ProviderReviewsCubit(getReviews: _sl(), replyToReview: _sl()),
    )
    ..registerLazySingleton<ProviderNavigationCubit>(
      ProviderNavigationCubit.new,
    );
}

List<BlocProvider> get providerBlocs => <BlocProvider>[
  BlocProvider<ProviderNavigationCubit>(
    create: (_) => _sl<ProviderNavigationCubit>(),
  ),
  BlocProvider<ProviderJobsCubit>(create: (_) => _sl<ProviderJobsCubit>()),
];
