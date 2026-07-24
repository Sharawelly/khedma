import '/injection_container.dart';
import 'data/datasources/customer_remote_datasource.dart';
import 'data/repositories/customer_repository_impl.dart';
import 'domain/payment/payment_gateway.dart';
import 'domain/repositories/customer_repository.dart';
import 'domain/usecases/customer_use_cases.dart';
import 'presentation/cubit/booking_cubit.dart';
import 'presentation/cubit/catalog_cubit.dart';
import 'presentation/cubit/favorites_cubit.dart';
import 'presentation/cubit/provider_profile_cubit.dart';

void initCustomerFeatureInjection() {
  final locator = ServiceLocator.instance;
  locator
    ..registerLazySingleton<CustomerRemoteDataSource>(
      CustomerRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<CustomerRepository>(
      () => CustomerRepositoryImpl(locator()),
    )
    ..registerLazySingleton<PaymentGateway>(NoOpPaymentGateway.new)
    ..registerLazySingleton(() => GetCategories(locator()))
    ..registerLazySingleton(() => GetServices(locator()))
    ..registerLazySingleton(() => GetService(locator()))
    ..registerLazySingleton(() => GetProviders(locator()))
    ..registerLazySingleton(() => GetProvider(locator()))
    ..registerLazySingleton(() => GetProviderReviews(locator()))
    ..registerLazySingleton(() => CreateBooking(locator(), locator()))
    ..registerLazySingleton(() => GetBooking(locator()))
    ..registerLazySingleton(() => GetBookingHistory(locator()))
    ..registerLazySingleton(() => CancelBooking(locator()))
    ..registerLazySingleton(() => GetBookingEta(locator()))
    ..registerLazySingleton(() => ToggleFavorite(locator()))
    ..registerLazySingleton(() => GetFavorites(locator()))
    ..registerLazySingleton(() => CreateReview(locator()))
    ..registerLazySingleton(() => UpdateReview(locator()))
    ..registerFactory(
      () => CatalogCubit(
        getCategories: locator(),
        getServices: locator(),
        getService: locator(),
        getProviders: locator(),
      ),
    )
    ..registerFactory(
      () => ProviderProfileCubit(
        getProvider: locator(),
        getProviderReviews: locator(),
        toggleFavorite: locator(),
      ),
    )
    ..registerFactory(() => FavoritesCubit(locator()))
    ..registerFactory(
      () => BookingCubit(
        createBooking: locator(),
        getBooking: locator(),
        getBookingHistory: locator(),
        cancelBooking: locator(),
        getBookingEta: locator(),
        createReview: locator(),
        updateReview: locator(),
      ),
    );
}
