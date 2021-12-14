import 'package:copbayer_app/controllers/solicitacoes_controller.dart';
import 'package:copbayer_app/controllers/solicitacoes_pendentes_controller.dart';
import 'package:copbayer_app/model/solic_pendentes_model.dart';
import 'package:copbayer_app/model/solicitacao_model.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Solicitacoes extends StatefulWidget {
  final int matricula;
  final FormatMoney money;
  final bool solicPendentes;

  const Solicitacoes({
    Key key,
    @required this.matricula,
    this.money,
    @required this.solicPendentes,
  }) : super(key: key);

  @override
  _SolicitacoesState createState() => _SolicitacoesState();
}

class _SolicitacoesState extends State<Solicitacoes> {
  final SolicitacoesController solicitacoesController =
      Get.put(SolicitacoesController());

  final SolicPendentesController solicPendentesController =
      Get.put(SolicPendentesController());

  @override
  void initState() {
    super.initState();
    solicitacoesController.getSolicitacoes(widget.matricula);
    solicPendentesController.getSolicPendentes(widget.matricula);
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return widget.solicPendentes
        ? GetX<SolicPendentesController>(
            builder: (_) {
              return _.solicPendentes.length < 1
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Nenhuma solicitação nos últimos 180 dias.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: alturaTela * 0.017,
                        ),
                      ),
                    )
                  : _buildTable(
                      null,
                      widget.money,
                      alturaTela,
                      context,
                      _.solicPendentes,
                    );
            },
          )
        : GetX<SolicitacoesController>(
            builder: (_) {
              return _.solicitacoes.length < 1
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Nenhuma solicitação nos últimos 180 dias.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: alturaTela * 0.017,
                        ),
                      ),
                    )
                  : _buildTable(
                      _.solicitacoes,
                      widget.money,
                      alturaTela,
                      context,
                      null,
                    );
            },
          );
  }
}

Widget _buildTable(
  List<SolicitacaoModel> solicitacoesList,
  FormatMoney money,
  double alturaTela,
  BuildContext context,
  List<SolicPendentesModel> solicPendentes,
) {
  final larguraColuna = Responsive.isDesktop(context)
      ? MediaQuery.of(context).size.width * 0.1
      : MediaQuery.of(context).size.width * 0.23;
  List<dynamic> listaSolic;

  if (solicitacoesList != null) {
    listaSolic = solicitacoesList;
  } else {
    listaSolic = solicPendentes;
  }

  return Column(
    children: [
      Table(
        columnWidths: {
          6: FixedColumnWidth(larguraColuna + 20),
        },
        defaultColumnWidth: FixedColumnWidth(larguraColuna /*95.0*/),
        border: TableBorder(
          horizontalInside: BorderSide(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 0.5,
          ),
        ),
        children: [
          TableRow(
            children: [
              "Data",
              "Origem",
              "Status",
              "Solicitado",
              "NP",
              "Prestação",
              "Informações",
            ]
                .map((value) => Container(
                      alignment: Alignment.center,
                      child: FittedBox(
                        //fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style: TextStyle(
                              // fontSize: alturaTela * 0.018, //16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      padding: EdgeInsets.all(8.0),
                    ))
                .toList(),
          ),
        ],
      ),
      Table(
        columnWidths: {
          6: FixedColumnWidth(larguraColuna + 20),
        },
        defaultColumnWidth: FixedColumnWidth(larguraColuna),
        border: TableBorder(
          horizontalInside: BorderSide(
            color: Colors.black87,
            style: BorderStyle.solid,
            width: 0.3,
          ),
        ),
        children: listaSolic.map<TableRow>((sol) {
          Color colorRow;
          var status;

          switch (sol.situacao) {
            case "L":
              {
                status = "Aprovada";
                colorRow = Colors.blue;
              }
              break;
            case "R":
              {
                status = "Negada";
                colorRow = Colors.red;
              }
              break;
            case "C":
              {
                status = "Cancelada";
                colorRow = Colors.grey[800];
              }
              break;
            case "P":
              {
                status = "Pendente";
                colorRow = Colors.green[700];
              }
              break;
            default:
              status = "";
          }

          var data = sol.data.substring(0, 10).split('-');
          var dataFormat = "${data[2]}-${data[1]}-${data[0]}";
          var valorFormat = sol.valor != null
              ? money.formatterMoney(double.parse("${sol.valor}"))
              : '';
          var descontoFormat = sol.prestacao != null
              ? money.formatterMoney(double.parse("${sol.prestacao}"))
              : '';

          var origem;

          if (sol.situacao != null && sol.situacao.compareTo("P") != 0)
            origem = sol.solicWeb == null ? "COOP" : "WEB";
          else
            origem = sol.origem;

          return _buildTableRow(
            "$dataFormat* $origem* $status* $valorFormat* ${sol.np}* $descontoFormat",
            colorRow,
            alturaTela,
            sol.situacao,
            sol.situacao.compareTo("P") != 0 ? sol.motivo : "",
          );
        }).toList(),
      ),
    ],
  );
}

_buildTableRow(String values, Color colorRow, double alturaTela, String status,
    String motivo) {
  return TableRow(
    children: [
      ...values
          .split('*')
          .map((value) => Container(
                alignment: Alignment.center,
                child: FittedBox(
                  child: Text(
                    value,
                    style: TextStyle(
                        //fontSize: alturaTela * 0.016, //12.5,
                        color: colorRow,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                padding: EdgeInsets.all(8.0),
              ))
          .toList(),
      status != null && status.compareTo('R') == 0
          ? GestureDetector(
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title:
                        Text('A solicitação foi negada pelo seguinte motivo:'),
                    content: Text(
                      motivo,
                      style: TextStyle(fontSize: 18),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('OK'),
                      )
                    ],
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          : status.compareTo("P") == 0
              ? Container(
                  margin: const EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Text(
                      'em análise',
                      style: TextStyle(
                        // fontSize: alturaTela * 0.016,
                        color: colorRow,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : Center(child: Text('-')),
    ],
  );
}
