import 'package:copbayer_app/controllers/data_controller.dart';
import 'package:copbayer_app/controllers/faixa_capital_controller.dart';
import 'package:copbayer_app/controllers/fechamento_folha_controller.dart';
import 'package:copbayer_app/model/data_model.dart';
import 'package:copbayer_app/model/faixa_capital_model.dart';
import 'package:copbayer_app/pages/controle/fechamento_folha.dart';
import 'package:copbayer_app/pages/controle/limite_solic_page.dart';
import 'package:copbayer_app/pages/submenu/widgets/dropdown_button.dart';
import 'package:copbayer_app/pages/submenu/widgets/solicitar_button.dart';
import 'package:copbayer_app/repositories/faixa_capital_repository.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';

class AlteracaoCapitalPage extends StatefulWidget {
  final int matricula;
  final String opCapitalizacao;
  final String situacao;

  AlteracaoCapitalPage({
    this.matricula,
    this.opCapitalizacao,
    @required this.situacao,
  });

  @override
  _AlteracaoCapitalPageState createState() => _AlteracaoCapitalPageState();
}

class _AlteracaoCapitalPageState extends State<AlteracaoCapitalPage> {
  final FaixaCapitalController faixaCapitalController = Get.find();

  final FaixaCapitalRepository faixaCapitalRepository =
      FaixaCapitalRepository();

  final DataController dataController = Get.find();
  final FechamentoFolhaController fechamentoFolhaController = Get.find();

  MaskedTextController controllerData =
      MaskedTextController(mask: 'dd/mm/aaaa', text: 'dd/mm/aaaa');

  String capitalValue;
  int protocolo;

  DateTime selectedDate =
      DateTime.parse("${DateTime.now().toString().split(" ")[0]} 00:00:00.000");

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    void handleChangeCapital(String value) {
      setState(() {
        capitalValue = value;
      });
    }

