import 'package:copbayer_app/controllers/controleApp_controller.dart';
import 'package:copbayer_app/model/login_model.dart';
import 'package:copbayer_app/pages/controle/manutencao_page.dart';
import 'package:copbayer_app/pages/home_page.dart';
import 'package:copbayer_app/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthPage extends StatefulWidget {
  final String cpf;
  final String senha;
  const AuthPage({Key key, this.cpf, this.senha}) : super(key: key);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<List<LoginModel>> loginAuth;
  LoginRepository _repositorLogin;

  final ControleAppController controleAppController =
      Get.put(ControleAppController());

  String convertCPF() {
    String cpf = widget.cpf.replaceAll('.', '').replaceAll('-', '');
    return cpf;
  }

  @override
  void initState() {
    super.initState();

    var cpfConvert = convertCPF();

    _repositorLogin = LoginRepository();
    loginAuth = _repositorLogin.login(cpfConvert, widget.senha);

    controleAppController.getControleInfos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loginAuth,
        builder:
            (BuildContext context, AsyncSnapshot<List<LoginModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                // width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                color: Colors.white,
                child: Image.asset(
                  "images/logo.png",
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              );
              break;
            default:
              if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
                return _showAlertDialog(context);
              } else {
                if (snapshot.data.isEmpty) {
                  return _showAlertDialog(context);
                } else {
                  return GetX<ControleAppController>(
                    builder: (_) {
                      /// VERIFICA SE A INTEGRAÇÃO ESTÁ SENDO FEITA!!!
                      return _.controleAPP.length < 1
                          ? Container(
                              color: Colors.white,
                              child: CircularProgressIndicator())
                          : _.controleAPP[0].iNTEGRACAO != 1
                              ? HomePage(
                                  matricula:
                                      snapshot.data[0].matricula.toString(),
                                  nome: snapshot.data[0].nome,
                                  dataAssociacao: snapshot.data[0].associado,
                                  opCapitalizacao: snapshot.data[0].tipodesc,
                                  cpf: snapshot.data[0].cpf,
                                  situacao: snapshot.data[0].situacao,
                                )
                              : ManutencaoPage();
                    },
                  );

                  // SAVE LOG APP
                  /* _logAppRepository.saveLog({
                    "usuario": snapshot.data[0].matricula,
                    "datahora": DateTime.now().toString().substring(0, 23),
                    "modulo": "Início Sessão",
                  });

                  return HomePage(
                    matricula: snapshot.data[0].matricula.toString(),
                    nome: snapshot.data[0].nome,
                    dataAssociacao: snapshot.data[0].associado,
                    opCapitalizacao: snapshot.data[0].tipodesc,
                    cpf: snapshot.data[0].cpf,
                    situacao: snapshot.data[0].situacao,
                  );*/
                }
              }
          }
        },
      ),
    );
  }
}

Widget _showAlertDialog(BuildContext context) {
  return Center(
      child: AlertDialog(
    title: Text("Não foi possível realizar o login"),
    content: Text("Confira seus dados e tente novamente."),
    actions: [
      TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  ));
}
