import 'package:flutter/material.dart';

class ErrorConnectionPage extends StatelessWidget {
  const ErrorConnectionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.bottomCenter,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Image.asset(
                  "images/error_connection.png",
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Ops!",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headline4.fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Algo deu errado na conexão.",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headline6.fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
