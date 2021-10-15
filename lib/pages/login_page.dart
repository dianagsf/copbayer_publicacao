import 'package:copbayer_app/pages/authentication_page.dart';
import 'package:copbayer_app/widgets/send_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:copbayer_app/amplifyconfiguration.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  MaskedTextController cpfController =
      MaskedTextController(mask: '000.000.000-00');
  MaskedTextController senhaController = MaskedTextController(mask: '000000');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  MaskedTextController cpfSenhaController =
      MaskedTextController(mask: '000.000.000-00');
  MaskedTextController dataNascController =
      MaskedTextController(mask: '00/00/0000');

  bool _obscureText = true;

  //CONFIGURAÇÃO INICIAL AMPLIFY STORAGE
  void _configureAmplify() async {
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyStorageS3 storagePlugin = AmplifyStorageS3();
    Amplify.addPlugin(authPlugin);
    Amplify.addPlugin(storagePlugin);

    try {
      await Amplify.configure(amplifyconfig);
      print('Successfully configured Amplify 🎉');
    } catch (e) {
      print('Could not configure Amplify ☠️');
    }
  }

  @override
  void initState() {
    super.initState();
    _configureAmplify();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /* @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        print("paused state");
        break;
      case AppLifecycleState.resumed:
        print("resumed state");
        break;
      case AppLifecycleState.inactive:
        print("inactive state");
        break;
      case AppLifecycleState.detached:
        print("detached state");
        break;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final alturaTela = MediaQuery.of(context)
        .size
        .height; //- MediaQuery.of(context).padding.top;

    _launchURL() async {
      const url = 'https://copbayer.com.br/associe-se';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Image.asset(
              "images/backgroundLogin.jpg",
              width: MediaQuery.of(context).size.width,
              repeat: ImageRepeat.repeatY,
            ),
            Positioned(
                top: alturaTela * 0.15, //100.0,
                left: 50.0,
                child: Text(
                  "Copbayer",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: alturaTela * 0.061, //50.0,
                      fontWeight: FontWeight.bold),
                )),
            Positioned(
              top: alturaTela * 0.31, //250,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: alturaTela * 0.055,
                  horizontal: MediaQuery.of(context).size.width * 0.06, //32.0,
                ),
                width: MediaQuery.of(context).size.width,
                height: alturaTela * 0.91,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(90),
                        topRight: Radius.circular(90))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: _validateCPF,
                        keyboardType: TextInputType.number,
                        controller: cpfController,
                        decoration: InputDecoration(
                            hintText: "CPF",
                            prefixIcon: Icon(Icons.account_circle)),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        obscureText: _obscureText,
                        controller: senhaController,
                        validator: _validateSenha,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Senha",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: _obscureText
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: TextButton(
                          onPressed: () {
                            Get.dialog(
                              buildDialog(
                                  cpfSenhaController, dataNascController),
                            );
                          },
                          child: Text(
                            "Esqueceu sua senha?",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: alturaTela * 0.05,
                      ),
                      SizedBox(
                        height: alturaTela * 0.062, //50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthPage(
                                    cpf: cpfController.text,
                                    senha: senhaController.text,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(color: Colors.green[300]),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: alturaTela * 0.03, //20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextButton(
                        onPressed: () {
                          _launchURL();
                          //Get.to(Cadastro());
                        },
                        child: Text(
                          "Ainda não é um associado? Cadastre-se!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: alturaTela * 0.02, //16.0,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: alturaTela * 0.12, //100.0,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

String _validateCPF(String value) {
  if (value.isEmpty) {
    return "Infome o CPF";
  }
  if (value.length != 14) {
    return "O CPF deve conter 11 dígitos";
  }

  return null;
}

String _validateSenha(String value) {
  if (value.isEmpty) {
    return "Infome a senha";
  }
  if (value.length != 6) {
    return "A senha deve conter 6 dígitos";
  }
  return null;
}

Widget buildDialog(MaskedTextController cpfSenhaController,
    MaskedTextController dataNascController) {
  return AlertDialog(
    title: Text("Informe seus dados:"),
    content: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: 200,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: cpfSenhaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "CPF:",
                prefixIcon: Icon(Icons.security_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: dataNascController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: "Data de Nascimento:",
                prefixIcon: Icon(Icons.date_range),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          print("cliquei!!!!!!!!");
          Get.to(() =>
            SendEmail(
              cpf: cpfSenhaController.text,
              dataNasc: dataNascController.text,
            ),
          );
        },
        child: Text("CONFIRMAR"),
      )
    ],
  );
}
