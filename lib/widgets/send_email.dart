import 'package:copbayer_app/model/associado_model.dart';
import 'package:copbayer_app/repositories/associado_repository.dart';
import 'package:copbayer_app/utils/email.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:get/get.dart';

class SendEmail extends StatefulWidget {
  final String cpf;
  final String dataNasc;

  const SendEmail({
    Key key,
    this.cpf,
    this.dataNasc,
  }) : super(key: key);

  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  AssociadoRepository associadoRepository = AssociadoRepository();
  Future<List<AssociadoModel>> assocInfo;

  var email = Email('appbasicline@gmail.com', 'Rbline87105');

  void _sendEmail({String nome, int matricula}) async {
    var data = formatDate(
        DateTime.now(), [dd, '/', mm, '/', yyyy, ' às ', HH, ':', nn]);

    //TROCAR E-MAIL!!!
    //rogerio.barradas@basicline.com.br

    bool result = await email.sendMessage(
        ' NOME DO CLIENTE: COPBAYER\n MATRÍCULA: $matricula \n CPF = ${widget.cpf} \n NOME: $nome \n DATA DA SOLICITAÇÃO: $data',
        'contato@copbayer.com.br',
        'APP Copbayer: SOLICITAÇÃO DE NOVA SENHA.');

    print("resultado = $result");
  }

  @override
  void initState() {
    super.initState();

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
                  _sendEmail(
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
