import 'package:copbayer_app/controllers/email_app_controller.dart';
import 'package:copbayer_app/pages/authentication_page.dart';
import 'package:copbayer_app/pages/controle/versao_page.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:copbayer_app/widgets/send_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // verifica se tá na WEB

//import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:copbayer_app/amplifyconfiguration.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class LoginPage extends StatefulWidget {
  final String versaoTabela;
  final String versaoApp;

  const LoginPage({
    Key key,
    this.versaoTabela,
    this.versaoApp,
  }) : super(key: key);

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

  //GET CREDENCIAIS E-MAIL APP
  EmailAppController emailAppController = Get.put(EmailAppController());

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

    //get e-mail e senha app
    emailAppController.getDadosEmailApp();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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

    _showSenha() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    return Scaffold(
      body: Responsive(
        mobile: buildLoginMobile(
          context,
          alturaTela,
          _launchURL,
          emailAppController,
        ),
        tablet: buildLoginMobile(
          context,
          alturaTela,
          _launchURL,
          emailAppController,
        ),
        desktop: buildLoginWeb(
          context,
          cpfController,
          senhaController,
          cpfSenhaController,
          dataNascController,
          _obscureText,
          alturaTela,
          _showSenha,
          _launchURL,
          _formKey,
          emailAppController,
        ),
      ),
    );
  }

  Widget buildLoginMobile(
    BuildContext context,
    double alturaTela,
    Function _launchURL,
    EmailAppController emailAppController,
  ) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          Image.asset(
            "images/backgroundLogin.jpg",
            width: MediaQuery.of(context).size.width,
            repeat: ImageRepeat.repeatX,
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
                              cpfSenhaController,
                              dataNascController,
                              emailAppController,
                            ),
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

                            print(
                                "VERSÃO APP = ${widget.versaoApp} // TABELA = ${widget.versaoTabela}");

                            if (!kIsWeb) {
                              if (widget.versaoApp != null &&
                                  widget.versaoTabela != null) {
                                if (widget.versaoApp
                                            .compareTo(widget.versaoTabela) ==
                                        1 ||
                                    widget.versaoApp
                                            .compareTo(widget.versaoTabela) ==
                                        0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AuthPage(
                                        cpf: cpfController.text,
                                        senha: senhaController.text,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NovaVersaoPage(),
                                    ),
                                  );
                                }

                                /*if (widget.versaoTabela
                                            .compareTo(widget.versaoApp) !=
                                        0 &&
                                    cpfController.text
                                            .compareTo('123.456.789-09') !=
                                        0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NovaVersaoPage(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AuthPage(
                                        cpf: cpfController.text,
                                        senha: senhaController.text,
                                      ),
                                    ),
                                  );
                                }*/
                              }
                            } else {
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
    );
  }
}

Widget buildLoginWeb(
  BuildContext context,
  MaskedTextController cpfController,
  MaskedTextController senhaController,
  MaskedTextController cpfSenhaController,
  MaskedTextController dataNascController,
  bool obscureText,
  double alturaTela,
  Function showSenha,
  Function launchURL,
  GlobalKey<FormState> formKey,
  EmailAppController emailAppController,
) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    child: Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            color: Colors.white,
            child: Image.asset(
              "images/login.png", //"images/loginWeb.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 56, 195, 89),
                  Colors.green[200],
                ],
              ),
            ),
            //color: Color.fromARGB(255, 56, 195, 89), //Color(0xFF23C7AC),
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: alturaTela * 0.15, vertical: alturaTela * 0.1),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Copbayer",
                        style: TextStyle(
                          fontSize: alturaTela * 0.08,
                          color: Color.fromARGB(
                              255, 56, 195, 89), //Color(0xFF23C7AC),
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Form(
                        key: formKey,
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
                              obscureText: obscureText,
                              controller: senhaController,
                              validator: _validateSenha,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Senha",
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: obscureText
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                  onPressed: () {
                                    showSenha();
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
                                      cpfSenhaController,
                                      dataNascController,
                                      emailAppController,
                                    ),
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
                              width: alturaTela * 0.35,
                              height: alturaTela * 0.062, //50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();

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
                                  primary: Color.fromARGB(
                                      255, 56, 195, 89), // Color(0xFF23C7AC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side: BorderSide(
                                      color: Color.fromARGB(255, 56, 195,
                                          89), //Color(0xFF23C7AC),
                                    ),
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
                                launchURL();
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
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

Widget buildDialog(
  MaskedTextController cpfSenhaController,
  MaskedTextController dataNascController,
  EmailAppController emailAppController,
) {
  return AlertDialog(
    title: Text("Informe o CPF e a Data de Nascimento:"),
    content: SingleChildScrollView(
      child: Container(
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
    ),
    actions: [
      TextButton(
        onPressed: () {
          print("cliquei!!!!!!!!");
          Get.to(
            () => SendEmail(
              cpf: cpfSenhaController.text,
              dataNasc: dataNascController.text,
              emailApp: emailAppController.emailApp[0].email,
              senhaEmailApp: emailAppController.emailApp[0].senha,
            ),
          );
        },
        child: Text("CONFIRMAR"),
      )
    ],
  );
}
