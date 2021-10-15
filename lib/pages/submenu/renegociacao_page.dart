import 'package:copbayer_app/controllers/devedor_controller.dart';
import 'package:copbayer_app/controllers/fechamento_folha_controller.dart';
import 'package:copbayer_app/controllers/saldo_capital_controller.dart';
import 'package:copbayer_app/model/fechamento_folha_model.dart';
import 'package:copbayer_app/pages/controle/fechamento_folha.dart';
import 'package:copbayer_app/pages/submenu/quitacao_page.dart';
import 'package:copbayer_app/repositories/renegociacao_repository.dart';
import 'package:copbayer_app/repositories/senha_repository.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/widgets/table/propostas.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RenegociacaoPage extends StatefulWidget {
  final int matricula;

  const RenegociacaoPage({Key key, this.matricula}) : super(key: key);
  @override
  _RenegociacaoPageState createState() => _RenegociacaoPageState();
}

class _RenegociacaoPageState extends State<RenegociacaoPage> {
  FormatMoney money = FormatMoney();
  final ScrollController _scrollController = ScrollController();
  final SaldoCapitalController saldoCapitalController = Get.find();
  final SaldoDevedorController saldoDevedorController = Get.find();
  final TextEditingController senhaController = TextEditingController();

  final FechamentoFolhaController fechamentoFolhaController = Get.find();
  final SenhaRepository senhaRepository = SenhaRepository();

  RenegociacaoPostRepository renegociacaoPostRepository =
      RenegociacaoPostRepository();
  int selectedRadio = 0;
  double total = 0.0;
  bool isDevedor = false;
  bool totalReceber = false;
  double saldoDevedor = 0.0;
  double saldoCapital = 0.0;
  TextEditingController parcelasController = TextEditingController();

  int protocolo;

