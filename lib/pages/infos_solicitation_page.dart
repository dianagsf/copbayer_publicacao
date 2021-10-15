import 'dart:async';
import 'dart:io';

import 'package:copbayer_app/controllers/fechamento_folha_controller.dart';
import 'package:copbayer_app/repositories/senha_repository.dart';
import 'package:copbayer_app/repositories/solic_post_repository.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/utils/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfosSolicitacaoPage extends StatefulWidget {
  final String matricula;
  final List<Map<String, dynamic>> solicitacaoInfo;
  final String saldoCapital;
  final String saldoDevedor;
  final int protocolo;
  final String situacao;

  const InfosSolicitacaoPage({
    Key key,
    this.matricula,
    this.solicitacaoInfo,
    this.saldoCapital,
    this.saldoDevedor,
    @required this.protocolo,
    @required this.situacao,
  }) : super(key: key);

  @override
  _InfosSolicitacaoPageState createState() => _InfosSolicitacaoPageState();
}

class _InfosSolicitacaoPageState extends State<InfosSolicitacaoPage> {
  String valorFinanciado;

  String valorDesconto;
  String valorLiquido;
  double iof = 0.0;

  bool regra;
  FormatMoney money = FormatMoney();

  FechamentoFolhaController fechamentoFolhaController = Get.find();
  final SenhaRepository senhaRepository = SenhaRepository();
  final TextEditingController senhaController = TextEditingController();

