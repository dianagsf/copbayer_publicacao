import 'package:copbayer_app/controllers/proposta_controller.dart';
import 'package:copbayer_app/model/proposta_model.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Propostas extends StatefulWidget {
  final int matricula;
  final FormatMoney money;

  const Propostas({
    Key key,
    this.matricula,
    this.money,
  }) : super(key: key);

  @override
  _PropostasState createState() => _PropostasState();
}

class _PropostasState extends State<Propostas> {
  List<PropostaModel> selectedEmp = [];

  handleChangeCheckBox(bool value, PropostaModel prop) async {
    setState(() {
      if (value) {
        selectedEmp.add(prop);
      } else {
        selectedEmp.remove(prop);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return GetX<PropostaController>(
      builder: (_) {
        return _.propostas.length < 1
            ? Text(
                "Nenhum contrato ativo no momento.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: alturaTela * 0.017,
                ),
              )
            : _buidTablePropostas(
                [
                  "Número",
                  "Data",
                  "Principal",
                  "Líquido Cred.",
                  "Prestação",
                  "NPC",
                  "NPF",
                  "Devedor Principal",
                  "Val p/ Quitação"
                ],
                _.propostas,
                widget.money,
              );
      },
    );
  }
}

Widget _buidTablePropostas(
  List<String> tableHeaderQuitacao,
  List<PropostaModel> propostaList,
  FormatMoney money,
) {
  return DataTable(
    columns: tableHeaderQuitacao
        .map(
          (header) => DataColumn(
            label: Container(
              padding: header.compareTo("Data") == 0 ||
                      header.compareTo("Principal") == 0
                  ? const EdgeInsets.only(left: 15)
                  : EdgeInsets.zero,
              alignment: Alignment.center,
              child: Text(header),
            ),
          ),
        )
        .toList(),
    rows: propostaList.map<DataRow>(
      (prop) {
        var data = prop.data.substring(0, 10).split('-');
        var dataFormat = "${data[2]}-${data[1]}-${data[0]}";
        var valorFormat = prop.valorcr != null
            ? money.formatterMoney(double.parse("${prop.valorcr}"))
            : '-';
        var principalFormat = prop.principal != null
            ? money.formatterMoney(double.parse("${prop.principal}"))
            : '-';
        var prestacaoFormat = prop.prestacao != null
            ? money.formatterMoney(double.parse("${prop.prestacao}"))
            : '-';
        var devedorFormat = prop.saldoDevedor != null
            ? money.formatterMoney(double.parse("${prop.saldoDevedor}"))
            : '-';

        var quitacaoFormat = prop.valorQuitacao != null
            ? money.formatterMoney(double.parse("${prop.valorQuitacao}"))
            : '-';

        return DataRow(
          cells: [
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text("${prop.numero}"),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(dataFormat),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(principalFormat),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(valorFormat),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(prestacaoFormat),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text("${prop.npc}"),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text("${prop.npf}"),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(devedorFormat),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(quitacaoFormat),
              ),
            ),
          ],
        );
      },
    ).toList(),
  );
}
