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
              Image.asset('images/limiteSolic_green.png'),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
