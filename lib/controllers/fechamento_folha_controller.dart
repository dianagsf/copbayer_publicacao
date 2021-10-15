import 'package:copbayer_app/model/fechamento_folha_model.dart';
import 'package:copbayer_app/repositories/fechamento_folha_repository.dart';
import 'package:get/get.dart';

class FechamentoFolhaController extends GetxController {
  FechamentoFolhaRepository fechamentoFolhaRepository =
      FechamentoFolhaRepository();

  final _fechamentoFolha = <FechamentoFolhaModel>[].obs;

  List<FechamentoFolhaModel> get fechamentoFolha => _fechamentoFolha;
  set fechamentoFolha(value) => this._fechamentoFolha.assignAll(value);

  void getFechamento() {
    fechamentoFolhaRepository
        .getDatasFechamento()
        .then((data) => {this._fechamentoFolha.assignAll(data)});
  }
}
