import 'package:copbayer_app/controllers/data_controller.dart';
import 'package:copbayer_app/controllers/emprestimos_contratados_controller.dart';
import 'package:copbayer_app/controllers/saldo_capital_controller.dart';
import 'package:copbayer_app/controllers/solicitacao_post_controller.dart';
import 'package:copbayer_app/model/data_model.dart';
import 'package:copbayer_app/pages/controle/limite_solic_page.dart';

import 'package:copbayer_app/pages/infos_solicitation_page.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:copbayer_app/widgets/card_emprestimos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SimulationPage extends StatefulWidget {
  final String matricula;
  final SaldoCapitalController saldoCapitalController;
  final EmpContratadosController empContratadosController;
  final String situacao;

  const SimulationPage({
    Key key,
    this.saldoCapitalController,
    this.matricula,
    this.empContratadosController,
    @required this.situacao,
  }) : super(key: key);
  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  final formKey = new GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  final SolicitacaoPostController _solicPostController =
      Get.put(SolicitacaoPostController());
  FormatMoney money = FormatMoney();

  final DataController dataController = Get.find();

  int protocolo;

  @override
  void initState() {
    super.initState();
    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula + " " + data;
    protocolo = codigo.hashCode;

    _solicPostController.clearForm();
  }

  String _validateParcelas(String value) {
    if (int.parse(value) > 48) {
      return 'O número máximo de parcelas permitido é 48';
    }
    return null;
  }

  String _validateTextField(String value) {
    if (value.compareTo("0,00") == 0) {
      return '* Este campo é obrigatório. Informe um valor';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var empContratados = widget.empContratadosController.empContratados;

    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return GetX<DataController>(
      initState: (state) {
        dataController.getDatasSolic(int.parse(widget.matricula));
      },
      builder: (_) {
        return handleLimiteSolic(_.datasSolic)
            ? LimiteSolicPage(operacao: "empréstimo")
            : Scaffold(
                key: globalKey,
                appBar: AppBar(
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Simulação de empréstimo",
                    ),
                  ),
                  backgroundColor: Colors.green[300],
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: Responsive.isDesktop(context)
                        ? EdgeInsets.symmetric(horizontal: alturaTela * 0.2)
                        : EdgeInsets.zero,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(25.0),
                          child: GetX<EmpContratadosController>(
                            builder: (_) {
                              return empContratados.length < 1
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : LayoutBuilder(
                                      builder: (_, constraints) {
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          width: constraints.maxWidth, //500.0,
                                          height: alturaTela *
                                              0.25, //200.0, //MediaQuery.of(context).size.height * 0.25,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                top: BorderSide(
                                                    width: 6.0,
                                                    color: Colors.green[300]),
                                              )),
                                          child: Column(children: [
                                            SizedBox(
                                              height: alturaTela * 0.012,
                                            ),
                                            Text(
                                              "Empréstimos Contratados",
                                              style: TextStyle(
                                                  color: Colors.green[300],
                                                  fontSize:
                                                      alturaTela * 0.03, //24.0,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(
                                              height: alturaTela * 0.012,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  buildCardEmprestimo(
                                                    empContratados[0].total !=
                                                            null
                                                        ? money.formatterMoney(
                                                            double.parse(
                                                                empContratados[
                                                                        0]
                                                                    .total))
                                                        : '0',
                                                    "Total Contr.",
                                                    Colors.green,
                                                    alturaTela,
                                                    context,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.024,
                                                  ),
                                                  buildCardEmprestimo(
                                                    empContratados[0]
                                                                .desconto !=
                                                            null
                                                        ? money.formatterMoney(
                                                            double.parse(
                                                                empContratados[
                                                                        0]
                                                                    .desconto
                                                                    .toString()))
                                                        : '0',
                                                    "Desc. Total",
                                                    Colors.blueAccent,
                                                    alturaTela,
                                                    context,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.024,
                                                  ),
                                                  Container(
                                                    height: alturaTela *
                                                        0.099, //80,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.19, //80,
                                                    child:
                                                        CircularPercentIndicator(
                                                      radius: alturaTela * 0.05,
                                                      center: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                          empContratados[0]
                                                              .quantidade
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: alturaTela *
                                                                  0.027, //22.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      progressColor:
                                                          Colors.blue[700],
                                                      percent: .6,
                                                      lineWidth:
                                                          alturaTela * 0.0062,
                                                      circularStrokeCap:
                                                          CircularStrokeCap
                                                              .round,
                                                      footer: Text(
                                                        "Quant.",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: alturaTela *
                                                              0.017, //14.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ]),
                                        );
                                      },
                                    );
                            },
                          ),
                        ),
                        Text(
                          "Solicitação #${protocolo.toString()}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Container(
                              margin: const EdgeInsets.only(top: 30),
                              padding: Responsive.isDesktop(context)
                                  ? EdgeInsets.symmetric(
                                      horizontal: alturaTela * 0.3)
                                  : const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildTextField(
                                      'Solicitação R\$ (VALOR FINANCIADO)',
                                      _solicPostController.controllerValor,
                                      false,
                                      validateTextField: _validateTextField),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _buildTextFieldParcela(
                                      'Quantidade de parcelas',
                                      _solicPostController.controllerParcelas,
                                      true,
                                      _validateParcelas),
                                  Text(
                                    "* permitido até 48 parcelas",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15.0),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  _buildTextField(
                                      'Salário R\$',
                                      _solicPostController.controllerSalario,
                                      false,
                                      validateTextField: _validateTextField),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _buildTextField(
                                      'Líquido (Contra-Cheque) R\$',
                                      _solicPostController.controllerLiquido,
                                      false,
                                      validateTextField: _validateTextField),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _buildTextField(
                                      'Pensão Alimentícia R\$',
                                      _solicPostController.controllerPensao,
                                      false),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _buildTextField(
                                      'Consignado R\$',
                                      _solicPostController.controllerConsignado,
                                      false),
                                  SizedBox(
                                    height: 60,
                                  ),
                                  SizedBox(
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        var saldoCap = double.parse(widget
                                            .saldoCapitalController
                                            .saldoCapital[0]
                                            .saldo
                                            .toString());
                                        // VERIFICA SE POSSUI SALDO CAPITAL PRA CONCLUIR
                                        if (saldoCap == 0) {
                                          Get.dialog(
                                            AlertDialog(
                                              title: Text("Atenção!"),
                                              content: Text(
                                                "Apenas associados com saldo de capital podem solicitar empréstimo.",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: Text(
                                                    'OK',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }

                                        // SALVA A SOLICITAÇÃO
                                        if (saldoCap != 0) {
                                          if (formKey.currentState.validate()) {
                                            _solicPostController
                                                .saveSolicitacao(
                                              int.parse(widget.matricula),
                                              protocolo,
                                            );
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    InfosSolicitacaoPage(
                                                  matricula: widget.matricula,
                                                  solicitacaoInfo:
                                                      _solicPostController
                                                          .solicitacaoInfo,
                                                  saldoDevedor: widget
                                                      .empContratadosController
                                                      .empContratados[0]
                                                      .saldoDevedor
                                                      .toString(),
                                                  saldoCapital: widget
                                                      .saldoCapitalController
                                                      .saldoCapital[0]
                                                      .saldo,
                                                  protocolo: protocolo,
                                                  situacao: widget.situacao,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          side: BorderSide(
                                              color: Colors.green[300]),
                                        ),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "SIMULAR",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

bool handleLimiteSolic(List<DataModel> datasSolicitacao) {
  String dataHoje = DateTime.now().toString().substring(0, 10);
  List<String> datasSolic = [];
  bool limite;

  if (datasSolicitacao.length != 0) {
    datasSolicitacao.forEach((element) {
      datasSolic.add(element.data.toString().substring(0, 10));
    });
    limite = datasSolic.contains(dataHoje);

    return limite;
  } else {
    return false;
  }
}

// TextField do formulário
Widget _buildTextField(
    String text, TextEditingController controller, bool parcelas,
    {Function validateTextField}) {
  return TextFormField(
    validator: validateTextField,
    controller: controller,
    keyboardType: TextInputType.number,
    decoration:
        InputDecoration(prefixText: parcelas ? '' : 'R\$', labelText: text),
  );
}

Widget _buildTextFieldParcela(String text, TextEditingController controller,
    bool parcelas, Function validateTextField) {
  return TextFormField(
    validator: validateTextField,
    controller: controller,
    keyboardType: TextInputType.number,
    decoration:
        InputDecoration(prefixText: parcelas ? '' : 'R\$', labelText: text),
  );
}
