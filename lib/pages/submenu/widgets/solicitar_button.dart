import 'dart:async';

import 'package:copbayer_app/repositories/senha_repository.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SolicitarButton extends StatelessWidget {
  final Function handleSolicitar;
  final int matricula;

  SolicitarButton({
    this.handleSolicitar,
    this.matricula,
  });

  final TextEditingController controller = TextEditingController();
  final SenhaRepository senhaRepository = SenhaRepository();

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      height: alturaTela * 0.055, //45,
      width: MediaQuery.of(context).size.width * 0.73,
      padding: Responsive.isDesktop(context)
          ? EdgeInsets.symmetric(horizontal: alturaTela * 0.3)
          : EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: () {
          return Get.dialog(
            AlertDialog(
              title: Text("Confirme sua senha"),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                FutureBuilder(
                  future: senhaRepository.getSenha(matricula),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return TextButton(
                        onPressed: () {
                          if (controller.text
                                  .compareTo(snapshot.data[0].senha) ==
                              0) {
                            Future.delayed(Duration(seconds: 20));
                            // VOLTAR PRA HOME
                            if (!Responsive.isDesktop(context)) Get.back();
                            Get.back();
                            Get.back();

                            Get.snackbar(
                              "Seu pedido foi realizado com sucesso!",
                              "",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              padding: EdgeInsets.all(30),
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 4),
                            );

                            if (handleSolicitar != null) handleSolicitar();
                          } else {
                            Get.back();

                            Get.snackbar(
                              "Senha incorreta!",
                              "Tente novamente.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              padding: EdgeInsets.all(30),
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 4),
                            );

                            controller.text = '';
                          }
                        },
                        child: Text("CONFIRMAR"),
                      );
                    }
                    return Container();
                  },
                )
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
    );
  }
}
