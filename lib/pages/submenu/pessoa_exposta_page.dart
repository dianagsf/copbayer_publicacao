import 'package:copbayer_app/pages/submenu/widgets/dropdown_button.dart';
import 'package:copbayer_app/repositories/pessoa_exposta_repository.dart';
import 'package:copbayer_app/repositories/senha_repository.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class PessoaExpostaPage extends StatefulWidget {
  final String nome;
  final String cpf;
  final int matricula;

  const PessoaExpostaPage({
    Key key,
    @required this.nome,
    @required this.cpf,
    @required this.matricula,
  }) : super(key: key);

  @override
  _PessoaExpostaPageState createState() => _PessoaExpostaPageState();
}

class _PessoaExpostaPageState extends State<PessoaExpostaPage> {
  final formKey = new GlobalKey<FormState>();
  PessoaExpostaRepository pessoaExpostaRepository = PessoaExpostaRepository();
  final SenhaRepository senhaRepository = SenhaRepository();
  final TextEditingController senhaController = TextEditingController();

  TextEditingController nomeController = TextEditingController();
  MaskedTextController cpfController =
      MaskedTextController(mask: '000.000.000-00');
  MaskedTextController dataInicioController =
      MaskedTextController(mask: '00/00/0000');
  MaskedTextController dataTerminoController =
      MaskedTextController(mask: '00/00/0000');
  TextEditingController matriculaController = TextEditingController();

  TextEditingController nomeParenteController = TextEditingController();
  TextEditingController relacionamentoController = TextEditingController();

  String cargo;

  List<String> cargos = [
    'Defensor Público Geral da União',
    'Deputados Estaduais e Distritais',
    'Diretor de Autarquia Federal ou equivalente',
    'Diretor de Empresa Pública Federal ou equivalente',
    'Diretor de Fundação Pública Federal ou equivalente ',
    'Diretor de Sociedade de Economia Mista Federal ou equivalente',
    'Governadores, Deputados, Prefeitos e Vereadores',
    'Membros do Conselho Nacional de Justiça e do Ministérios Público',
    'Membro do Conselho Superior da Justiça do trabalho e da Justiça Federal',
    'Membro do Supremo Tribunal Federal',
    'Membro do Tribunal de Contas da União',
    'Membros dos Tribunais Regionais do Trabalho, Eleitorais e Federais',
    'Membro dos Tribunais Superiores',
    'Ministro de Estado',
    'Presidente da República',
    'Presidente de Assembleia Legislativa/Câmara Distrital',
    'Presidente de Autarquia Federal ou equivalente',
    'Presidente de Câmara Municipal de Capital de Estado',
    'Presidente de Conselho de Contas de Estado/Distrito Federal',
    'Presidente de Conselho de Contas de municípios',
    'Presidente de Empresa Pública Federal ou equivalente',
    'Presidente de Fundação Pública Federal ou equivalente',
    'Presidente de Sociedade de Economia Mista Federal ou equivalente',
    'Presidentes de Partidos Políticos',
    'Presidente de Tribunal de Contas de Estado/Distrito Federal',
    'Presidente de Tribunal de Contas de Municípios',
    'Presidente de Tribunal de Justiça',
    'Presidente de Tribunal Militar',
    'Procurador Geral Eleitoral',
    'Procurador-Geral da Justiça Militar',
    'Procurador-Geral da República',
    'Procurador-Geral de Justiça de Estado/Distrito Federal',
    'Procurador-Geral do Ministério Público junto ao TCU',
    'Procurador-Geral do Trabalho',
    'Secretários de Estado e do Distrito Federal',
    'Secretários Municipais',
    'Senador',
    'Subprocurador-Geral da República',
    'Subprocuradores-Gerais do Ministério Público junto ao TCU',
    'Tesoureiro Nacional de partidos políticos',
    'Vice-Governador',
    'Vice-Prefeito de Capital de Estado',
    'Vice-Presidente da República',
    'Vice-Presidente de Autarquia Federal',
    'Vice-Presidente de Câmara Municipal de Capital de Estado',
    'Vice-Presidente de Empresa Pública Federal',
    'Vice-Presidente de Fundação Pública Federal',
    'Vice-Presidente de Sociedade de Economia Mista Federal',
    'Vice-Procurador-Geral da República, de Justiça ou Eleitoral',
  ];

