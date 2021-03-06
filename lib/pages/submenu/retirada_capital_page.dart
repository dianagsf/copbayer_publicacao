import 'package:copbayer_app/controllers/data_controller.dart';
import 'package:copbayer_app/controllers/faixa_capital_controller.dart';
import 'package:copbayer_app/controllers/fechamento_folha_controller.dart';
import 'package:copbayer_app/controllers/retirada_capital_controller.dart';
import 'package:copbayer_app/controllers/saldo_capital_controller.dart';
import 'package:copbayer_app/model/data_model.dart';
import 'package:copbayer_app/model/fechamento_folha_model.dart';
import 'package:copbayer_app/pages/controle/limite_solic_page.dart';
import 'package:copbayer_app/pages/submenu/widgets/solicitar_button_retirada.dart';
import 'package:copbayer_app/repositories/devedor_repository.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';

class RetiradaCapital extends StatefulWidget {
  final int matricula;

  RetiradaCapital({this.matricula});

  @override
  _RetiradaCapitalState createState() => _RetiradaCapitalState();
}

class _RetiradaCapitalState extends State<RetiradaCapital> {
  final SaldoCapitalController saldoCapitalController = Get.find();
  final FaixaCapitalController faixaCapitalController = Get.find();
  final FechamentoFolhaController fechamentoFolhaController = Get.find();

  final RetiradaCapitalController retiradaCapitalController =
      Get.put(RetiradaCapitalController());

  final SaldoDevedorRepository saldoDevedorRepository =
      SaldoDevedorRepository();

  double saldoCapitalDisp = 0.0;
  double deixarSaldo = 0.0;

  FormatMoney money = FormatMoney();

  final DataController dataController = Get.find();

  String dataHoje = DateTime.now().toString().substring(0, 10);
  var datasSolic;
  bool limite;

  @override
  void initState() {
    super.initState();

    deixarSaldo = double.parse(
        fechamentoFolhaController.fechamentoFolha[0].faixaA.toString());

    saldoCapitalDisp = saldoCapitalController.saldoCapital[0].saldo != null
        ? double.parse(saldoCapitalController.saldoCapital[0].saldo) -
            deixarSaldo
        : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return GetX<DataController>(
      initState: (state) {
        dataController.getDatasRetiradaCapital(widget.matricula);
      },
      builder: (_) {
        return handleLimiteSolic(_.datasRetiradaCapital)
            ? LimiteSolicPage(operacao: "retirada de capital")
            : Scaffold(
                appBar: AppBar(
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Retirada de Capital",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  backgroundColor: Colors.green[300],
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        buildCardSaldo(
                          saldoCapitalController,
                          money,
                          alturaTela,
                          context,
                          saldoCapitalDisp,
                        ),
                        SizedBox(
                          height: alturaTela * 0.11, //90,
                        ),
                        Text(
                          "Valor para Retirada",
                          style: TextStyle(fontSize: alturaTela * 0.025),
                        ),
                        SizedBox(
                          height: alturaTela * 0.025, //20,
                        ),
                        buildInput(retiradaCapitalController.controllerValor,
                            alturaTela),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          width: alturaTela * 0.37,
                          child: Text.rich(
                            TextSpan(
                              text: "Aten????o: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "A devolu????o do capital ocorrer?? no dia 10 do pr??ximo m??s.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: alturaTela * 0.12,
                        ),
                        Container(
                          padding: Responsive.isDesktop(context)
                              ? EdgeInsets.symmetric(
                                  horizontal: alturaTela * 0.8)
                              : EdgeInsets.only(left: 50, right: 50),
                          child: SolicitarButtonRetirada(
                            matricula: widget.matricula,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

Widget buildCardSaldo(
  SaldoCapitalController saldoCapitalController,
  FormatMoney money,
  double alturaTela,
  BuildContext context,
  double saldoCapitalDisp,
) {
  return Container(
    padding: Responsive.isDesktop(context)
        ? EdgeInsets.symmetric(horizontal: alturaTela * 0.6, vertical: 20)
        : EdgeInsets.zero,
    height: Responsive.isDesktop(context)
        ? alturaTela * 0.35
        : MediaQuery.of(context).size.width * 0.49, //200.0,
    child: Card(
      margin: EdgeInsets.only(top: 10.0),
      elevation: 30,
      color: Colors.green[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Saldo Capital Dispon??vel",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: alturaTela * 0.027,
              ),
            ),
          ),
          Text(
            money.formatterMoney(saldoCapitalDisp),
            style: TextStyle(
              color: Colors.white,
              fontSize: alturaTela * 0.062,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

bool handleLimiteSolic(List<DataModel> datasRetiradaCapital) {
  String dataHoje = "${DateTime.now().month}-${DateTime.now().year}";
  List<String> datasSolic = [];
  bool limite;

  if (datasRetiradaCapital.length != 0) {
    datasRetiradaCapital.forEach((element) {
      datasSolic.add(
          "${DateTime.parse(element.data).month}-${DateTime.parse(element.data).year}");
    });
    limite = datasSolic.contains(dataHoje);

    return limite;
  } else {
    return false;
  }
}

Widget buildInput(
  MoneyMaskedTextController controller,
  double alturaTela,
) {
  return SizedBox(
    width: alturaTela * 0.37, //300,
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.attach_money),
        border: OutlineInputBorder(),
      ),
    ),
  );
}

bool handleFechamentoFolha(List<FechamentoFolhaModel> fechamentoFolha) {
  if (fechamentoFolha[0].fimmes == 1) {
    return true;
  }

  return false;
}
