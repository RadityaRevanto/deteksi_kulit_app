import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/network/api_client.dart';
import '../core/theme/app_theme.dart';

import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';

import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';

import '../features/auth/presentation/bloc/auth/auth_bloc.dart';

import 'bloc/navigation/navigation_bloc.dart';
import 'routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>(
          create: (_) => ApiClientImpl(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(
              apiClient: context.read<ApiClient>(),
            ),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationBloc()),

          BlocProvider(
            create: (context) => AuthBloc(
              loginUseCase: LoginUseCase(context.read<AuthRepository>()),
              registerUseCase: RegisterUseCase(context.read<AuthRepository>()),
            ),
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
