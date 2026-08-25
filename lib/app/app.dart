import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';
import '../core/theme/app_theme.dart';

import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';

import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';

import '../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth/auth_event.dart';

import 'bloc/navigation/navigation_bloc.dart';
import 'routes/app_router.dart';

class App extends StatelessWidget {
  final SharedPreferences prefs;

  const App({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthLocalDataSource>(
          create: (_) => AuthLocalDataSourceImpl(prefs: prefs),
        ),
        RepositoryProvider<ApiClient>(
          create: (context) => ApiClientImpl(
            tokenGetter: () => context.read<AuthLocalDataSource>().getToken(),
          ),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(
              apiClient: context.read<ApiClient>(),
            ),
            localDataSource: context.read<AuthLocalDataSource>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationBloc()),

          BlocProvider(
            create: (context) {
              final authRepo = context.read<AuthRepository>();
              return AuthBloc(
                loginUseCase: LoginUseCase(authRepo),
                registerUseCase: RegisterUseCase(authRepo),
                logoutUseCase: LogoutUseCase(authRepo),
                checkAuthStatusUseCase: CheckAuthStatusUseCase(authRepo),
              )..add(AuthCheckRequested());
            },
          ),
        ],
        child: MaterialApp.router(
          title: 'Skin Detection',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
