import 'package:flutter/material.dart';

class FechamentoFolhaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              Image.asset('images/fechamentoFolha.png'),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'A folha está fechada. Retorne o pedido no próximo mês.',
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