  // ANEXOS
  List<File> _images = [];
  final picker = ImagePicker();
  StorageService _storageService = StorageService();

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 70);

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      } else {
        print('Nenhuma imagem selecionada.');
      }
    });
  }

  _uploadImages() {
    for (int i = 0; i < _images.length; i++) {
      _storageService.uploadImageAtPath(
        _images[i].path,
        int.parse(widget.matricula),
        "simulacaoEmprestimo",
        protocolo: widget.protocolo,
        numero: i + 1,
      );
    }
  }

  void handleDeleteImage(File img) {
    setState(() {
      _images.remove(img);
    });
  }

  double calculaIOF(double valorFinanciado) {
    double iofAdicional = 0.0;
    double fatorIOF =  0.01118 / 100;
    double valorAmortizacao =
        (double.parse(widget.solicitacaoInfo[0]['solicitacao']) /
                int.parse(widget.solicitacaoInfo[0]['parcela']))
            .toPrecision(2);

    int np = int.parse(widget.solicitacaoInfo[0]['parcela']);

    double juros = 0.0;

    var now = DateTime.now();

    var ultimoDiaMes;
    var dataCredito = DateTime(now.year, now.month, now.day)
        .add(Duration(days: 1)); //DIA SEGUINTE
    DateTime dataPrimeiraPrestacao;
    var fimmes = fechamentoFolhaController.fechamentoFolha[0].fimmes;

    if (fimmes == 0) {
      ultimoDiaMes = DateTime(now.year, now.month + 1, 0).day;
      dataPrimeiraPrestacao = DateTime(now.year, now.month, ultimoDiaMes);
    } else {
      ultimoDiaMes = DateTime(now.year, now.month + 2, 0).day;
      dataPrimeiraPrestacao = DateTime(now.year, now.month + 1, ultimoDiaMes);
    }

    int dias = dataPrimeiraPrestacao.difference(dataCredito).inDays + 1;
    var taxaJuros = 2;
    var saldo = 0.0;
    var xiof = 0.0;
    DateTime dataVencimento = DateTime.parse(dataPrimeiraPrestacao.toString());
    int diasIOF;
    var ultimoDia;

    if (dias > 30) {
      juros = (valorFinanciado * taxaJuros / 100) / 30 * (dias - 30);
      saldo = valorFinanciado + juros;
    } else {
      saldo = valorFinanciado;
    }

    for (int i = 0; i < np; i++) {
      diasIOF = dataVencimento.difference(dataCredito).inDays;

      if (diasIOF >= 365) diasIOF = 365;

      xiof = valorAmortizacao * fatorIOF * diasIOF;

      iofAdicional = iofAdicional + xiof;

      ultimoDia =
          DateTime(dataVencimento.year, dataVencimento.month + 2, 0).day;

      dataVencimento =
          DateTime(dataVencimento.year, dataVencimento.month + 1, ultimoDia);
    }

    return iofAdicional.toPrecision(2);
  }

  double calculaDesconto(double valorSolicitado) {
    var now = DateTime.now();

    var ultimoDiaMes;
    var dataCredito = DateTime(now.year, now.month, now.day + 1); //DIA SEGUINTE
    var dataPrimeiraPrestacao;
    var fimmes = fechamentoFolhaController.fechamentoFolha[0].fimmes;

    if (fimmes == 0) {
      ultimoDiaMes = DateTime(now.year, now.month + 1, 0).day;
      dataPrimeiraPrestacao = DateTime(now.year, now.month, ultimoDiaMes);
    } else {
      ultimoDiaMes = DateTime(now.year, now.month + 2, 0).day;
      dataPrimeiraPrestacao = DateTime(now.year, now.month + 1, ultimoDiaMes);
    }

    double taxaJuros = 2 / 100;
    double saldo = valorSolicitado;
    int np = int.parse(widget.solicitacaoInfo[0]['parcela']);
    double amortizacao = (saldo / np);
    double jurosTotal = 0.0;
    double j = 0.0;
    int dias = dataPrimeiraPrestacao.difference(dataCredito).inDays;

    for (int i = 1; i <= np; i++) {
      if (i == 1) {
        j = (((valorSolicitado * taxaJuros) / 30) * dias).toPrecision(2);
      } else {
        saldo = saldo - amortizacao;

        j = (saldo * taxaJuros).toPrecision(2);
      }

      jurosTotal = jurosTotal + j;
    }

    jurosTotal = (jurosTotal / np).toPrecision(2);

    return (amortizacao + jurosTotal).toPrecision(2);
  }

  calculaValores(List<Map<String, dynamic>> solicitacaoInfo) {
    //CALCULA DESCONTO
    valorDesconto =
        calculaDesconto(double.parse(solicitacaoInfo[0]['solicitacao']))
            .toString();

    double iofAdicional = calculaIOF(
        double.parse(solicitacaoInfo[0]['solicitacao'])); //IOF ADICIONAL

    // CALCULO DO IOF
    iof = ((0.38 / 100) * double.parse(solicitacaoInfo[0]['solicitacao']) +
            iofAdicional)
        .toPrecision(2);

    print("IOF ADICIONAL = $iofAdicional");
    print("IOF = $iof");

    //CALCULA VALOR FINANCIADO
    valorFinanciado =
        (double.parse(solicitacaoInfo[0]['solicitacao'])).toString();

    // VALOR LÍQUIDO
    valorLiquido =
        (double.parse(solicitacaoInfo[0]['solicitacao']) - iof).toString();
  }

  @override
  void initState() {
    super.initState();
    calculaValores(widget.solicitacaoInfo);
    //valorFinanciado = money.formatterMoney(double.parse(valorFinanciado));
    valorDesconto = money.formatterMoney(double.parse(valorDesconto));
    valorLiquido = money.formatterMoney(double.parse(valorLiquido));
    regra = false;
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    handleCancel() {
      Get.back();
    }

    bool verificaRegra() {
      double salario = widget.solicitacaoInfo[0]['salario'] != null
          ? double.parse(widget.solicitacaoInfo[0]['salario'])
          : 0.0;
      double saldoCapital =
          widget.saldoCapital != null ? double.parse(widget.saldoCapital) : 0.0;
      double saldoDevedor =
          widget.saldoDevedor != null ? double.parse(widget.saldoDevedor) : 0.0;
      double regraGeral = (2 * salario + saldoCapital) - saldoDevedor;
      //(2 * salario + saldoCapital) - saldoDevedor >= valorFinanciado;
      print("############ REGRA");
      print(
          "= (2 * $salario + $saldoCapital) - $saldoDevedor >= $valorFinanciado");
      if (regraGeral.compareTo(double.parse(valorFinanciado)) == 1 ||
          regraGeral.compareTo(double.parse(valorFinanciado)) == 0) {
        return true;
      }

      return false;
    }

    saveSolicitacao() {
      Future<int> postSolic;
      SolicPostRepository _repositorySolicPost = SolicPostRepository();

      Get.back();
      Get.back();
      Get.back();
      Get.back();

      postSolic = _repositorySolicPost.createSolic(
        {
          ...widget.solicitacaoInfo[0],
          "anexos": _images.length,
          "iof": iof,
        },
      );

      if (postSolic != null) {
        Get.snackbar(
            "Aguarde!", "Sua solicitação está sendo analisada pela Diretoria.",
            colorText: Colors.white,
            backgroundColor: Colors.green[700],
            snackPosition: SnackPosition.BOTTOM);
      }
    }

    showSenhaDialog() {
      //VERIFICA QUANTIDADE ANEXOS APOSENTADO
      if (widget.situacao != null &&
          widget.situacao.compareTo('A') == 0 &&
          _images.length < 1) {
        Get.dialog(
          AlertDialog(
            title: Text("Atenção!"),
            content: Text(
              "Você deve adicionar o demonstrativo do pagamento do INSS ou extrato da conta bancária que recebe a aposentadoria.",
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

      //VERIFICA QUANTIDADE ANEXOS ASSOCIADO
      if (widget.situacao == null ||
          widget.situacao.compareTo('A') != 0) if (_images.length < 3) {
        Get.dialog(
          AlertDialog(
            title: Text("Atenção!"),
            content: Text(
              "Você deve adicionar pelo menos os 3 últimos contra-cheques.",
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

      //SALVA SOLIC APOSENTADO
      if (widget.situacao != null &&
          widget.situacao.compareTo("A") == 0 &&
          _images.length >= 1) {
        _uploadImages();
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
                future: senhaRepository.getSenha(int.parse(widget.matricula)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return TextButton(
                      onPressed: () {
                        if (senhaController.text
                                .compareTo(snapshot.data[0].senha) ==
                            0) {
                          Future.delayed(Duration(seconds: 20));
                          // VOLTAR PRA HOME
                          saveSolicitacao();
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

      //SALVA SOLIC ASSOCIADO
      if (widget.situacao == null || widget.situacao.compareTo("A") != 0) {
        if (_images.length >= 3) {
          _uploadImages();
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
                  future: senhaRepository.getSenha(int.parse(widget.matricula)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return TextButton(
                        onPressed: () {
                          if (senhaController.text
                                  .compareTo(snapshot.data[0].senha) ==
                              0) {
                            Future.delayed(Duration(seconds: 20));
                            // VOLTAR PRA HOME
                            saveSolicitacao();
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
    }

    handleSolicitacao() {
      bool regraGeral = verificaRegra();

      if (regraGeral) {
        Get.dialog(AlertDialog(
          title: Text(
              "Atenção: O valor solicitado está acima do teto disponível!"),
          content: Text("Deseja continuar mesmo assim?"),
          actions: [
            TextButton(
              child: Text("NÃO"),
              onPressed: () {
                Get.back();
                Get.back();
                Get.back();
                Get.snackbar("Solicitação não realizada!", "",
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
            TextButton(
              child: Text("SIM"),
              onPressed: () {
                Get.back();
                showSenhaDialog();
              },
            ),
          ],
        ));
      } else {
        showSenhaDialog();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitação de empréstimo"),
        backgroundColor: Colors.green[300],
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Text(
                "Solicitação de Empréstimo",
                style: TextStyle(
                    fontSize: 26.0,
                    color: Colors.green[300],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.0,
              ),
              _buildCardInfo("Valor Financiado", Icons.attach_money,
                  money.formatterMoney(double.parse(valorFinanciado))),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 5.0,
              ),
              _buildCardInfo("Estimativa de Desconto em Folha", Icons.money_off,
                  valorDesconto),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 5.0,
              ),
              _buildCardInfo(
                  "IOF", Icons.info, money.formatterMoney(iof)), //CALCULAR IOF
              SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 5.0,
              ),
              _buildCardInfo(
                  "Estimativa de Valor Líquido", Icons.payment, valorLiquido),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 5.0,
              ),
              SizedBox(
                height: 50.0,
              ),

              /*_buildCardInfo("Número de anexos", Icons.file_copy_outlined,
                  widget.qtdeAnexos.toString()),*/

              /// ANEXOS!!!!
              Container(
                padding: const EdgeInsets.only(left: 20, top: 20),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Anexar os arquivos",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.green[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Os documentos a serem anexados são: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("1. Contra-cheque/Holerite (3 últimos)"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "2. Demonstrativo de saldo devedor/consignado (se tiver)"),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Para os aposentados, é preciso: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        "1. Demonstrativo do pagamento do INSS ou extrato da conta bancária que recebe a aposentadoria"),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            getImage();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Anexar documentos",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: alturaTela * 0.019),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.036,
                              ),
                              Icon(
                                Icons.note_add,
                                size: alturaTela * 0.025,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "${_images.isNotEmpty ? _images.length : 0} anexo(s)",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    ..._images.map((img) {
                      return Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            constraints:
                                BoxConstraints(maxHeight: 60.0, maxWidth: 50.0),
                            child: Image.file(
                              img,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text("anexo.jpg"),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () => handleDeleteImage(img),
                          )
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton("CANCELAR", Colors.red, handleCancel),
                  _buildButton(
                      "SOLICITAR", Colors.green[300], handleSolicitacao),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

Widget _buildCardInfo(String title, IconData icon, String value) {
  return Padding(
    padding: EdgeInsets.only(top: 40.0, left: 20.0),
    child: Row(
      children: [
        Container(
          height: 45.0,
          width: 45.0,
          decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.all(Radius.circular(60.0))),
          child: Icon(
            icon,
            size: 25.0,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Text(
            "$title",
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ),
        SizedBox(
          width: 25.0,
        ),
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: Text(
            "$value",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        )
      ],
    ),
  );
}

Widget _buildButton(String text, Color color, Function function) {
  return Container(
    padding: EdgeInsets.only(top: 100.0, bottom: 30),
    child: SizedBox(
      height: 40.0,
      width: 140.0,
      child: ElevatedButton(
        onPressed: () {
          function();
        },
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: BorderSide(color: color),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ),
  );
}
