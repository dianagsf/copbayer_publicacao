import 'dart:io';
import 'dart:typed_data';

import 'package:copbayer_app/controllers/devedor_controller.dart';
import 'package:copbayer_app/controllers/fechamento_folha_controller.dart';
import 'package:copbayer_app/controllers/pedido_quitacao_controller.dart';
import 'package:copbayer_app/controllers/proposta_controller.dart';
import 'package:copbayer_app/controllers/saldo_capital_controller.dart';
import 'package:copbayer_app/model/fechamento_folha_model.dart';
import 'package:copbayer_app/model/proposta_model.dart';
import 'package:copbayer_app/pages/controle/fechamento_folha.dart';
import 'package:copbayer_app/pages/submenu/widgets/infos_devedor.dart';
import 'package:copbayer_app/repositories/post_image_web.dart';
import 'package:copbayer_app/repositories/quitacao_repository.dart';
import 'package:copbayer_app/repositories/senha_repository.dart';
import 'package:copbayer_app/utils/format_money.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:copbayer_app/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // verifica se tá na WEB

class QuitacaoPage extends StatefulWidget {
  final int matricula;

  const QuitacaoPage({
    Key key,
    @required this.matricula,
  }) : super(key: key);
  @override
  _QuitacaoPageState createState() => _QuitacaoPageState();
}

class _QuitacaoPageState extends State<QuitacaoPage> {
  FormatMoney money = FormatMoney();
  final ScrollController _scrollController = ScrollController();
  final SaldoCapitalController saldoCapitalController = Get.find();
  final SaldoDevedorController saldoDevedorController = Get.find();
  final FechamentoFolhaController fechamentoFolhaController = Get.find();
  final PedidoQuitacaoController pedidoQuitacaoController = Get.find();

  final TextEditingController senhaController = TextEditingController();
  final SenhaRepository senhaRepository = SenhaRepository();

  File _image;
  final picker = ImagePicker();
  StorageService _storageService = StorageService();

  bool anexoGaleria = false;

  //WEB
  Uint8List _imageWeb;
  FilePickerResult pickedFile;
  ImagePostRepository imagePostRepository = ImagePostRepository();

  QuitacaoRepository quitacaoRepository = QuitacaoRepository();
  int selectedRadio = 0;
  double total = 0.0;
  bool isDevedor = false;
  double totalQuitacao = 0.0;
  bool infosDevedor = false;
  double valQuitacao = 0.0;
  double capitalRestante = 0.0;
  double valorPagar = 0.0;

  double saldoCapitalDisp = 0.0;
  double deixarSaldo = 0.0;

  int protocolo;

  List<PropostaModel> selectedEmp = [];

  List<String> tableHeaderQuitacao = [
    "Número",
    "Data",
    "Val. p/ Quitação",
    "Principal",
    "Prestação",
    "NPC",
    "NPF",
    "Líquido Cred.",
    "Devedor Principal",
  ];

