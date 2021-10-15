import 'package:copbayer_app/model/controle_model.dart';
import 'package:copbayer_app/repositories/controle_repository.dart';
import 'package:get/get.dart';

class ControleAppController extends GetxController {
  ControleRepository controleRepository = ControleRepository();

  final _controleAPP = <ControleModel>[].obs;

  List<ControleModel> get controleAPP => _controleAPP;
  set controleAPP(value) => this._controleAPP.assignAll(value);

  void getControleInfos() {
    controleRepository
        .getInfosControle()
        .then((data) => {this._controleAPP.assignAll(data)});
  }
}
