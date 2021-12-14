import 'package:copbayer_app/model/email_app_model.dart';
import 'package:copbayer_app/repositories/email_app_repository.dart';
import 'package:get/get.dart';

class EmailAppController extends GetxController {
  EmailAppRepository emailAppRepository = EmailAppRepository();

  final _emailApp = <EmailAppModel>[].obs;

  List<EmailAppModel> get emailApp => _emailApp;
  set emailApp(value) => this._emailApp.assignAll(value);

  void getDadosEmailApp() {
    emailAppRepository
        .getDadosEmailApp()
        .then((data) => {this._emailApp.assignAll(data)});
  }
}