  @override
  void initState() {
    super.initState();

    if (saldoDevedorController.saldoDevedor[0].devedor != null &&
        saldoDevedorController.saldoDevedor[0].devedor != 0) {
      isDevedor = true;
    } else {
      isDevedor = false;
    }

    deixarSaldo = double.parse(
        fechamentoFolhaController.fechamentoFolha[0].faixaA.toString());

    saldoCapitalDisp = saldoCapitalController.saldoCapital[0].saldo != null
        ? double.parse(saldoCapitalController.saldoCapital[0].saldo) -
            deixarSaldo // 48,00
        : 0.0;

    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;

    pedidoQuitacaoController.getPedidosQuitacao();
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  escolherGaleriaFoto(Function getImage, Function getImageWeb) {
    Get.dialog(
      AlertDialog(
        title: Text("Escolha uma forma de enviar o comprovante:"),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        anexoGaleria = true;
                        getImageWeb();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.pink),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 25,
                        ),
                        Text(
                          "Galeria",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        anexoGaleria = false;
                        getImage();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 25,
                        ),
                        Text(
                          "Câmera",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ],
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

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 70);

    setState(
      () {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );

    Get.back();
  }

  handleDeleteImage() {
    setState(() {
      _image = null;
    });
  }

  _uploadComprovante() {
    _storageService.uploadComprovante(
      _image.path,
      widget.matricula,
      "comprovanteQuitacao",
      protocolo: protocolo,
    );
  }

  ///// WEB
  Future getImageWeb() async {
    pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    setState(
      () {
        if (pickedFile != null) {
          _imageWeb = kIsWeb
              ? pickedFile.files.single.bytes
              : File(pickedFile.files.single.path).readAsBytesSync();
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );

    if (!kIsWeb) Get.back();
  }

  handleDeleteImageWeb() {
    setState(() {
      _imageWeb = null;
    });
  }

  _uploadComprovanteWeb() {
    String extensaoArq = pickedFile.files.first.extension.toString();

    if (_imageWeb != null) {
      imagePostRepository.uploadImage(
        _imageWeb,
        protocolo,
        "comprovante",
        "comprovanteQuitacao",
        "quitacao",
        extensaoArq,
      );
    }
  }

  showSenhaDialog() {
    if (selectedRadio == 0) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Informe se deseja usar o saldo devedor para quitação.",
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

    if (selectedEmp.length == 0) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Selecione os empréstimos que deseja quitar.",
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

    if ((selectedRadio == 2 ||
        total > double.parse(saldoCapitalController.saldoCapital[0].saldo))) {
      if (Responsive.isDesktop(context) || kIsWeb || anexoGaleria) {
        if (_imageWeb == null) {
          Get.dialog(
            AlertDialog(
              title: Text("Atenção!"),
              content: Text(
                "Adicione o comprovante.",
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
      } else {
        if (_image == null) {
          Get.dialog(
            AlertDialog(
              title: Text("Atenção!"),
              content: Text(
                "Você deve anexar o comprovante de quitação.",
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      }
    }

    if (selectedRadio != 0 && selectedEmp.length != 0) {
      if ((selectedRadio == 2 ||
              total >
                  double.parse(saldoCapitalController.saldoCapital[0].saldo)) &&
          (_image != null || _imageWeb != null)) {
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

                          for (int i = 0; i < selectedEmp.length; i++) {
                            if (i == 0) {
                              quitacaoRepository.savePedidoQuitacao({
                                "numero": protocolo,
                                "data":
                                    DateTime.now().toString().substring(0, 19),
                                "valor": total,
                                "matricula": widget.matricula,
                                "usarCapital": selectedRadio == 1 ? 'S' : 'N',
                                "emprestimo": selectedEmp[i].numero,
                                "unico": 1,
                                "valorPagar":
                                    selectedRadio == 1 ? valorPagar : total,
                                "capitalDisponivel": selectedRadio == 1
                                    ? capitalRestante
                                    : saldoCapitalDisp,
                              });
                            } else {
                              quitacaoRepository.savePedidoQuitacao({
                                "numero": protocolo,
                                "data":
                                    DateTime.now().toString().substring(0, 19),
                                "valor": total,
                                "matricula": widget.matricula,
                                "usarCapital": selectedRadio == 1 ? 'S' : 'N',
                                "emprestimo": selectedEmp[i].numero,
                                "valorPagar":
                                    selectedRadio == 1 ? valorPagar : total,
                                "capitalDisponivel": selectedRadio == 1
                                    ? capitalRestante
                                    : saldoCapitalDisp,
                              });
                            }
                          }

                          Responsive.isDesktop(context) ||
                                  kIsWeb ||
                                  anexoGaleria
                              ? _uploadComprovanteWeb()
                              : _uploadComprovante();

                          if (!Responsive.isDesktop(context)) Get.back();
                          Get.back();
                          Get.back();
                          Get.snackbar(
                            "Sua solicitação foi enviada com sucesso!",
                            "Em breve entraremos em contato.",
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
      } else if (selectedRadio == 1 &&
          (total <
              double.parse(saldoCapitalController.saldoCapital[0].saldo))) {
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

                          for (int i = 0; i < selectedEmp.length; i++) {
                            if (i == 0) {
                              quitacaoRepository.savePedidoQuitacao({
                                "numero": protocolo,
                                "data":
                                    DateTime.now().toString().substring(0, 19),
                                "valor": total,
                                "matricula": widget.matricula,
                                "usarCapital": selectedRadio == 1 ? 'S' : 'N',
                                "emprestimo": selectedEmp[i].numero,
                                "unico": 1,
                                "valorPagar":
                                    selectedRadio == 1 ? valorPagar : total,
                                "capitalDisponivel": selectedRadio == 1
                                    ? capitalRestante
                                    : saldoCapitalDisp,
                              });
                            } else {
                              quitacaoRepository.savePedidoQuitacao({
                                "numero": protocolo,
                                "data":
                                    DateTime.now().toString().substring(0, 19),
                                "valor": total,
                                "matricula": widget.matricula,
                                "usarCapital": selectedRadio == 1 ? 'S' : 'N',
                                "emprestimo": selectedEmp[i].numero,
                                "valorPagar":
                                    selectedRadio == 1 ? valorPagar : total,
                                "capitalDisponivel": selectedRadio == 1
                                    ? capitalRestante
                                    : saldoCapitalDisp,
                              });
                            }
                          }

                          /*Responsive.isDesktop(context) ||
                                  kIsWeb ||
                                  anexoGaleria
                              ? _uploadComprovanteWeb()
                              : _uploadComprovante();*/

                          if (!Responsive.isDesktop(context)) Get.back();
                          Get.back();
                          Get.back();
                          Get.snackbar(
                            "Sua solicitação foi enviada com sucesso!",
                            "Em breve entraremos em contato.",
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
  }

  String calculaTotalQuitacao() {
    double saldoCapital =
        double.parse(saldoCapitalController.saldoCapital[0].saldo) -
            deixarSaldo; // 48,00

    if (total > saldoCapital) {
      totalQuitacao = total - saldoCapital;
      infosDevedor = true;
      capitalRestante = 0.0;
      valorPagar = totalQuitacao;
    } else {
      totalQuitacao = saldoCapital - total;
      infosDevedor = false;
      capitalRestante = totalQuitacao;
      valorPagar = 0.0;
    }

    return money.formatterMoney(totalQuitacao);
  }

  handleChangeCheckBox(bool value, PropostaModel prop) async {
    List<int> pedidosEmAnalise = [];
    pedidoQuitacaoController.pedidosQuitacao.forEach((pedidoEmAnalise) {
      pedidosEmAnalise.add(pedidoEmAnalise.emprestimo);
    });

    if (pedidosEmAnalise.contains(prop.numero)) {
      Get.defaultDialog(
        title: 'Atenção!',
        titleStyle: TextStyle(fontSize: 18),
        content: Text(
          'Você já realizou o pedido de quitação do empréstimo ${prop.numero} e sua solicitação já está sendo analisada.',
          style: TextStyle(fontSize: 18),
        ),
        confirm: TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'OK',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    } else {
      setState(() {
        valQuitacao = double.parse(prop.valorQuitacao.toString());
        if (value) {
          selectedEmp.add(prop);
          total = total + valQuitacao;
        } else {
          selectedEmp.remove(prop);
          total = total - valQuitacao;
        }
      });
    }

    print('total = $total');
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return GetX<FechamentoFolhaController>(builder: (_) {
      return handleFechamentoFolha(_.fechamentoFolha)
          ? FechamentoFolhaPage()
          : Scaffold(
              appBar: AppBar(
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("Pedido de Quitação"),
                ),
                backgroundColor: Colors.green[300],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        "Empréstimos em Vigor",
                        style: TextStyle(
                          color: Colors.green[400],
                          fontSize: alturaTela * 0.027, //24.0 : 22.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Scrollbar(
                      thumbVisibility: true,
                      thickness: 3,
                      controller: _scrollController,
                      radius: Radius.circular(40),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        child: _buildTable(
                          tableHeaderQuitacao,
                          money,
                          handleChangeCheckBox,
                          selectedEmp,
                          alturaTela,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    buildCardInfo(
                      Icons.attach_money,
                      "Saldo Capital Disponível",
                      money.formatterMoney(saldoCapitalDisp),
                      Colors.blue,
                      alturaTela,
                    ),
                    buildCardInfo(
                      Icons.money_off,
                      "Saldo Devedor",
                      saldoDevedorController.saldoDevedor[0].devedor != null
                          ? money.formatterMoney(double.parse(
                              saldoDevedorController.saldoDevedor[0].devedor
                                  .toString()))
                          : 'R\$ 0,00',
                      Colors.red[400],
                      alturaTela,
                    ),
                    Padding(
                      padding: Responsive.isDesktop(context)
                          ? EdgeInsets.symmetric(
                              horizontal: alturaTela * 0.3, vertical: 20)
                          : const EdgeInsets.all(20.0),
                      child: Card(
                        elevation: 5,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedRadio == 1 &&
                                        total <
                                            double.parse(saldoCapitalController
                                                .saldoCapital[0].saldo)
                                    ? "Saldo Restante de Capital"
                                    : "Total a pagar",
                                style: TextStyle(
                                  fontSize: alturaTela * 0.022,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                selectedRadio == 1
                                    ? calculaTotalQuitacao()
                                    : money.formatterMoney(total),
                                //calculaTotalQuitacao(),
                                /*selectedRadio == 1
                              ? calculaTotalQuitacao()
                                 
                              : saldoDevedorController.saldoDevedor[0].devedor !=
                                      null
                                  ? money.formatterMoney(double.parse(
                                      saldoDevedorController
                                          .saldoDevedor[0].devedor
                                          .toString()))
                                  : 'R\$ 0,00',*/
                                style: TextStyle(
                                  fontSize: alturaTela * 0.022,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    isDevedor
                        ? Container(
                            padding: Responsive.isDesktop(context)
                                ? EdgeInsets.symmetric(
                                    horizontal: alturaTela * 0.3, vertical: 20)
                                : const EdgeInsets.all(20),
                            child: Text(
                              "Deseja usar o saldo capital para quitação do saldo devedor?",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 20,
                    ),
                    isDevedor
                        ? Container(
                            width: double.infinity,
                            margin: Responsive.isDesktop(context)
                                ? EdgeInsets.only(left: alturaTela * 0.5)
                                : EdgeInsets.zero,
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    value: 1,
                                    groupValue: selectedRadio,
                                    title: Text("SIM"),
                                    activeColor: Colors.blue[700],
                                    onChanged: (value) {
                                      setSelectedRadio(value);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    value: 2,
                                    groupValue: selectedRadio,
                                    title: Text("NÃO"),
                                    activeColor: Colors.blue[700],
                                    onChanged: (value) {
                                      setSelectedRadio(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    const SizedBox(height: 20),
                    isDevedor && selectedRadio == 2 || infosDevedor
                        ? InfosDevedor(
                            matricula: widget.matricula,
                            protocolo: protocolo,
                            quitacaoPage: true,
                            valor: total != null
                                ? selectedRadio == 2
                                    ? money.formatterMoney(total)
                                    : money.formatterMoney(totalQuitacao)
                                : "R\$ 0,00",
                            usarCapital: selectedRadio == 1 ? 'S' : 'N',
                            emprestimos: selectedEmp,
                          )
                        : SizedBox.shrink(),
                    isDevedor && selectedRadio == 2 || infosDevedor
                        ? buildAnexo(
                            alturaTela,
                            getImage,
                            getImageWeb,
                            escolherGaleriaFoto,
                            handleDeleteImage,
                            handleDeleteImageWeb,
                            _image,
                            _imageWeb,
                            pickedFile,
                            anexoGaleria,
                            context,
                          )
                        : SizedBox.shrink(),
                    isDevedor
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            height: alturaTela * 0.055, //45,
                            width: MediaQuery.of(context).size.width * 0.73,
                            padding: Responsive.isDesktop(context)
                                ? EdgeInsets.symmetric(
                                    horizontal: alturaTela * 0.5)
                                : EdgeInsets.zero,
                            child: ElevatedButton(
                              onPressed: showSenhaDialog,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: Colors.green[300]),
                                ),
                              ),
                              child: Text(
                                "Solicitar Quitação",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: alturaTela * 0.025,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            );
    });
  }
}

Widget buildCardInfo(
  IconData icon,
  String text,
  String value,
  Color color,
  double alturaTela,
) {
  return Container(
    padding: const EdgeInsets.all(10),
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 45.0,
              width: 45.0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(
                  Radius.circular(60.0),
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Flexible(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: alturaTela * 0.022,
              ),
            ),
          ),
        ),
        Flexible(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                fontSize: alturaTela * 0.022,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTable(
  List<String> tableHeaderQuitacao,
  FormatMoney money,
  Function handleChangeCheckBox,
  List<PropostaModel> selectedEmp,
  double alturaTela,
) {
  return GetX<PropostaController>(
    builder: (_) {
      return _.propostas.length < 1
          ? Text(
              "Nenhum contrato ativo no momento.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: alturaTela * 0.017,
              ),
            )
          : _buidTableQuitacao(
              tableHeaderQuitacao,
              _.propostas,
              money,
              handleChangeCheckBox,
              selectedEmp,
            );
    },
  );
}

Widget _buidTableQuitacao(
  List<String> tableHeaderQuitacao,
  List<PropostaModel> propostaList,
  FormatMoney money,
  Function handleChangeCheckBox,
  List<PropostaModel> selectedEmp,
) {
  return DataTable(
    columns: tableHeaderQuitacao
        .map(
          (header) => DataColumn(
            label: Container(
              padding: header.compareTo("Data") == 0
                  ? const EdgeInsets.only(left: 15)
                  : EdgeInsets.zero,
              alignment: Alignment.center,
              child: Text(
                header,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        )
        .toList(),
    rows: propostaList.map<DataRow>(
      (prop) {
        var data = prop.data.substring(0, 10).split('-');
        var dataFormat = "${data[2]}-${data[1]}-${data[0]}";
        var valorFormat = prop.valorcr != null
            ? money.formatterMoney(double.parse("${prop.valorcr}"))
            : '-';
        var principalFormat = prop.principal != null
            ? money.formatterMoney(double.parse("${prop.principal}"))
            : '-';
        var prestacaoFormat = prop.prestacao != null
            ? money.formatterMoney(double.parse("${prop.prestacao}"))
            : '-';
        var devedorFormat = prop.saldoDevedor != null
            ? money.formatterMoney(double.parse("${prop.saldoDevedor}"))
            : '-';

        var quitacaoFormat = prop.valorQuitacao != null
            ? money.formatterMoney(double.parse("${prop.valorQuitacao}"))
            : '-';

        return DataRow(
          selected: selectedEmp.contains(prop),
          onSelectChanged: (value) {
            handleChangeCheckBox(value, prop);
          },
          cells: [
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text("${prop.numero}"),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(dataFormat),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(quitacaoFormat),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(principalFormat),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(prestacaoFormat),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text("${prop.npc}"),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text("${prop.npf}"),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(valorFormat),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(devedorFormat),
              ),
            ),
          ],
        );
      },
    ).toList(),
  );
}

bool handleFechamentoFolha(List<FechamentoFolhaModel> fechamentoFolha) {
  var dataHoje = DateTime.now();
  var dataLimite = DateTime.parse(fechamentoFolha[0].datafechafolha)
      .subtract(Duration(days: 2));

  print("DATA LIMITE = $dataLimite");

  print(
      "DATA FECHA FOLHA = ${DateTime.parse(fechamentoFolha[0].datafechafolha)}");

  if ((dataHoje.isAfter(dataLimite) &&
          dataHoje
              .isBefore(DateTime.parse(fechamentoFolha[0].datafechafolha))) ||
      fechamentoFolha[0].fimmes == 1) {
    return true;
  }

  return false;
}

Widget buildAnexoButton(
  Function getImage,
  Function getImageWeb,
  Function escolherGaleriaFoto,
  double alturaTela,
  BuildContext context,
) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    padding: Responsive.isDesktop(context)
        ? EdgeInsets.symmetric(horizontal: alturaTela * 0.4)
        : EdgeInsets.zero,
    child: ElevatedButton.icon(
      onPressed: () {
        Responsive.isDesktop(context) || kIsWeb
            ? getImageWeb()
            : escolherGaleriaFoto(getImage, getImageWeb);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(color: Colors.blue),
        ),
      ),
      icon: Icon(
        Icons.note_add,
        size: 20.0,
        color: Colors.white,
      ),
      label: Text(
        "Anexar comprovante",
        style: TextStyle(color: Colors.white, fontSize: 15.0),
      ),
    ),
  );
}

Widget buildAnexo(
  double alturaTela,
  Function getImage,
  Function getImageWeb,
  Function escolherGaleriaFoto,
  Function handleDeleteImage,
  Function handleDeleteImageWeb,
  File _image,
  Uint8List _imageWeb,
  FilePickerResult pickedFile,
  bool anexoGaleria,
  BuildContext context,
) {
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: buildAnexoButton(
          getImage,
          getImageWeb,
          escolherGaleriaFoto,
          alturaTela,
          context,
        ),
      ),
      _image != null || _imageWeb != null
          ? Padding(
              padding: Responsive.isDesktop(context)
                  ? EdgeInsets.symmetric(
                      horizontal: alturaTela * 0.4, vertical: 15)
                  : const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    constraints:
                        BoxConstraints(maxHeight: 60.0, maxWidth: 50.0),
                    child:
                        Responsive.isDesktop(context) || kIsWeb || anexoGaleria
                            ? SizedBox.shrink()
                            : Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                  ),
                  const SizedBox(width: 4.0),
                  Responsive.isDesktop(context) || kIsWeb || anexoGaleria
                      ? Expanded(
                          child: Text(pickedFile != null
                              ? '${pickedFile.files.first.name}'
                              : 'Erro ao selecionar o documento. Tente novamente.'))
                      : Expanded(
                          child: Text("comprovante.jpg"),
                        ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red,
                    ),
                    onPressed:
                        Responsive.isDesktop(context) || kIsWeb || anexoGaleria
                            ? handleDeleteImageWeb
                            : handleDeleteImage,
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
      Container(
        alignment: Alignment.centerLeft,
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.symmetric(horizontal: alturaTela * 0.43, vertical: 20)
            : const EdgeInsets.all(20),
        child: Text(
          "Obs.: Caso já tenha realizado o pagamento, mande uma foto do comprovante.",
          style: TextStyle(
            fontSize: alturaTela * 0.018,
            fontStyle: FontStyle.italic,
            color: Colors.blue[900],
          ),
        ),
      ),
      SizedBox(
        height: alturaTela * 0.055, //100,
      ),
    ],
  );
}
