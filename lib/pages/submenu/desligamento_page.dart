import 'package:copbayer_app/controllers/data_controller.dart';
import 'package:copbayer_app/controllers/devedor_controller.dart';
import 'package:copbayer_app/controllers/motivos_controller.dart';
import 'package:copbayer_app/controllers/proposta_controller.dart';
import 'package:copbayer_app/controllers/saldo_capital_controller.dart';
import 'package:copbayer_app/model/data_model.dart';
import 'package:copbayer_app/model/fechamento_folha_model.dart';
import 'package:copbayer_app/pages/contato_page.dart';
import 'package:copbayer_app/pages/controle/limite_solic_page.dart';
import 'package:copbayer_app/pages/submenu/widgets/infos_devedor.dart';
import 'package:copbayer_app/pages/submenu/widgets/solicitar_button.dart';
import 'package:copbayer_app/repositories/desligamento_repository.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesligamentoPage extends StatefulWidget {
  final int matricula;
  final String nome;
  final String data;

  DesligamentoPage({this.matricula, this.nome, this.data});

  @override
  _DesligamentoPageState createState() => _DesligamentoPageState();
}

class _DesligamentoPageState extends State<DesligamentoPage> {
  final MotivosController motivosController = Get.put(MotivosController());
  final DesligamentoRepository desligamentoRepository =
      DesligamentoRepository();

  final PropostaController propostaController = Get.find();
  final SaldoCapitalController saldoCapitalController = Get.find();
  final SaldoDevedorController saldoDevedorController = Get.find();

  final TextEditingController observacaoController = TextEditingController();

  final DataController dataController = Get.find();

  String dataHoje = DateTime.now().toString().substring(0, 10);
  var datasSolic;

  String motivoValue;
  FormatMoney money = FormatMoney();
  bool isDevedor = false;
  double total;
  var devedor;
  var saldo;
  bool enviarComprovante = false;

  int protocolo;
  bool limite;

  @override
  void initState() {
    super.initState();

    saldoDevedorController.saldoDevedor[0].devedor != null
        ? devedor = double.parse(
            saldoDevedorController.saldoDevedor[0].devedor.toString())
        : devedor = 0;
    saldo = saldoCapitalController.saldoCapital[0].saldo != null
        ? double.parse(saldoCapitalController.saldoCapital[0].saldo)
        : 0.0;

    devedor != null ? isDevedor = true : isDevedor = false;

    isDevedor ? total = (devedor - saldo).abs() : total = saldo;

    var data = DateTime.now().toString().substring(0, 19);
    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    var nomeEsobrenome = widget.nome.split(" ");
    nomeEsobrenome = [
      nomeEsobrenome[0].toUpperCase() + " " + nomeEsobrenome[1].toUpperCase()
    ];

    handleDesligamento() {
      setState(() {
        enviarComprovante = true;
      });

      var assocDesligamento = {
        "matricula": widget.matricula,
        "data": DateTime.now().toString().substring(0, 23),
        "motivo": null, //motivoValue.split(':')[1],
        "observacao": observacaoController.text,
        "numero": protocolo,
      };

      desligamentoRepository.saveInfoDesligamento(assocDesligamento);
    }

    return GetX<DataController>(
      initState: (state) {
        dataController.getDatasDesligamento(widget.matricula);
      },
      builder: (_) {
        return handleLimiteSolic(_.datasDesligamento)
            ? LimiteSolicPage(operacao: "desligamento")
            : Scaffold(
                appBar: AppBar(
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Desligamento do Cooperado",
                      overflow: TextOverflow.visible,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  backgroundColor: Colors.green[300],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.isDesktop(context)
                            ? alturaTela * 0.4
                            : 20,
                        vertical: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                        GetX<SaldoDevedorController>(
                          builder: (_) {
                            return _.saldoDevedor.length < 1
                                ? Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                : buildCardInfo(
                                    Icons.money_off,
                                    "Saldo Devedor",
                                    _.saldoDevedor[0].devedor != null
                                        ? money.formatterMoney(double.parse(_
                                            .saldoDevedor[0].devedor
                                            .toString()))
                                        : 'R\$ 0,00',
                                    Colors.red[400],
                                    alturaTela,
                                  );
                          },
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 5,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  devedor > saldo
                                      ? "Total a pagar"
                                      : "Total a receber",
                                  style: TextStyle(
                                    fontSize: alturaTela * 0.022,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  money.formatterMoney(total),
                                  style: TextStyle(
                                    fontSize: alturaTela * 0.022,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        devedor > saldo
                            ? Column(
                                children: [
                                  InfosDevedor(
                                    matricula: widget.matricula,
                                    protocolo: protocolo,
                                    quitacaoPage: false,
                                    saldoDevedor: money.formatterMoney(total),
                                    valor: money.formatterMoney(total),
                                    enviarComprovante: enviarComprovante,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "ou entre em contato com a Copbayer para o pagamento da diferença:",
                                      style: TextStyle(
                                        fontSize: alturaTela * 0.022,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 15,
                                      right: 10,
                                      top: 10,
                                      bottom: 30,
                                    ),
                                    alignment: Alignment.bottomLeft,
                                    child: ElevatedButton.icon(
                                      label: Text('Fale Conosco'),
                                      icon: Icon(Icons.phone),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.to(() => ContatoPage());
                                      },
                                    ),
                                  )
                                ],
                              )
                            : SizedBox.shrink(),
                        Text(
                          "Informe o motivo do desligamento",
                          style: TextStyle(fontSize: alturaTela * 0.025),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: alturaTela * 0.025,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: TextField(
                            controller: observacaoController,
                            style: TextStyle(fontSize: alturaTela * 0.022),
                            decoration: InputDecoration(
                                labelText: "Motivo do desligamento"),
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                        const SizedBox(height: 30),
                        devedor < saldo
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Aviso importante:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Em casos de devolução do capital: sua solicitação será analisada e se aprovada, a devolução ocorrerá no dia 10 do mês seguinte.",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                          height: alturaTela * 0.11, //90,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.isDesktop(context)
                                ? alturaTela * 0.07
                                : 50,
                          ),
                          child: SolicitarButton(
                            handleSolicitar: handleDesligamento,
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

bool handleLimiteSolic(List<DataModel> datasDesligamento) {
  String dataHoje = "${DateTime.now().month}-${DateTime.now().year}";
  List<String> datasSolic = [];
  bool limite;

  if (datasDesligamento != null && datasDesligamento.length != 0) {
    datasDesligamento.forEach((element) {
      datasSolic.add(
          "${DateTime.parse(element.data).month}-${DateTime.parse(element.data).year}");
    });
    limite = datasSolic.contains(dataHoje);

    return limite;
  } else {
    return false;
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
        Text(
          value,
          style: TextStyle(
            fontSize: alturaTela * 0.022,
          ),
        ),
      ],
    ),
  );
}

Widget userInfos(IconData icon, String title, String data, BuildContext context,
    double alturaTela) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.blueAccent,
                size: 20,
              ),
              SizedBox(
                width: alturaTela * 0.006,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: alturaTela * 0.019, //15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(
            height: alturaTela * 0.006,
          ),
          Text(
            data,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: alturaTela * 0.017, //14,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
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
