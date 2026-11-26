import 'package:eatik_app/core/error/result.dart';
import 'package:eatik_app/features/menu/domain/repositories/menu_repository.dart';

class DeleteMenu {
  const DeleteMenu(this._repository);

  final MenuRepository _repository;

  Future<Result<void>> call(int id) => _repository.deleteMenu(id);
}
