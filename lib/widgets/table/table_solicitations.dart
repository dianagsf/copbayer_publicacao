import 'package:copbayer_app/controllers/proposta_controller.dart';
import 'package:copbayer_app/controllers/solicitacoes_controller.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:copbayer_app/widgets/table/propostas.dart';
import 'package:copbayer_app/widgets/table/solicitacoes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SolicitationsTable extends StatefulWidget {
  final String matricula;
  final FormatMoney moneyFormat;
  final bool solicitationsPage;
  final bool solicPendentes;

  const SolicitationsTable({
    Key key,
    @required this.matricula,
    this.moneyFormat,
    @required this.solicitationsPage,
    @required this.solicPendentes,
  }) : super(key: key);
  @override
  _SolicitationsTableState createState() => _SolicitationsTableState();
}

class _SolicitationsTableState extends State<SolicitationsTable> {
  final SolicitacoesController solicitacoesController =
      Get.put(SolicitacoesController());
  final PropostaController propostaController = Get.put(PropostaController());

  bool verTodas = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    solicitacoesController.getSolicitacoes(int.parse(widget.matricula));
    solicitacoesController.getSolicitacoesRecentes(int.parse(widget.matricula));

    propostaController.getPropostasUser(int.parse(widget.matricula));
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: widget.solicitationsPage
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.solicitationsPage
                        ? widget.solicPendentes
                            ? "Solicitações Pendentes"
                            : "Solicitações Processadas"
                        : "Empréstimos em Vigor",
                    style: TextStyle(
                      color: Colors.green[400],
                      fontSize: widget.solicitationsPage
                          ? alturaTela * 0.03
                          : Responsive.isDesktop(context)
                              ? alturaTela * 0.04
                              : alturaTela * 0.027, //24.0 : 22.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        const SizedBox(height: 20),
        Scrollbar(
          isAlwaysShown: true,
          thickness: 3,
          controller: _scrollController,
          radius: Radius.circular(40),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: widget.solicitationsPage
                ? Solicitacoes(
                    matricula: int.parse(widget.matricula),
                    money: widget.moneyFormat,
                    solicPendentes: widget.solicPendentes,
                  )
                : Propostas(
                    matricula: int.parse(widget.matricula),
                    money: widget.moneyFormat,
                  ),
          ),
        )
      ],
    );
  }
}
