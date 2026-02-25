import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Result<UserEntity>> login(String phone) async {
    try {
      final result = await remote.login(phone);

      return Result.success(UserEntity(token: result.accessToken));
    } on ServerException catch (e) {
      return Result.error(ServerFailure(e.message));
    } catch (e) {
      return Result.error(const ServerFailure("Unexpected error"));
    }
  }
}
