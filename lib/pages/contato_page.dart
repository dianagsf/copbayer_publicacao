import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContatoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _launchURL() async {
      const url = 'https://api.whatsapp.com/send?phone=5521972698237';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Fale Conosco",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green[300],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              MdiIcons.phoneClassic,
              size: 35,
              color: Colors.greenAccent[400],
            ),
            Text(
              "(21) 2189-0727 / 0726",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Text(
              "(21) 2189-0701 / 0561",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Icon(
              MdiIcons.at,
              size: 35,
              color: Colors.greenAccent[400],
            ),
            Text(
              "contato@copbayer.com.br",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Icon(
              MdiIcons.mapMarker,
              size: 35,
              color: Colors.greenAccent[400],
            ),
            Text(
              "Est. da Boa Esperanca, 650 \n Bom Pastor - Belford Roxo, RJ \n CEP 26110-120",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            Icon(
              MdiIcons.whatsapp,
              size: 35,
              color: Colors.greenAccent[400],
            ),
            Text(
              "(21) 97269-8237",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: _launchURL,
                icon: Icon(MdiIcons.whatsapp),
                label: Text("Whatsapp", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
