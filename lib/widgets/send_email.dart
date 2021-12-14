import 'package:copbayer_app/model/associado_model.dart';
import 'package:copbayer_app/repositories/associado_repository.dart';
import 'package:copbayer_app/repositories/enviar_email_web_repository.dart';
import 'package:copbayer_app/utils/email.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // verifica se tá na WEB

class SendEmail extends StatefulWidget {
  final String cpf;
  final String dataNasc;
  final String emailApp;
  final String senhaEmailApp;

  const SendEmail({
    Key key,
    this.cpf,
    this.dataNasc,
    @required this.emailApp,
    @required this.senhaEmailApp,
  }) : super(key: key);

  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  AssociadoRepository associadoRepository = AssociadoRepository();
  Future<List<AssociadoModel>> assocInfo;

  EnviarEmailWebRepository enviarEmailWebRepository =
      EnviarEmailWebRepository();

  //var email = Email('app@basiclinesistemas.com.br', 'Rbline@87105');
  var email;

  void _sendEmail({String nome, int matricula}) async {
    var data = formatDate(
        DateTime.now(), [dd, '/', mm, '/', yyyy, ' às ', HH, ':', nn]);

    //TROCAR E-MAIL!!!
    //contato@copbayer.com.br

    bool result = await email.sendMessage(
        ' NOME DO CLIENTE: COPBAYER\n MATRÍCULA: $matricula \n CPF = ${widget.cpf} \n NOME: $nome \n DATA DA SOLICITAÇÃO: $data',
        'contato@copbayer.com.br',
        'APP Copbayer: SOLICITAÇÃO DE NOVA SENHA.');

    print("resultado = $result");
  }

  void enviarEmailSenhaWeb({
    String matricula,
    String nome,
  }) {
    print("E-MAIL SENHA WEB !!!!!");
    var data = formatDate(
        DateTime.now(), [dd, '/', mm, '/', yyyy, ' às ', HH, ':', nn]);

    enviarEmailWebRepository.enviarEmailSenhaWeb({
      "matricula": matricula,
      "cpf": widget.cpf,
      "nome": nome.toUpperCase(),
      "data": data,
    });
  }

  @override
  void initState() {
    super.initState();

    print("email = ${widget.emailApp} // senha = ${widget.senhaEmailApp}");

    email = Email(widget.emailApp, widget.senhaEmailApp);

    var cpf = widget.cpf.replaceAll('.', '').replaceAll('-', '');
    var data = widget.dataNasc.split('/');
    var dataNasc = "${data[2]}-${data[1]}-${data[0]}";
    print("cpf = $cpf //// data = $dataNasc");
    assocInfo = associadoRepository.getInfosAssocSenha(cpf, dataNasc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: assocInfo,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container();
              break;
            default:
              if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
                //Get.back();

                return _showAlertDialog(context);
              } else {
                if (snapshot.data.isEmpty) {
                  //Get.back();

                  return _showAlertDialog(context);
                } else {
                  kIsWeb // verifica se tá rodando na WEB
                      ? enviarEmailSenhaWeb(
                          matricula: snapshot.data[0].matricula.toString(),
                          nome: snapshot.data[0].nome,
                        )
                      : _sendEmail(
                          nome: snapshot.data[0].nome,
                          matricula: snapshot.data[0].matricula,
                        );
                  return AlertDialog(
                    title: Text(
                      "Sua solicitação de alteração de senha foi enviada.",
                    ),
                    content: Text("Em breve entraremos em contato."),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                      ),
                    ],
                  );
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
    title: Text("Usuário inválido!"),
    content: Text("Confira seus dados e tente novamente."),
    actions: [
      TextButton(
        child: Text("OK"),
        onPressed: () {
          Get.back();
          Get.back();
        },
      ),
    ],
  ));
}
