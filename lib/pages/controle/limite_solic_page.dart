import 'package:copbayer_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class LimiteSolicPage extends StatelessWidget {
  final String operacao;

  const LimiteSolicPage({
    Key key,
    @required this.operacao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);

    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: Text("Voltar"),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(top: 20),
                  child: Image.asset(
                    'images/limiteSolic_green.png',
                    width: 600,
                    height: 600,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: Responsive.isDesktop(context)
                      ? EdgeInsets.symmetric(horizontal: alturaTela * 0.4)
                      : EdgeInsets.zero,
                  child: Text(
                    operacao.compareTo("retirada de capital") == 0
                        ? 'A sua solicitação de $operacao realizada neste mês já está sendo analisada. Aguarde! A devolução do capital ocorrerá no dia 10 do próximo mês.'
                        : operacao.compareTo("alteração de capital") == 0
                            ? 'A sua solicitação de $operacao realizada neste mês já está sendo analisada. Aguarde!'
                            : operacao.compareTo("desligamento") == 0
                                ? 'Aguarde! A sua solicitação de $operacao realizada neste mês já está sendo analisada. Em casos de devolução do capital: a devolução ocorrerá no dia 10 do próximo mês.'
                                : 'A sua solicitação de $operacao realizada no dia $data já está sendo analisada. Tente novamente amanhã.',
                    style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 1.5,
                      color: Colors.green[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
