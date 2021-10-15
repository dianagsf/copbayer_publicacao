import 'package:copbayer_app/model/solic_pendentes_model.dart';
import 'package:copbayer_app/repositories/solicitacoes_pendentes_repository.dart';
import 'package:get/get.dart';

class SolicPendentesController extends GetxController {
  SolicPendentesRepository solicitacoesPendentesRepository =
      SolicPendentesRepository();

  final _solicPendentes = <SolicPendentesModel>[].obs;

  List<SolicPendentesModel> get solicPendentes => _solicPendentes;
  set solicPendentes(value) => this._solicPendentes.assignAll(value);

  void getSolicPendentes(int matricula) {
    solicitacoesPendentesRepository
        .findAll(matricula)
        .then((data) => {this._solicPendentes.assignAll(data)});
  }
}
