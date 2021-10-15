import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NovaVersaoPage extends StatefulWidget {
  @override
  _NovaVersaoPageState createState() => _NovaVersaoPageState();
}

class _NovaVersaoPageState extends State<NovaVersaoPage> {
  @override
  Widget build(BuildContext context) {
    _launchURL() async {
      var url = Platform.isAndroid
          ? 'https://play.google.com/store?hl=pt_BR&gl=BR'
          : 'https://www.apple.com/br/app-store/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/versao.png",
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Seu app está desatualizado! Baixe a nova versão para continuar.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _launchURL,
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red),
                ),
              ),
              child: Text(
                "Baixar nova versão",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
