// Card Empréstimos Contratados
import 'package:flutter/material.dart';

Widget buildCardEmprestimo(String value, String title, Color color,
    double alturaTela, BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25.0),
    child: Card(
      elevation: 4,
      color: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.24, //100.0,
        height: alturaTela * 0.11, //90.0,
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: alturaTela * 0.02, //16.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: alturaTela * 0.012, //10,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: alturaTela * 0.016, //13.0,
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