  int selectedRadio = 0;
  int protocolo;

  @override
  void initState() {
    super.initState();

    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  void handleChangeCargo(String value) {
    setState(() {
      cargo = value;
    });
  }

  String _validateTextField(String value) {
    if (value.isEmpty) {
      return '* Este campo é obrigatório.';
    }
    return null;
  }

  handlePessoaExposta() {
    var dataInicio;
    var dataIncioFormat;
    var dataFim;
    var dataFimFormat;

    if (dataInicioController.text.isNotEmpty &&
        dataTerminoController.text.isNotEmpty) {
      dataInicio = dataInicioController.text.replaceAll("/", "-").split("-");
      dataIncioFormat = "${dataInicio[2]}-${dataInicio[1]}-${dataInicio[0]}";

      dataFim = dataTerminoController.text.replaceAll("/", "-").split("-");
      dataFimFormat = "${dataFim[2]}-${dataFim[1]}-${dataFim[0]}";
    }

    if (selectedRadio == 0) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Você deve selecionar uma das opções.",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'OK',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      );
    }

    //SALVA SOLICITAÇÃO
    if (selectedRadio != 0) {
      Get.dialog(
        AlertDialog(
          title: Text("Confirme sua senha"),
          content: TextField(
            controller: senhaController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            FutureBuilder(
              future: senhaRepository.getSenha(widget.matricula),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return TextButton(
                    onPressed: () {
                      if (senhaController.text
                              .compareTo(snapshot.data[0].senha) ==
                          0) {
                        Future.delayed(Duration(seconds: 20));
                        //SALVA SOLICITAÇÃO

                        pessoaExpostaRepository.savePessoaExposta({
                          "numero": protocolo,
                          "matricula": widget.matricula,
                          "cargo": cargo != null ? cargo : null,
                          "dataInicio": dataIncioFormat != null
                              ? DateTime.parse(dataIncioFormat).toString()
                              : null,
                          "dataFim": dataFimFormat != null
                              ? DateTime.parse(dataFimFormat).toString()
                              : null,
                          "parente": nomeParenteController.text.isNotEmpty
                              ? nomeParenteController.text.toString()
                              : null,
                          "grauParentesco":
                              relacionamentoController.text.isNotEmpty
                                  ? relacionamentoController.text.toString()
                                  : null,
                          "data": DateTime.now().toString().substring(0, 19),
                        });

                        if (!Responsive.isDesktop(context)) Get.back();
                        Get.back();
                        Get.back();
                        Get.snackbar(
                          "Dados enviados com sucesso!",
                          "",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          padding: EdgeInsets.all(30),
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 4),
                        );
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

                        setState(() {
                          senhaController.text = '';
                        });
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
    }
  }

  @override
  Widget build(BuildContext context) {
    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("Pessoa Exposta"),
        ),
        backgroundColor: Colors.green[300],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isDesktop(context) ? alturaTela * 0.4 : 30,
              vertical: 30),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Preencha o formulário abaixo:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 30),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nome: ${widget.nome.toUpperCase()}",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "CPF: ${widget.cpf}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Matrícula: ${widget.matricula.toString()}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _infoText(),
                    const SizedBox(height: 30),
                    _options(
                      1,
                      selectedRadio,
                      'NÃO SOU PESSOA EXPOSTA',
                      ' e nem possuo vínculo ou relacionamento próximo com “Pessoa Politicamente Exposta”',
                      setSelectedRadio,
                    ),
                    const SizedBox(height: 30),
                    RichText(
                      text: TextSpan(
                        text: 'SIM, SOU PESSOA POLITICAMENTE EXPOSTA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: ' vez que (preencha abaixo): ',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _options(
                      2,
                      selectedRadio,
                      'DESEMPENHO ou DESEMPENHEI',
                      ' cargo, emprego ou função descrita nas opções abaixo:',
                      setSelectedRadio,
                    ),
                    selectedRadio == 2
                        ? CustomDropDownButton(
                            value: cargo,
                            list: cargos.map((c) => c).toList(),
                            handleChangeValue: handleChangeCargo,
                          )
                        : SizedBox.shrink(),
                    selectedRadio == 2
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    'Início',
                                    dataInicioController,
                                    _validateTextField,
                                    TextInputType.number,
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                  child: _buildTextField(
                                    'Término',
                                    dataTerminoController,
                                    _validateTextField,
                                    TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    const SizedBox(height: 30),
                    _options(
                      3,
                      selectedRadio,
                      'POSSUO ',
                      'vínculo ou relacionamento próximo com “Pessoa Politicamente Exposta”, conforme abaixo especificado:',
                      setSelectedRadio,
                    ),
                    const SizedBox(height: 30),
                    selectedRadio == 3
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              children: [
                                _buildTextField(
                                  'Nome da pessoa politicamente exposta',
                                  nomeParenteController,
                                  _validateTextField,
                                  TextInputType.name,
                                ),
                                const SizedBox(height: 20),
                                _buildTextField(
                                  'Natureza do relacionamento',
                                  relacionamentoController,
                                  _validateTextField,
                                  TextInputType.text,
                                ),
                                const SizedBox(height: 30),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        'Definição de familiares dada pelo art. 19°, § 1° da Circular 3.978: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            'pai, mãe, filhos(as), cônjuge (esposo ou esposa), companheiro(a) e enteados(as).',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        'Definição de pessoas de relacionamento próximo: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            'representante ou procurador da PPE, parentes não constantes do quadro anterior, assessores, sócios e profissionais que trabalham rotineiramente com a PPE.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Em caso de dúvidas sobre a definição de Pessoa Politicamente Exposta, acesse o link:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width > 400
                      ? Responsive.isDesktop(context)
                          ? MediaQuery.of(context).size.width * 0.4
                          : MediaQuery.of(context).size.width * 0.35
                      : MediaQuery.of(context).size.width * 0.3,
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _launchURL("http://appcopbayer.com.br/ppe/"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  icon: Icon(Icons.add),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      MediaQuery.of(context).size.width < 350
                          ? 'Detalhes sobre\nPPE'
                          : 'Detalhes sobre PPE',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                'Declaro, ainda, estar ciente de que eventuais alterações nas informações acima prestadas deverão ser por mim comunicadas de imediato à Copbayer.',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 50),
              Container(
                height: alturaTela * 0.055, //45,
                width: MediaQuery.of(context).size.width * 0.73,
                padding: EdgeInsets.symmetric(
                    horizontal:
                        Responsive.isDesktop(context) ? alturaTela * 0.5 : 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      handlePessoaExposta();
                    }
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
                      "Enviar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: alturaTela * 0.025,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TextField do formulário
Widget _buildTextField(
  String text,
  TextEditingController controller,
  Function validateTextField,
  TextInputType type,
) {
  return TextFormField(
    validator: validateTextField,
    controller: controller,
    keyboardType: type,
    decoration: InputDecoration(labelText: text),
  );
}

Widget _infoText() {
  return RichText(
    text: TextSpan(
      text: 'Em atenção ao disposto na ',
      style: TextStyle(color: Colors.black, fontSize: 18),
      children: [
        TextSpan(
          text: 'Lei n° 9613/98',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text:
              ', com objetivo de colaborar com a identificação, controle e acompanhamento dos negócios e movimentações financeiras das denominadas ',
        ),
        TextSpan(
          text: '“Pessoas Politicamente Expostas”, DECLARO, ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text:
              'para os devidos fins, e sob as penas da lei, que, nos últimos cinco anos e até esta data: ',
        ),
      ],
    ),
  );
}

Widget _options(
  int value,
  int selectedRadio,
  String option,
  String text,
  Function setSelectedRadio,
) {
  return RadioListTile(
    value: value,
    groupValue: selectedRadio,
    title: RichText(
      text: TextSpan(
        text: option,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16,
        ),
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    ),
    activeColor: Colors.blue[700],
    onChanged: (value) {
      setSelectedRadio(value);
    },
  );
}
