import 'package:copbayer_app/controllers/data_controller.dart';
import 'package:copbayer_app/controllers/devedor_controller.dart';
import 'package:copbayer_app/controllers/emprestimos_contratados_controller.dart';
import 'package:copbayer_app/controllers/faixa_capital_controller.dart';
import 'package:copbayer_app/controllers/fechamento_folha_controller.dart';
import 'package:copbayer_app/controllers/pedido_quitacao_controller.dart';
import 'package:copbayer_app/controllers/saldo_capital_controller.dart';
import 'package:copbayer_app/controllers/solicitacoes_pendentes_controller.dart';
import 'package:copbayer_app/pages/contato_page.dart';
import 'package:copbayer_app/pages/controle/initial_page.dart';
import 'package:copbayer_app/pages/info_page.dart';
import 'package:copbayer_app/pages/simulation_page.dart';
import 'package:copbayer_app/pages/solicitation_page.dart';
import 'package:copbayer_app/repositories/log_app_repository.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:copbayer_app/widgets/item_list_menu.dart';
import 'package:copbayer_app/widgets/table/table_solicitations.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final String matricula;
  final String nome;
  final String dataAssociacao;
  final String opCapitalizacao;
  final String cpf;
  final String situacao;

  const HomePage({
    Key key,
    this.matricula,
    this.nome,
    this.dataAssociacao,
    this.opCapitalizacao,
    this.cpf,
    this.situacao,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final Color _primaryColor = Colors.green[300];

  LogAppRepository _logAppRepository = LogAppRepository();

  final SaldoCapitalController saldoCapitalController =
      Get.put(SaldoCapitalController());
  final EmpContratadosController empContratadosController =
      Get.put(EmpContratadosController());
  final FaixaCapitalController faixaCapitalController =
      Get.put(FaixaCapitalController());

  final SaldoDevedorController saldoDevedorController =
      Get.put(SaldoDevedorController());

  final DataController dataController = Get.put(DataController());
  final FechamentoFolhaController fechamentoFolhaController =
      Get.put(FechamentoFolhaController());

  final PedidoQuitacaoController pedidoQuitacaoController =
      Get.put(PedidoQuitacaoController());

  final SolicPendentesController solicPendentesController =
      Get.put(SolicPendentesController());

  FormatMoney money = FormatMoney();

  @override
  void initState() {
    super.initState();

    // SAVE LOG APP
    _logAppRepository.saveLog({
      "usuario": int.parse(widget.matricula),
      "datahora": DateTime.now().toString().substring(0, 23),
      "modulo": "Início Sessão",
    });

    faixaCapitalController.getFaixaCapital();

    saldoDevedorController.getSaldoDevedor(int.parse(widget.matricula));
    fechamentoFolhaController.getFechamento();

    pedidoQuitacaoController.getPedidosQuitacao();

    solicPendentesController.getSolicPendentes(int.parse(widget.matricula));
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Responsive(
      mobile: Scaffold(
        appBar: AppBar(
          title: Text(
            "Copbayer",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: _primaryColor,
        ),
        drawer: _buildMenu(
          context,
          widget.matricula,
          widget.nome,
          widget.dataAssociacao,
          widget.opCapitalizacao,
          widget.cpf,
          widget.situacao,
          money,
          empContratadosController,
          saldoCapitalController,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildCard(int.parse(widget.matricula), saldoCapitalController,
                  money, alturaTela),
              _builMainBody(widget.matricula, empContratadosController, money,
                  alturaTela, context),
            ],
          ),
        ),
      ),
      tablet: Scaffold(
        appBar: AppBar(
          title: Text(
            "Copbayer",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: _primaryColor,
        ),
        drawer: _buildMenu(
          context,
          widget.matricula,
          widget.nome,
          widget.dataAssociacao,
          widget.opCapitalizacao,
          widget.cpf,
          widget.situacao,
          money,
          empContratadosController,
          saldoCapitalController,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildCard(int.parse(widget.matricula), saldoCapitalController,
                  money, alturaTela),
              _builMainBody(widget.matricula, empContratadosController, money,
                  alturaTela, context),
            ],
          ),
        ),
      ),
      desktop: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildMenu(
                  context,
                  widget.matricula,
                  widget.nome,
                  widget.dataAssociacao,
                  widget.opCapitalizacao,
                  widget.cpf,
                  widget.situacao,
                  money,
                  empContratadosController,
                  saldoCapitalController,
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: alturaTela * 0.4, vertical: 20),
                          child: _buildCard(
                            int.parse(widget.matricula),
                            saldoCapitalController,
                            money,
                            alturaTela,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          height: alturaTela * 0.25,
                          child: GetX<EmpContratadosController>(
                            initState: (state) => {
                              empContratadosController.getEmpContratados(
                                  int.parse(widget.matricula))
                            },
                            builder: (_) {
                              return _.empContratados.length < 1
                                  ? Text(
                                      "Nenhum empréstimo contratado no momento.")
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: _buildCardWeb(
                                            alturaTela,
                                            _.empContratados[0].total == null
                                                ? '0'
                                                : money.formatterMoney(
                                                    double.parse(_
                                                        .empContratados[0].total
                                                        .toString())),
                                            "Total Contratado",
                                            Colors.blue,
                                            Icons.attach_money,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: _buildCardWeb(
                                            alturaTela,
                                            _.empContratados[0].total == null
                                                ? '0'
                                                : money.formatterMoney(
                                                    double.parse(_
                                                        .empContratados[0]
                                                        .desconto
                                                        .toString())),
                                            "Desconto Total",
                                            Colors.green,
                                            Icons.money_off,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: CircularPercentIndicator(
                                            radius: alturaTela * 0.18,
                                            center: Text(
                                              _.empContratados[0].quantidade
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    alturaTela * 0.05, //22.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            progressColor: Colors.purple,
                                            percent: .7,
                                            lineWidth: alturaTela * 0.01,
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            footer: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text(
                                                "Quantidade de empéstimos",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: alturaTela *
                                                      0.022, //14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 40),
                          child: SolicitationsTable(
                            matricula: widget.matricula,
                            moneyFormat: money,
                            solicitationsPage: false,
                            solicPendentes: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardWeb(
    double alturaTela,
    String value,
    String title,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
              stops: [0.02, 0.02], colors: [color, Colors.white]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 30.0,
                color: color,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FittedBox(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: alturaTela * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: alturaTela * 0.022,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Menu página inicial //

Widget _buildMenu(
  BuildContext context,
  String matricula,
  String nome,
  String dataAssociacao,
  String opCapitalizacao,
  String cpf,
  String situacao,
  FormatMoney money,
  EmpContratadosController empContratadosController,
  SaldoCapitalController saldoCapitalController,
) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              nome,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  color: Responsive.isDesktop(context)
                      ? Colors.black
                      : Colors.white,
                  fontSize: 15),
            ),
          ),
          accountEmail: Text(
            "Matrícula: $matricula",
            style: TextStyle(
              color:
                  Responsive.isDesktop(context) ? Colors.black : Colors.white,
            ),
          ),
          decoration: BoxDecoration(
            color: Responsive.isDesktop(context)
                ? Color.fromARGB(255, 250, 250, 250)
                : Colors.green[300],
            image: DecorationImage(
              image: AssetImage("images/logoHome.png"),
              fit: BoxFit.scaleDown,
              alignment: Responsive.isDesktop(context)
                  ? Alignment.topLeft
                  : Alignment.centerLeft,
            ),
          ),
        ),
        buildItemList(
            context,
            Icon(Icons.home),
            "PAINEL INICIAL",
            HomePage(
              matricula: matricula,
              nome: nome,
              dataAssociacao: dataAssociacao,
              opCapitalizacao: opCapitalizacao,
              cpf: cpf,
              situacao: situacao,
            ),
            solicitacoes: false),
        buildItemList(
            context,
            Icon(Icons.attach_money),
            "SIMULAÇÃO EMPRÉSTIMO",
            SimulationPage(
              saldoCapitalController: saldoCapitalController,
              matricula: matricula,
              empContratadosController: empContratadosController,
              situacao: situacao,
            ),
            solicitacoes: false),
        buildItemList(
          context,
          Icon(Icons.credit_card),
          "SOLICITAÇÕES",
          SolicitationPage(
              matricula: matricula,
              moneyFormat: money,
              nome: nome,
              dataAssociacao: dataAssociacao),
          solicitacoes: true,
          matricula: int.parse(matricula),
          nome: nome,
          data: dataAssociacao,
          opCapitalizacao: opCapitalizacao,
          cpf: cpf,
          situacao: situacao,
        ),
        buildItemList(
            context, Icon(Icons.info_outline), "INFORMAÇÕES", InfoPage(),
            solicitacoes: false),
        buildItemList(
            context, Icon(Icons.phone_callback), "FALE CONOSCO", ContatoPage(),
            solicitacoes: false),
        buildItemList(
          context,
          Icon(Icons.exit_to_app),
          "SAIR",
          InitialPage(),
          solicitacoes: false,
          matricula: int.parse(matricula),
        ),
      ],
    ),
  );
}

// Card Saldo Capital //

Widget _buildCard(int matricula, SaldoCapitalController saldoCapitalController,
    FormatMoney money, double alturaTela) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: Column(
      children: [
        SizedBox(
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
                  child: Text("Saldo Capital",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: alturaTela * 0.027,
                      ) //22.0),
                      ),
                ),
                GetX<SaldoCapitalController>(
                  initState: (state) {
                    saldoCapitalController.getSaldo(matricula);
                  },
                  builder: (_) {
                    return _.saldoCapital.length < 1
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : Text(
                            _.saldoCapital[0].saldo != null
                                ? money.formatterMoney(
                                    double.parse(_.saldoCapital[0].saldo))
                                : "R\$ 0,00",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: alturaTela * 0.062, //50.0,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.center,
                          );
                  },
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Widget _builMainBody(
  String matricula,
  EmpContratadosController empContratadosController,
  FormatMoney money,
  double alturaTela,
  BuildContext context,
) {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    physics: ClampingScrollPhysics(),
    child: Column(
      children: [
        Container(
          child: _buildSecondaryCard(
              "Empréstimos Contratados",
              int.parse(matricula),
              money,
              empContratadosController,
              alturaTela,
              context),
        ),
        SizedBox(
          height: alturaTela * 0.049, //40,
        ),
        SolicitationsTable(
          matricula: matricula,
          moneyFormat: money,
          solicitationsPage: false,
          solicPendentes: false,
        )
      ],
    ),
  );
}

// Card secundário Empréstimos Contratados

Widget _buildSecondaryCard(
    String title,
    int matricula,
    FormatMoney money,
    EmpContratadosController empContratadosController,
    double alturaTela,
    BuildContext context) {
  return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.07,
          vertical: alturaTela * 0.02),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.green[300], Colors.blue]),
          color: Colors.blue[200],
          borderRadius: BorderRadius.circular(30.0),
          border:
              Border.all(color: Colors.green[300].withOpacity(0.1), width: 2)),
      child: Column(children: [
        Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontSize: alturaTela * 0.03 /*24.0*/,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: alturaTela * 0.025, //20,
        ),
        GetX<EmpContratadosController>(
          initState: (state) =>
              {empContratadosController.getEmpContratados(matricula)},
          builder: (_) {
            return _.empContratados.length < 1
                ? Text("Nenhum empréstimo contratado no momento.")
                : Column(
                    children: [
                      _buildItemSecondaryCard(
                          "Quantidade",
                          Icon(Icons.data_usage,
                              size: 25.0, color: Colors.blue),
                          _.empContratados[0].quantidade.toString(),
                          alturaTela,
                          context),
                      SizedBox(
                        height: alturaTela * 0.025, //20,
                      ),
                      _buildItemSecondaryCard(
                          "Total contratado",
                          Icon(Icons.attach_money,
                              size: 25.0, color: Colors.blue),
                          _.empContratados[0].total == null
                              ? '0'
                              : money.formatterMoney(double.parse(
                                  _.empContratados[0].total.toString())),
                          alturaTela,
                          context),
                      SizedBox(
                        height: alturaTela * 0.025, //20,
                      ),
                      _buildItemSecondaryCard(
                          "Desconto total",
                          Icon(Icons.money_off, size: 25.0, color: Colors.blue),
                          _.empContratados[0].desconto == null
                              ? '0'
                              : money.formatterMoney(double.parse(
                                  _.empContratados[0].desconto.toString())),
                          alturaTela,
                          context),
                      SizedBox(
                        height: alturaTela * 0.025, //20,
                      )
                    ],
                  );
          },
        ),
        /* GetX<EmpContratadosController>(
          builder: (_) {
            return _.empContratados.length < 1
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : _buildItemSecondaryCard(
                    "Total contratado",
                    Icon(Icons.attach_money, size: 25.0, color: Colors.blue),
                    _.empContratados[0].total == null
                        ? '0'
                        : money.formatterMoney(
                            double.parse(_.empContratados[0].total)),
                    alturaTela,
                    context);
          },
        ),
        SizedBox(
          height: 20,
        ),
        GetX<EmpContratadosController>(
          builder: (_) {
            return _.empContratados.length < 1
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : _buildItemSecondaryCard(
                    "Desconto total",
                    Icon(Icons.money_off, size: 25.0, color: Colors.blue),
                    _.empContratados[0].desconto == null
                        ? '0'
                        : money.formatterMoney(_.empContratados[0].desconto),
                    alturaTela,
                    context);
          },
        ),
        SizedBox(
          height: alturaTela * 0.025, //20,
        ),*/
      ]));
}

// Item Card secundário Empréstimos Contratados

Widget _buildItemSecondaryCard(String title, Icon icon, String value,
    double alturaTela, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.073,
        vertical: alturaTela * 0.02),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        border:
            Border.all(color: Colors.green[300].withOpacity(0.1), width: 2)),
    child: Row(
      children: [
        icon,
        SizedBox(
          width: alturaTela * 0.012, //10.0,
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: alturaTela * 0.02, //16.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(
          width: alturaTela * 0.012,
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  color: Colors.black87.withOpacity(0.7),
                  fontSize: alturaTela * 0.02, //18.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    ),
  );
}
