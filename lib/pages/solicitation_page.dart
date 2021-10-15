import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/widgets/table/table_solicitations.dart';
import 'package:flutter/material.dart';

class SolicitationPage extends StatefulWidget {
  final String matricula;
  final String nome;
  final String dataAssociacao;
  final FormatMoney moneyFormat;
  const SolicitationPage(
      {Key key,
      this.matricula,
      this.nome,
      this.dataAssociacao,
      this.moneyFormat})
      : super(key: key);

  @override
  _SolicitationPageState createState() => _SolicitationPageState();
}

class _SolicitationPageState extends State<SolicitationPage> {
  @override
  Widget build(BuildContext context) {
    //var data = widget.dataAssociacao.substring(0, 10).split('-');
    //var dataFormat = "${data[2]}-${data[1]}-${data[0]}";

    var nomeEsobrenome = widget.nome.split(" ");
    nomeEsobrenome = [nomeEsobrenome[0] + " " + nomeEsobrenome[1]];

    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Solicitações realizadas",
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.green[300],
            bottom: TabBar(
              isScrollable: true,
              indicatorWeight: 3,
              indicatorColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: alturaTela * 0.05),
              tabs: [
                Tab(text: 'Pendentes'),
                Tab(text: 'Processadas'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8, vertical: alturaTela * 0.05),
                      child: SolicitationsTable(
                        matricula: widget.matricula,
                        moneyFormat: widget.moneyFormat,
                        solicitationsPage: true,
                        solicPendentes: true,
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8, vertical: alturaTela * 0.05),
                      child: SolicitationsTable(
                        matricula: widget.matricula,
                        moneyFormat: widget.moneyFormat,
                        solicitationsPage: true,
                        solicPendentes: false,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
