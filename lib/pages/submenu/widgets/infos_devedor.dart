import 'dart:io';
import 'dart:typed_data';

import 'package:copbayer_app/model/proposta_model.dart';
import 'package:copbayer_app/repositories/post_image_web.dart';
import 'package:copbayer_app/repositories/quitacao_repository.dart';
import 'package:copbayer_app/utils/responsive.dart';
import 'package:copbayer_app/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // verifica se tá na WEB

class InfosDevedor extends StatefulWidget {
  final int matricula;
  final int protocolo;
  final bool quitacaoPage;
  final String saldoDevedor;
  final bool enviarComprovante;
  final String valor;
  final String usarCapital;
  final List<PropostaModel> emprestimos;

  const InfosDevedor({
    Key key,
    this.matricula,
    this.protocolo,
    this.quitacaoPage,
    this.saldoDevedor,
    this.enviarComprovante,
    this.valor,
    this.usarCapital,
    this.emprestimos,
  }) : super(key: key);
  @override
  _InfosDevedorState createState() => _InfosDevedorState();
}

class _InfosDevedorState extends State<InfosDevedor> {
  File _image;
  final picker = ImagePicker();
  StorageService _storageService = StorageService();

  bool anexoGaleria = false;

  //WEB
  Uint8List _imageWeb;
  FilePickerResult pickedFile;
  ImagePostRepository imagePostRepository = ImagePostRepository();

  QuitacaoRepository quitacaoRepository = QuitacaoRepository();

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
      protocolo: widget.protocolo,
    );
  }

  /// WEB
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
        widget.protocolo,
        "comprovante",
        "comprovanteQuitacao",
        "quitacao",
        extensaoArq,
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    if (widget.enviarComprovante != null &&
        widget.enviarComprovante == true &&
        (_image != null || _imageWeb != null))
      Responsive.isDesktop(context) || kIsWeb || anexoGaleria
          ? _uploadComprovanteWeb()
          : _uploadComprovante();

    return Column(
      children: [
        widget.quitacaoPage
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Obs.: Para acatarmos seu pedido de desligamento é necessário a quitação do seu saldo devedor.",
                  style: TextStyle(
                    fontSize: Responsive.isDesktop(context)
                        ? alturaTela * 0.025
                        : alturaTela * 0.022,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(left: 15, right: 10),
          child: Text(
            "Realize a transferência no valor de ${widget.valor} para:",
            style: TextStyle(
              fontSize: Responsive.isDesktop(context)
                  ? alturaTela * 0.025
                  : alturaTela * 0.02,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            "Banco do Brasil",
            style: TextStyle(
              fontSize: alturaTela * 0.024,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            text: TextSpan(
              text: "CNPJ: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: alturaTela * 0.022,
              ),
              children: [
                TextSpan(
                  text: "73.631.483/0001-04",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: alturaTela * 0.022,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            text: TextSpan(
              text: "Agência: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: alturaTela * 0.022,
              ),
              children: [
                TextSpan(
                  text: "5798-3",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: alturaTela * 0.022,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            text: TextSpan(
              text: "Conta: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: alturaTela * 0.022,
              ),
              children: [
                TextSpan(
                  text: "110.748-8",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: alturaTela * 0.022,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "ou através do PIX:",
            style: TextStyle(
              fontSize: alturaTela * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "contato@copbayer.com.br",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: alturaTela * 0.023,
          ),
        ),
        const SizedBox(height: 40),
        /*Container(
          width: 200,
          height: 200,
          child: Image.asset(
            'images/exemploQR.png',
            fit: BoxFit.scaleDown,
          ),
        ),*/
        !widget.quitacaoPage
            ? Column(
                children: [
                  const SizedBox(height: 50),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: buildAnexoButton(
                      context,
                      getImage,
                      getImageWeb,
                      escolherGaleriaFoto,
                    ),
                  ),
                  _image != null || _imageWeb != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                constraints: BoxConstraints(
                                    maxHeight: 60.0, maxWidth: 50.0),
                                child: Responsive.isDesktop(context) ||
                                        kIsWeb ||
                                        anexoGaleria
                                    ? SizedBox.shrink()
                                    : Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: 4.0),
                              Responsive.isDesktop(context) ||
                                      kIsWeb ||
                                      anexoGaleria
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
                                onPressed: Responsive.isDesktop(context) ||
                                        kIsWeb ||
                                        anexoGaleria
                                    ? handleDeleteImageWeb
                                    : handleDeleteImage,
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
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
              )
            : SizedBox.shrink()
      ],
    );
  }
}

Widget buildAnexoButton(
  BuildContext context,
  Function getImage,
  Function getImageWeb,
  Function escolherGaleriaFoto,
) {
  return ElevatedButton.icon(
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
  );
}
