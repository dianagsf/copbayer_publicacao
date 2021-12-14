import 'package:copbayer_app/pages/submenu/alteracao_capital_page.dart';
import 'package:copbayer_app/pages/submenu/desligamento_page.dart';
import 'package:copbayer_app/pages/submenu/pessoa_exposta_page.dart';
import 'package:copbayer_app/pages/submenu/quitacao_page.dart';
import 'package:copbayer_app/pages/submenu/renegociacao_page.dart';
import 'package:copbayer_app/pages/submenu/retirada_capital_page.dart';
import 'package:copbayer_app/repositories/log_app_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Item Menu
Widget buildItemList(
  BuildContext context,
  Icon icon,
  String text,
  Widget page, {
  bool solicitacoes,
  int matricula,
  String nome,
  String data,
  String opCapitalizacao,
  String cpf,
  String situacao,
}) {
  if (solicitacoes) {
    return ExpansionTile(
      leading: icon,
      title: Text(text),
      children: [
        buildSubMenu("SOLICITAÇÕES REALIZADAS", page),
        buildSubMenu(
            "ALTERAÇÃO DE CAPITAL",
            AlteracaoCapitalPage(
              matricula: matricula,
              opCapitalizacao: opCapitalizacao,
              situacao: situacao,
            )),
        buildSubMenu(
            "RESGATE DE CAPITAL", RetiradaCapital(matricula: matricula)),
        buildSubMenu(
            "PEDIDO DE DESLIGAMENTO",
            DesligamentoPage(
              matricula: matricula,
              nome: nome,
              data: data,
            )),
        buildSubMenu("RENEGOCIAÇÃO", RenegociacaoPage(matricula: matricula)),
        buildSubMenu("PEDIDO DE QUITAÇÃO", QuitacaoPage(matricula: matricula)),
        buildSubMenu(
            "PESSOA EXPOSTA",
            PessoaExpostaPage(
              nome: nome,
              cpf: cpf,
              matricula: matricula,
            ))
      ],
    );
  }

  return ListTile(
    leading: icon,
    title: Text(text),
    onTap: () {
      if (text.compareTo("SAIR") == 0) {
        LogAppRepository _logAppRepository = LogAppRepository();

        /// SAVE LOG APP
        _logAppRepository.saveLog({
          "usuario": matricula,
          "datahora": DateTime.now().toString().substring(0, 23),
          "modulo": "Fim Sessão",
        });
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    },
  );
}

Widget buildSubMenu(String text, Widget page) {
  return Padding(
    padding: EdgeInsets.only(left: 15),
    child: ListTile(
      leading: Icon(Icons.arrow_forward),
      title: Text(text),
      onTap: () {
        Get.to(() => page);
      },
    ),
  );
}
