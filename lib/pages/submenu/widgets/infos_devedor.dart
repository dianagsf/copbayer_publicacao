import 'dart:io';

import 'package:copbayer_app/model/proposta_model.dart';
import 'package:copbayer_app/repositories/quitacao_repository.dart';
import 'package:copbayer_app/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    if (widget.enviarComprovante != null && widget.enviarComprovante == true)
      _uploadComprovante();

    return Column(
      children: [
        widget.quitacaoPage
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Obs.: Para acatarmos seu pedido de desligamento é necessário a quitação do seu saldo devedor.",
                  style: TextStyle(
                    fontSize: alturaTela * 0.022,
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
              fontSize: alturaTela * 0.02,
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
                    child: buildAnexoButton(context, getImage),
                  ),
                  _image != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                constraints: BoxConstraints(
                                    maxHeight: 60.0, maxWidth: 50.0),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Text("comprovante.jpg"),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_forever_outlined,
                                  color: Colors.red,
                                ),
                                onPressed: handleDeleteImage,
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.all(20),
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

Widget buildAnexoButton(BuildContext context, Function getImage) {
  return ElevatedButton.icon(
    onPressed: getImage,
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