    handleAlteraCapital() {
      var faixa = capitalValue.split('-')[0];
      var valor = capitalValue.split("R\$")[1].replaceAll(',', '.');

      var data = DateTime.now().toString().substring(0, 19);

      var codigo = widget.matricula.toString() + " " + data;
      protocolo = codigo.hashCode;

      var alteraCapital = {
        "matricula": widget.matricula,
        "faixa": faixa,
        "valor": valor,
        "data": DateTime.now().toString().substring(0, 19),
        "faixa_anterior": widget.opCapitalizacao,
        "numero": protocolo,
        "a_partir_de": selectedDate.toString(),
      };

      faixaCapitalRepository.alteraCapital(alteraCapital);
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          locale: Locale('pt'),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    return GetX<DataController>(
      initState: (state) {
        dataController.getDatasAlterCapital(widget.matricula);
      },
      builder: (_) {
        return fechamentoFolhaController.fechamentoFolha != null &&
                fechamentoFolhaController.fechamentoFolha[0].fimmes == 1
            ? FechamentoFolhaPage()
            : handleLimiteSolic(_.datasAlterCapital)
                ? LimiteSolicPage(operacao: "alteração de capital")
                : Scaffold(
                    appBar: AppBar(
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Alteração de Capital",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      backgroundColor: Colors.green[300],
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: Responsive.isDesktop(context)
                            ? EdgeInsets.symmetric(
                                horizontal: alturaTela * 0.5, vertical: 10)
                            : EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GetX<FaixaCapitalController>(
                              /*(controllerData: (state) {
                            faixaCapitalController.getFaixaCapital();
                          },*/
                              builder: (_) {
                                return _.faixaCapital.length < 1
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                    : buildCard(alturaTela, _.faixaCapital,
                                        widget.opCapitalizacao);
                              },
                            ),
                            SizedBox(
                              height: alturaTela * 0.12, //100,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                "Capitalizações",
                                style: TextStyle(fontSize: alturaTela * 0.025),
                              ),
                            ),
                            GetX<FaixaCapitalController>(
                              builder: (_) {
                                return _.faixaCapital.length < 1
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                    : CustomDropDownButton(
                                        value: capitalValue,
                                        list: widget.situacao != null &&
                                                widget.situacao
                                                        .compareTo("A") ==
                                                    0
                                            ? _.faixaCapital
                                                .map((e) =>
                                                    "${e.faixas} - R\$ ${e.valor},00")
                                                .toList()
                                            : _.faixaCapital
                                                .where((element) =>
                                                    element.faixas
                                                        .compareTo("D") !=
                                                    0)
                                                .map((e) =>
                                                    "${e.faixas} - R\$ ${e.valor},00")
                                                .toList(),
                                        handleChangeValue: handleChangeCapital,
                                      );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30, top: 30),
                              child: Text(
                                "A partir da data:",
                                style: TextStyle(fontSize: alturaTela * 0.025),
                              ),
                            ),
                            SizedBox(
                              height: alturaTela * 0.025, //20.0,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    selectedDate.day >= 1 &&
                                            selectedDate.day <= 9
                                        ? selectedDate.month >= 1 &&
                                                selectedDate.month <= 9
                                            ? "0${selectedDate.day.toString()}/0${selectedDate.month.toString()}/${selectedDate.year.toString()}"
                                            : "0${selectedDate.day.toString()}/${selectedDate.month.toString()}/${selectedDate.year.toString()}"
                                        : selectedDate.month >= 1 &&
                                                selectedDate.month <= 9
                                            ? "${selectedDate.day.toString()}/0${selectedDate.month.toString()}/${selectedDate.year.toString()}"
                                            : "${selectedDate.day.toString()}/${selectedDate.month.toString()}/${selectedDate.year.toString()}",
                                    style:
                                        TextStyle(fontSize: alturaTela * 0.025),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () => _selectDate(context),
                                    elevation: 2.0,
                                    fillColor: Colors.blue,
                                    child: Icon(
                                      Icons.calendar_today_outlined,
                                      size: alturaTela * 0.037, //30.0,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  )
                                ]),
                            SizedBox(
                              height: alturaTela * 0.12,
                            ),
                            capitalValue != null
                                ? Center(
                                    child: SolicitarButton(
                                      handleSolicitar: handleAlteraCapital,
                                      matricula: widget.matricula,
                                    ),
                                  )
                                : Container(
                                    padding: Responsive.isDesktop(context)
                                        ? EdgeInsets.symmetric(
                                            horizontal: alturaTela * 0.2)
                                        : EdgeInsets.zero,
                                    child:
                                        buildButtonDialog(context, alturaTela),
                                  ),
                            SizedBox(
                              height: alturaTela * 0.025,
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

// CASO A FAIXA DE CAPITAL ESTEJA VAZIA
Widget buildButtonDialog(BuildContext context, double alturaTela) {
  return Center(
    child: SizedBox(
      height: alturaTela * 0.055, //45,
      width: MediaQuery.of(context).size.width * 0.73,
      child: ElevatedButton(
        onPressed: () {
          return Get.dialog(
            AlertDialog(
              title: Text("Atenção!"),
              content: Text(
                "Você deve informar a faixa de capital.",
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text("OK"),
                ),
              ],
            ),
          );
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
    ),
  );
}

bool handleLimiteSolic(List<DataModel> datasAlteraCapital) {
  String dataHoje = "${DateTime.now().month}-${DateTime.now().year}";
  List<String> datasSolic = [];
  bool limite;

  if (datasAlteraCapital != null && datasAlteraCapital.length != 0) {
    datasAlteraCapital.forEach((element) {
      datasSolic.add(
          "${DateTime.parse(element.data).month}-${DateTime.parse(element.data).year}");
    });
    limite = datasSolic.contains(dataHoje);

    return limite;
  } else {
    return false;
  }
}

Widget buildCard(double alturaTela, List<FaixaCapitalModel> faixasCapital,
    String opCapitalizacao) {
  var capAtual = faixasCapital
      .where((element) => element.faixas.compareTo(opCapitalizacao) == 0)
      .toList();
  return SizedBox(
    height: alturaTela * 0.25, //200.0,
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
              "Capitalização Atual",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: alturaTela * 0.027,
              ),
            ),
          ),
          Text(
            "${capAtual[0].faixas} - R\$ ${capAtual[0].valor},00",
            style: TextStyle(
              color: Colors.white,
              fontSize: alturaTela * 0.055, //50.0,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
