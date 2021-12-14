import 'package:copbayer_app/model/controle_model.dart';
import 'package:copbayer_app/pages/controle/error_connection.dart';
import 'package:copbayer_app/pages/controle/manutencao_page.dart';
import 'package:copbayer_app/pages/login_page.dart';
import 'package:copbayer_app/repositories/controle_repository.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final ControleRepository controleRepository = ControleRepository();
  Future<List<ControleModel>> controle;
  PackageInfo packageInfo;
  String version;

  _verificaVersao() async {
    packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;

    print("Versão = $version");
  }

  @override
  void initState() {
    super.initState();
    _verificaVersao();
    controle = controleRepository.getInfosControle();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controle,
      builder:
          (BuildContext context, AsyncSnapshot<List<ControleModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
            break;
          default:
            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return ErrorConnectionPage();
            } else {
              if (snapshot.data.isEmpty) {
                print("Error: ${snapshot.data}");
                return ErrorConnectionPage();
              } else {
                int index = snapshot.data.length - 1;
                if (snapshot.data[index].iNTEGRACAO == 1) {
                  return ManutencaoPage();
                } /*else if (snapshot.data[index].vERSAO.compareTo(version) !=
                    0) {
                  return NovaVersaoPage();
                }*/
                else {
                  return LoginPage(
                    versaoTabela: snapshot.data[index].vERSAO,
                    versaoApp: version,
                  );
                }
              }
            }
        }
      },
    );
  }
}
