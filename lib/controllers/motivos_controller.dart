import 'package:copbayer_app/model/motivos_desligamento_model.dart';
import 'package:copbayer_app/repositories/motivos_repository.dart';
import 'package:get/get.dart';

class MotivosController extends GetxController {
  MotivosRepository motivosRepository = MotivosRepository();

  final _motivos = <MotivosModel>[].obs;

  List<MotivosModel> get motivos => _motivos;
  set motivos(value) => this._motivos.assignAll(value);

  void getMotivosDesligamento() {
    motivosRepository
        .getMotivos()
        .then((data) => {this._motivos.assignAll(data)});
  }
}
