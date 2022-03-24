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
          ? 'https://play.google.com/store/apps/details?id=com.copbayer_app'
          : 'https://apps.apple.com/us/app/copbayer/id1590404278';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Image.asset(
                  "images/versao.png",
                  fit: BoxFit.scaleDown,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
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
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