  @override
  void initState() {
    super.initState();

    if (saldoDevedorController.saldoDevedor[0].devedor != null) {
      isDevedor = true;
    } else {
      isDevedor = false;
    }

    saldoDevedor = saldoDevedorController.saldoDevedor[0].devedor != null
        ? double.parse(
            saldoDevedorController.saldoDevedor[0].devedor.toString())
        : 0.0;
    saldoCapital = saldoCapitalController.saldoCapital[0].saldo != null
        ? double.parse(saldoCapitalController.saldoCapital[0].saldo)
        : 0.0;

    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  handleRenegociacao() {
    /*if (selectedRadio == 0) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Informe se deseja usar o saldo devedor para renegociação.",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'OK',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      );
    }*/
    if (parcelasController.text.isBlank) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Informe o número de parcelas para renegociação.",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'OK',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      );
    }
    if (!parcelasController.text.isBlank) {
      Get.dialog(
        AlertDialog(
          title: Text("Informações sobre a renegociação"),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      "Uso do saldo capital: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Sim",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Total a pagar: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      money.formatterMoney(total),
                      /* selectedRadio == 1
                          ? money.formatterMoney(total)
                          : money.formatterMoney(saldoDevedor),*/
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Número de parcelas: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${parcelasController.text}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Parcelas: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${parcelasController.text} x ${selectedRadio == 1 ? money.formatterMoney(total / int.parse(parcelasController.text)) : money.formatterMoney(saldoDevedor / int.parse(parcelasController.text))}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'CANCELAR',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: Text("Confirme sua senha"),
                    content: TextField(
                      controller: senhaController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      FutureBuilder(
                        future: senhaRepository.getSenha(widget.matricula),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return TextButton(
                              onPressed: () {
                                if (senhaController.text
                                        .compareTo(snapshot.data[0].senha) ==
                                    0) {
                                  Future.delayed(Duration(seconds: 20));
                                  //SALVA SOLICITAÇÃO

                                  renegociacaoPostRepository.saveRenegociacao({
                                    "matricula": widget.matricula,
                                    "data": DateTime.now()
                                        .toString()
                                        .substring(0, 19),
                                    "usarCapital":
                                        'S', //selectedRadio == 1 ? 'S' : 'N',
                                    "devedor":
                                        total, //selectedRadio == 1 ? total : saldoDevedor,
                                    "np": int.parse(parcelasController.text),
                                    "parcela": saldoDevedor /
                                        int.parse(parcelasController.text),
                                    "numero": protocolo,
                                  });

                                  Get.back();
                                  Get.back();
                                  Get.back();
                                  Get.back();
                                  Get.snackbar(
                                    "Sua solicitação foi enviada com sucesso!",
                                    "Em breve entraremos em contato.",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    padding: EdgeInsets.all(30),
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: Duration(seconds: 4),
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

                                  setState(() {
                                    senhaController.text = '';
                                  });
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
              },
              child: Text(
                'CONFIRMAR',
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      );
    }
  }

  String calculaTotalQuitacao() {
    if (saldoDevedor > saldoCapital) {
      // setState(() {
      total = saldoDevedor - (saldoCapital - 48.0);
      // });
    } else {
      //setState(() {
      if (selectedRadio == 1) {
        totalReceber = true;
      } else {
        totalReceber = false;
      }
      total = (saldoCapital - 48.0) - saldoDevedor;
      //});
    }

    return money.formatterMoney(total);
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return GetX<FechamentoFolhaController>(
      builder: (_) {
        return handleFechamentoFolha(_.fechamentoFolha)
            ? FechamentoFolhaPage()
            : Scaffold(
                appBar: AppBar(
                  title: Text("Renegociação de Empréstimos"),
                  backgroundColor: Colors.green[300],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          "Empréstimos em Vigor",
                          style: TextStyle(
                            color: Colors.green[400],
                            fontSize: alturaTela * 0.027, //24.0 : 22.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Scrollbar(
                        isAlwaysShown: true,
                        thickness: 3,
                        controller: _scrollController,
                        radius: Radius.circular(40),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: Propostas(
                            matricula: widget.matricula,
                            money: money,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      buildCardInfo(
                        Icons.attach_money,
                        "Saldo Capital",
                        money.formatterMoney(
                          double.parse(
                              saldoCapitalController.saldoCapital[0].saldo),
                        ),
                        Colors.blue,
                        alturaTela,
                      ),
                      buildCardInfo(
                        Icons.money_off,
                        "Saldo Devedor",
                        saldoDevedorController.saldoDevedor[0].devedor != null
                            ? money.formatterMoney(double.parse(
                                saldoDevedorController.saldoDevedor[0].devedor
                                    .toString()))
                            : 'R\$ 0,00',
                        Colors.red[400],
                        alturaTela,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Card(
                          elevation: 5,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  saldoDevedor <= saldoCapital - 48.0
                                      ? "Total"
                                      : "Total a pagar",
                                  style: TextStyle(
                                    fontSize: alturaTela * 0.022,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  isDevedor
                                      ? calculaTotalQuitacao()
                                      : 'R\$ 0,00',
                                  /* selectedRadio == 1
                                      ? isDevedor
                                          ? calculaTotalQuitacao()
                                          : 'R\$ 0,00'
                                      : saldoDevedorController
                                                  .saldoDevedor[0].devedor !=
                                              null
                                          ? money.formatterMoney(double.parse(
                                              saldoDevedorController
                                                  .saldoDevedor[0].devedor
                                                  .toString()))
                                          : 'R\$ 0,00',*/
                                  style: TextStyle(
                                    fontSize: alturaTela * 0.022,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      saldoDevedor <= saldoCapital - 48.0
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Text(
                                "Seu saldo devedor é menor do que seu saldo de capital. Nesse caso, não é possível realizar a renegociação. Mas você pode realizar a quitação dos seus contratos com o saldo de capital.",
                                style: TextStyle(
                                  fontSize: alturaTela * 0.022,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      saldoDevedor <= saldoCapital - 48.0
                          ? Container(
                              child: ElevatedButton.icon(
                                onPressed: () => Get.to(() => 
                                  QuitacaoPage(matricula: widget.matricula),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                icon: Icon(Icons.arrow_forward),
                                label: Text(
                                  'Ir para quitação',
                                  style: TextStyle(
                                    fontSize: alturaTela * 0.02,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      saldoDevedor >= saldoCapital - 48.0
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Informe o número de parcelas:",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: TextField(
                                      controller: parcelasController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      const SizedBox(height: 40),
                      /*saldoDevedor >= saldoCapital - 48.0
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                "Deseja usar o saldo capital para quitação do saldo devedor?",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 20,
                      ),
                      saldoDevedor >= saldoCapital - 48.0
                          ? Row(
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    value: 1,
                                    groupValue: selectedRadio,
                                    title: Text("SIM"),
                                    activeColor: Colors.blue[700],
                                    onChanged: (value) {
                                      setSelectedRadio(value);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    value: 2,
                                    groupValue: selectedRadio,
                                    title: Text("NÃO"),
                                    activeColor: Colors.blue[700],
                                    onChanged: (value) {
                                      setSelectedRadio(value);
                                    },
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      const SizedBox(height: 20),*/
                      /*isDevedor && selectedRadio == 2
                  ? InfosDevedor(
                      matricula: widget.matricula,
                      protocolo: protocolo,
                      quitacaoPage: false,
                      valor: selectedRadio == 1
                          ? isDevedor
                              ? calculaTotalQuitacao()
                              : 'R\$ 0,00'
                          : saldoDevedorController.saldoDevedor[0].devedor != null
                              ? money.formatterMoney(double.parse(
                                  saldoDevedorController.saldoDevedor[0].devedor
                                      .toString()))
                              : 'R\$ 0,00',
                      saldoDevedor: money.formatterMoney(
                        double.parse(
                          saldoDevedorController.saldoDevedor[0].devedor
                              .toString(),
                        ),
                      ),
                      usarCapital: selectedRadio == 1 ? 'S' : 'N',
                    )
                  : */
                      saldoDevedor >= saldoCapital - 48.0
                          ? Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              height: alturaTela * 0.055, //45,
                              width: MediaQuery.of(context).size.width * 0.73,
                              child: ElevatedButton(
                                onPressed: handleRenegociacao,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: BorderSide(color: Colors.green[300]),
                                  ),
                                ),
                                child: Text(
                                  "Solicitar Renegociação",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: alturaTela * 0.025,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                ),
              );
      },
    );
  }
}

Widget buildCardInfo(
  IconData icon,
  String text,
  String value,
  Color color,
  double alturaTela,
) {
  return Container(
    padding: const EdgeInsets.all(10),
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 45.0,
          width: 45.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(
              Radius.circular(60.0),
            ),
          ),
          child: Icon(
            icon,
            size: 25.0,
            color: Colors.white,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: alturaTela * 0.022,
          ),
        ),
        FittedBox(
          child: Text(
            value,
            style: TextStyle(
              fontSize: alturaTela * 0.022,
            ),
          ),
        ),
      ],
    ),
  );
}

bool handleFechamentoFolha(List<FechamentoFolhaModel> fechamentoFolha) {
  if (fechamentoFolha[0].fimmes == 1) {
    return true;
  }

  return false;
}
