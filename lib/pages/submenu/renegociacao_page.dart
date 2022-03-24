import 'package:copbayer_app/controllers/controleApp_controller.dart';
import 'package:copbayer_app/controllers/devedor_controller.dart';
import 'package:copbayer_app/controllers/fechamento_folha_controller.dart';
import 'package:copbayer_app/controllers/saldo_capital_controller.dart';
import 'package:copbayer_app/model/fechamento_folha_model.dart';
import 'package:copbayer_app/pages/controle/fechamento_folha.dart';
import 'package:copbayer_app/pages/submenu/quitacao_page.dart';
import 'package:copbayer_app/repositories/renegociacao_repository.dart';
import 'package:copbayer_app/repositories/senha_repository.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/utils/responsive.dart';
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
  final ControleAppController _controleAppController = Get.find();
  final SenhaRepository senhaRepository = SenhaRepository();

  RenegociacaoPostRepository renegociacaoPostRepository =
      RenegociacaoPostRepository();
  int selectedRadio = 0;
  double total = 0.0;
  bool isDevedor = false;
  bool totalReceber = false;
  double saldoDevedor = 0.0;
  double saldoCapital = 0.0;
  double saldoCapitalDisp = 0.0;
  double deixarSaldo = 0.0;
  double valorDesconto = 0.0;

  double taxa = 0.0; //taxa copbayer 2%

  TextEditingController parcelasController = TextEditingController();

  int protocolo;

  @override
  void initState() {
    super.initState();

    taxa =
        double.parse(_controleAppController.controleAPP[0].taxaEmp.toString());

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

    deixarSaldo = double.parse(
        fechamentoFolhaController.fechamentoFolha[0].faixaA.toString());

    saldoCapitalDisp = saldoCapitalController.saldoCapital[0].saldo != null
        ? double.parse(saldoCapitalController.saldoCapital[0].saldo) -
            deixarSaldo
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

  double calculaDesconto(double valorFinanciado) {
    var now = DateTime.now();

    var ultimoDiaMes;
    var dataCredito = DateTime(now.year, now.month, now.day)
        .add(Duration(days: 1)); //DIA SEGUINTE
    var dataPrimeiraPrestacao;
    var fimmes = fechamentoFolhaController.fechamentoFolha[0].fimmes;

    if (fimmes == 0) {
      ultimoDiaMes = DateTime(now.year, now.month + 1, 0).day;
      dataPrimeiraPrestacao = DateTime(now.year, now.month, ultimoDiaMes);
    } else {
      ultimoDiaMes = DateTime(now.year, now.month + 2, 0).day;
      dataPrimeiraPrestacao = DateTime(now.year, now.month + 1, ultimoDiaMes);
    }

    double taxaJuros = taxa / 100;
    double saldo = valorFinanciado;
    int np = int.parse(parcelasController.text);
    double amortizacao = (saldo / np);
    double jurosTotal = 0.0;
    double j = 0.0;
    int dias = dataPrimeiraPrestacao.difference(dataCredito).inDays;

    for (int i = 1; i <= np; i++) {
      if (i == 1) {
        j = (((valorFinanciado * taxaJuros) / 30) * dias).toPrecision(2);
      } else {
        saldo = saldo - amortizacao;

        j = (saldo * taxaJuros).toPrecision(2);
      }

      jurosTotal = jurosTotal + j;
    }

    jurosTotal = (jurosTotal / np).toPrecision(2);

    return (amortizacao + jurosTotal).toPrecision(2);
  }

  handleRenegociacao() {
    valorDesconto = calculaDesconto(total);

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
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
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
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Total a pagar: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        money.formatterMoney((valorDesconto *
                            int.parse(parcelasController.text))),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
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
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Parcelas: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${parcelasController.text} x ${money.formatterMoney(valorDesconto)}",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Taxa Juros: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "$taxa%",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
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
                    title: Text("Atenção!"),
                    content: Text(
                      "Os valores podem variar de acordo com as condições da data de liberação e vencimento das prestações.",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
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
                                  future: senhaRepository
                                      .getSenha(widget.matricula),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return TextButton(
                                        onPressed: () {
                                          if (senhaController.text.compareTo(
                                                  snapshot.data[0].senha) ==
                                              0) {
                                            Future.delayed(
                                                Duration(seconds: 20));
                                            //SALVA SOLICITAÇÃO

                                            renegociacaoPostRepository
                                                .saveRenegociacao({
                                              "matricula": widget.matricula,
                                              "data": DateTime.now()
                                                  .toString()
                                                  .substring(0, 19),
                                              "usarCapital":
                                                  'S', //selectedRadio == 1 ? 'S' : 'N',
                                              "devedor": valorDesconto *
                                                  int.parse(parcelasController
                                                      .text), //selectedRadio == 1 ? total : saldoDevedor,
                                              "np": int.parse(
                                                  parcelasController.text),
                                              "parcela": valorDesconto,
                                              "numero": protocolo,
                                            });

                                            if (!Responsive.isDesktop(context))
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
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
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
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
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
                        child: Text("OK"),
                      ),
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
      total = saldoDevedor - saldoCapitalDisp;
      // });
    } else {
      //setState(() {
      if (selectedRadio == 1) {
        totalReceber = true;
      } else {
        totalReceber = false;
      }
      total = saldoCapitalDisp - saldoDevedor;
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
                        "Saldo Capital Disponível",
                        money.formatterMoney(saldoCapitalDisp),
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
                        padding: Responsive.isDesktop(context)
                            ? EdgeInsets.symmetric(
                                horizontal: alturaTela * 0.3, vertical: 20)
                            : const EdgeInsets.all(20.0),
                        child: Card(
                          elevation: 5,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  saldoDevedor <= saldoCapitalDisp
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
                      saldoDevedor <= saldoCapitalDisp
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
                      saldoDevedor <= saldoCapitalDisp
                          ? Container(
                              child: ElevatedButton.icon(
                                onPressed: () => Get.to(
                                  () =>
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
                      saldoDevedor >= saldoCapitalDisp
                          ? Container(
                              padding: Responsive.isDesktop(context)
                                  ? EdgeInsets.symmetric(
                                      horizontal: alturaTela * 0.3)
                                  : const EdgeInsets.symmetric(horizontal: 20),
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

                      saldoDevedor >= saldoCapitalDisp
                          ? Container(
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              height: alturaTela * 0.055, //45,
                              width: MediaQuery.of(context).size.width * 0.73,
                              padding: Responsive.isDesktop(context)
                                  ? EdgeInsets.symmetric(
                                      horizontal: alturaTela * 0.5)
                                  : EdgeInsets.zero,
                              child: ElevatedButton(
                                onPressed: handleRenegociacao,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: BorderSide(color: Colors.green[300]),
                                  ),
                                ),
                                child: FittedBox(
                                  child: Text(
                                    "Solicitar Renegociação",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: alturaTela * 0.025,
                                        fontWeight: FontWeight.w500),
                                  ),
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
