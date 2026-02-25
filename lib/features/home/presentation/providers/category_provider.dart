import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';

final categoryProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final dio = ref.watch(dioProvider);

  final dataSource = HomeRemoteDataSourceImpl(dio);
  final repository = HomeRepositoryImpl(dataSource);
  final usecase = GetCategoriesUseCase(repository);

  return await usecase();
});
