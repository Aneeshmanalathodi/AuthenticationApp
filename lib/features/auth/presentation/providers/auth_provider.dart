import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../injection.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> login(String phone) async {
    state = const AsyncValue.loading();

    try {
      final dio = ref.read(dioProvider);
      final prefs = ref.read(sharedPreferencesProvider);

      final dataSource = AuthRemoteDataSourceImpl(dio);
      final repository = AuthRepositoryImpl(dataSource);
      final useCase = LoginUseCase(repository);

      final result = await useCase(phone);

      if (result.isSuccess) {
        await prefs.setString(AppConstants.tokenKey, result.data!.token);

        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(result.failure!.message, StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
