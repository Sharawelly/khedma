import '/injection_container.dart';
import 'data/datasources/profile_remote_datasource.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/usecases/profile_use_cases.dart';
import 'presentation/cubit/profile_management_cubit.dart';

void initProfileFeatureInjection() {
  final locator = ServiceLocator.instance;
  locator
    ..registerLazySingleton<ProfileRemoteDataSource>(
      ProfileRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(locator()),
    )
    ..registerLazySingleton(() => UpdateProfile(locator()))
    ..registerLazySingleton(() => ChangePassword(locator()))
    ..registerLazySingleton(() => GetAddresses(locator()))
    ..registerLazySingleton(() => AddAddress(locator()))
    ..registerLazySingleton(() => DeleteAddress(locator()))
    ..registerLazySingleton(() => GetCertificates(locator()))
    ..registerLazySingleton(() => AddCertificates(locator()))
    ..registerLazySingleton(() => DeleteCertificate(locator()))
    ..registerLazySingleton(() => GetPortfolio(locator()))
    ..registerLazySingleton(() => AddPortfolio(locator()))
    ..registerLazySingleton(() => DeletePortfolioImage(locator()))
    ..registerFactory(
      () => ProfileManagementCubit(
        updateProfile: locator(),
        changePassword: locator(),
        getAddresses: locator(),
        addAddress: locator(),
        deleteAddress: locator(),
        getCertificates: locator(),
        addCertificates: locator(),
        deleteCertificate: locator(),
        getPortfolio: locator(),
        addPortfolio: locator(),
        deletePortfolioImage: locator(),
      ),
    );
}
