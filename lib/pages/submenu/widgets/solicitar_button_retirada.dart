import 'dart:async';

import 'package:copbayer_app/controllers/faixa_capital_controller.dart';
import 'package:copbayer_app/controllers/proposta_controller.dart';
import 'package:copbayer_app/controllers/retirada_capital_controller.dart';
import 'package:copbayer_app/controllers/saldo_capital_controller.dart';
import 'package:copbayer_app/repositories/senha_repository.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SolicitarButtonRetirada extends StatelessWidget {
  //final Function handleSolicitar;
  final int matricula;

  SolicitarButtonRetirada({this.matricula});

  final TextEditingController controller = TextEditingController();
  final SenhaRepository senhaRepository = SenhaRepository();

  final SaldoCapitalController saldoCapitalController = Get.find();
  final FaixaCapitalController faixaCapitalController = Get.find();
  final PropostaController propostaController = Get.find();

  final RetiradaCapitalController retiradaCapitalController =
      Get.put(RetiradaCapitalController());

  showSenhaDialog(double valorArredondado) {
    return Get.dialog(
      AlertDialog(
        title: Text("Confirme sua senha"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          FutureBuilder(
            future: senhaRepository.getSenha(matricula),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TextButton(
                  onPressed: () {
                    if (controller.text.compareTo(snapshot.data[0].senha) ==
                        0) {
                      Future.delayed(Duration(seconds: 20));
                      // VOLTAR PRA HOME
                      Get.back();
                      Get.back();
                      Get.back();

                      Get.snackbar(
                        "Sua solicitação está sendo analisada!",
                        "Em breve entraremos em contato.",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        padding: EdgeInsets.all(30),
                        snackPosition: SnackPosition.BOTTOM,
                        duration: Duration(seconds: 4),
                      );

                      retiradaCapitalController.saveRetiradaCapital(
                        matricula,
                        valorArredondado,
                      );
                    } else {
                      Get.back();

                      Get.snackbar(
                        "Senha incorreta!",
                        "Tente novamente.",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        padding: EdgeInsets.all(30),
                        snackPosition: SnackPosition.BOTTOM,
                        duration: Duration(seconds: 4),
                      );

                      controller.text = '';
                    }
                  },
                  child: Text("CONFIRMAR"),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  double arredondaValor(double valorRetirada) {
    var valorArredondado =
        ((valorRetirada - faixaCapitalController.faixaCapital[0].valor) / 10)
                .floorToDouble() *
            10;

    return valorArredondado;
  }

  handleRetirada() {
    FormatMoney money = FormatMoney();
    var valorRetirada = retiradaCapitalController.controllerValor.text;

    double valor =
        double.parse(valorRetirada.replaceAll('.', "").replaceAll(',', '.'));
    double saldo = double.parse(saldoCapitalController.saldoCapital[0].saldo);

    double valorArredondado = arredondaValor(valor);
    print("valor arredondado = $valorArredondado");

    if (valor < 300.0) {
      Get.dialog(AlertDialog(
        title: Text(
          "Atenção!",
          style: TextStyle(fontSize: 22),
        ),
        content: Text(
          "Você solicitou a retirada de um valor menor do que o permitido! O mínimo de retirada é de R\$ 300,00. Sua solicitação foi negada.",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ));
    }

    if (saldo - valorArredondado < 48) {
      Get.dialog(AlertDialog(
        title: Text(
          "Atenção!",
          style: TextStyle(fontSize: 22),
        ),
        content: Text(
          "Você solicitou a retirada de um valor maior do que o permitido!. Sua solicitação foi negada.",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ));
    }
    if (propostaController.propostas.length != 0) {
      var qtdEmprestimos = propostaController.propostas.length;
      return Get.dialog(
        AlertDialog(
          title: Text(
            "Atenção!",
            style: TextStyle(fontSize: 22),
          ),
          content: Text(
            "Você já possui $qtdEmprestimos empréstimo(s) em curso. Sua solicitação foi negada.",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
                Get.back();

                //showSenhaDialog();
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      );
    }
    if (valor > 300 &&
        (saldo - valorArredondado > 48) &&
        propostaController.propostas.length == 0) {
      Get.dialog(AlertDialog(
        title: Text(
          "Atenção!",
          style: TextStyle(fontSize: 22),
        ),
        content: Text(
          "O valor de resgate permitido será de ${money.formatterMoney(valorArredondado)}.",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
                showSenhaDialog(valorArredondado);
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return SizedBox(
      height: alturaTela * 0.055, //45,
      width: MediaQuery.of(context).size.width * 0.73,
      child: ElevatedButton(
        onPressed: () {
          handleRetirada();
          /*return Get.dialog(
            AlertDialog(
              title: Text("Confirme sua senha"),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                FutureBuilder(
                  future: senhaRepository.getSenha(matricula),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return FlatButton(
                        onPressed: () {
                          if (controller.text
                                  .compareTo(snapshot.data[0].senha) ==
                              0) {
                            Future.delayed(Duration(seconds: 20));
                            // VOLTAR PRA HOME
                            Get.back();
                            Get.back();
                            Get.back();

                            Get.snackbar(
                              "Sua solicitação está sendo analisada!",
                              "Em breve entraremos em contato.",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              padding: EdgeInsets.all(30),
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 4),
                            );

                            if (handleSolicitar != null) handleSolicitar();
                          } else {
                            Get.back();

                            Get.snackbar(
                              "Senha incorreta!",
                              "Tente novamente.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              padding: EdgeInsets.all(30),
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 4),
                            );
                          }
                        },
                        child: Text("CONFIRMAR"),
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
          );*/
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.green[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: BorderSide(color: Colors.green[300]),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "SOLICITAR",
            style: TextStyle(
                color: Colors.white,
                fontSize: alturaTela * 0.025,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
