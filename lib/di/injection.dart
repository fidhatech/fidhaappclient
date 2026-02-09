import 'package:dating_app/core/network/cubit/network_status_cubit.dart';
import 'package:dating_app/core/services/socket_session_manager.dart';
import 'package:dating_app/features/employee/call/cubit/employee_call_cubit.dart';
import 'package:dating_app/features/employee/history/cubit/session_cubit.dart';
import 'package:dating_app/features/onboarding/service/onboarding_service.dart';
import 'package:dating_app/features/user/features/promotion/cubit/popup_offer_cubit.dart';
import 'package:dating_app/features/employee/history/service/session_history.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_language_cubit/employee_language_cubit.dart';
import 'package:dating_app/features/employee/session/cubit/employee_session_cubit.dart';
import 'package:dating_app/features/employee/service/employee_service.dart';
import 'package:dating_app/features/payment/service/payment_service.dart';
import 'package:dating_app/features/splash/user_auth/data/repositories/user_auth_repository.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:dating_app/features/user/features/call/cubit/client_call_cubit.dart';
import 'package:dating_app/features/user/features/call/service/client_call_service.dart';
import 'package:dating_app/features/user/features/history/cubit/history_cubit.dart';
import 'package:dating_app/features/user/features/history/service/history_service.dart';
import 'package:dating_app/features/user/features/navigation/cubit/navigator_cubit.dart';
import 'package:dating_app/features/employee/main/cubit/navigator_cubit.dart';
import 'package:dating_app/features/user/features/premium/bloc/premium_bloc.dart';
import 'package:dating_app/features/user/features/premium/service/premium_service.dart';
import 'package:dating_app/features/wallet/cubit/wallet_cubit.dart';
import 'package:dating_app/features/wallet/service/wallet_service.dart';
import 'package:dating_app/features/user/features/user_profile/cubit/profile_cubit.dart';
import 'package:dating_app/features/user/features/user_profile/services/profile_service.dart';
import 'package:dating_app/features/user/features/promotion/service/popup_offer_service.dart';
import 'package:get_it/get_it.dart';
import 'package:dating_app/core/network/http/dio_client.dart';
import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/features/splash/user_auth/data/datasources/auth_remote_datasource.dart';
import 'package:dating_app/features/splash/user_auth/data/repositories/user_auth_repository_impl.dart';
import 'package:dating_app/features/splash/user_auth/domain/usecases/send_otp_usecase.dart';
import 'package:dating_app/features/splash/user_auth/domain/usecases/verify_otp_usecase.dart';
import 'package:dating_app/features/splash/user_auth/domain/usecases/resend_otp_usecase.dart';
import 'package:dating_app/core/utils/network_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dating_app/features/user/features/home/bloc/home_bloc.dart';
import 'package:dating_app/features/user/features/home/repository/home_repo.dart';
import 'package:dating_app/features/user/features/home/repository/home_services.dart';
import 'package:dating_app/features/user/features/details/repository/user_details_repository.dart';
import 'package:dating_app/features/user/features/details/presentation/cubit/user_details_cubit.dart';

final sl = GetIt.instance;

void init() {
  // 1) Dio Client
  sl.registerLazySingleton(() => DioClient.instance);

  // 2) Remote datasource
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(sl()),
  );

  // 3) Repositories
  sl.registerLazySingleton<UserAuthRepository>(
    () => UserAuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<HomeServices>(() => HomeServices(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepository(sl()));
  sl.registerLazySingleton<OnboardingService>(() => OnboardingService(sl()));
  sl.registerLazySingleton<EmployeeService>(() => EmployeeService(sl()));
  sl.registerLazySingleton<SocketService>(() => SocketService());
  sl.registerLazySingleton<HistoryService>(() => HistoryService(sl()));
  sl.registerLazySingleton<PremiumService>(() => PremiumService(sl()));
  sl.registerLazySingleton<ClientCallService>(() => ClientCallService(sl()));
  sl.registerLazySingleton<WalletService>(() => WalletService(sl()));
  sl.registerLazySingleton<PaymentService>(() => PaymentService(sl()));
  sl.registerLazySingleton<ProfileService>(() => ProfileService());
  sl.registerLazySingleton<PopupOfferService>(() => PopupOfferService());
  sl.registerLazySingleton<UserDetailsRepository>(
    () => UserDetailsRepository(),
  );
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(homeRepository: sl(), socketService: sl()),
  );
  sl.registerFactory<NavigatorCubit>(
    () => NavigatorCubit(homeBloc: sl(), historyCubit: sl(), premiumBloc: sl()),
  );
  sl.registerFactory<EmployeeNavigatorCubit>(
    () => EmployeeNavigatorCubit(employeeSessionCubit: sl()),
  );
  sl.registerFactory<SessionCubit>(() => SessionCubit(sl()));
  sl.registerLazySingleton<UserCubit>(
    () => UserCubit(
      repository: sl(),
      networkStatusCubit: sl<NetworkStatusCubit>(),
    ),
  );
  // 4) Usecases
  sl.registerFactory(() => SendOtpUsecase(sl()));
  sl.registerFactory(() => VerifyOtpUsecase(sl()));
  sl.registerFactory(() => ResendOtpUsecase(sl()));

  // 5) Cubits / Blocs

  sl.registerFactory(() => EmployeeLanguageCubit(sl()));
  sl.registerFactory(
    () => PremiumBloc(premiumService: sl(), socketService: sl()),
  );
  sl.registerFactory(() => HistoryCubit(sl()));
  sl.registerFactory(() => EmployeeCallCubit(sl()));
  sl.registerFactory(() => ClientCallCubit(sl(), sl()));
  sl.registerFactory(() => WalletCubit(sl(), sl(), sl()));
  sl.registerFactory(() => ProfileCubit(profileService: sl()));
  sl.registerFactory(() => PopupOfferCubit(sl()));
  sl.registerFactory(() => UserDetailsCubit(repository: sl()));

  // 6) Core
  sl.registerLazySingleton<NetworkChecker>(() => NetworkCheckerImpl(sl()));
  sl.registerLazySingleton(() => SocketSessionManager(sl()));
  sl.registerLazySingleton<EmployeeSessionCubit>(
    () => EmployeeSessionCubit(sl(), sl(), sl()),
  );
  sl.registerLazySingleton(() => Connectivity());
  sl.registerFactory(() => NetworkStatusCubit(sl()));
  sl.registerCachedFactory<SessionHistory>(() => SessionHistory(sl()));
}
