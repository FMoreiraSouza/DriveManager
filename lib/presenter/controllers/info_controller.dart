import 'package:get_storage/get_storage.dart';

class InfoController {
  final GetStorage _box;

  // Construtor que recebe o GetStorage
  InfoController(this._box);

  // Obtém o nome do usuário armazenado
  String getUserName() {
    return _box.read('user_name') ??
        'Usuário'; // Retorna o nome do usuário ou 'Usuário' se não encontrado
  }
}
