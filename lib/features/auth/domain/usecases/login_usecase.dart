import '../../../../core/utils/result.dart';
import '../../../../core/utils/validators.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Result<UserEntity>> call(String phone) async {
    Validators.validatePhone(phone);
    return await repository.login(phone);
  }
}
