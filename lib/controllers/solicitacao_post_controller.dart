import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/state_manager.dart';

class SolicitacaoPostController extends GetxController {
  MoneyMaskedTextController controllerValor;
  MoneyMaskedTextController controllerSalario;
  MoneyMaskedTextController controllerLiquido;
  MoneyMaskedTextController controllerPensao;
  MoneyMaskedTextController controllerConsignado;
  TextEditingController controllerParcelas;

  List<Map<String, dynamic>> _solicitacaoInfo = [];

  List<Map<String, dynamic>> get solicitacaoInfo => _solicitacaoInfo;

  @override
  void onInit() {
    controllerValor = MoneyMaskedTextController(
        decimalSeparator: ',', thousandSeparator: '.');
    controllerSalario = MoneyMaskedTextController(
        decimalSeparator: ',', thousandSeparator: '.');
    controllerLiquido = MoneyMaskedTextController(
        decimalSeparator: ',', thousandSeparator: '.');
    controllerPensao = MoneyMaskedTextController(
        decimalSeparator: ',', thousandSeparator: '.');
    controllerConsignado = MoneyMaskedTextController(
        decimalSeparator: ',', thousandSeparator: '.');
    controllerParcelas = TextEditingController();
    super.onInit();
  }

  void clearForm() {
    controllerValor.text = '0,00';
    controllerSalario.text = '0,00';
    controllerLiquido.text = '0,00';
    controllerPensao.text = '0,00';
    controllerConsignado.text = '0,00';
    controllerParcelas.text = '';
  }

  //Convert money type to double
  String _convertDouble(String value) {
    String valor = value.replaceAll(',', '.');
    var valorDouble = [];
    valorDouble = valor.split(".");
    if (valorDouble != null) if (valorDouble.length == 2) {
      return "${valorDouble[0]}" + "." + "${valorDouble[1]}";
    } else {
      return "${valorDouble[0]}" +
          "${valorDouble[1]}" +
          "." +
          "${valorDouble[2]}";
    }

    return "${valorDouble[0]}";
  }

  void saveSolicitacao(
    int matricula,
    int numero,
  ) {
    this._solicitacaoInfo = [
      {
        "numero": numero,
        "data": DateTime.now().toString().substring(0, 23),
        "matricula": matricula,
        "solicitacao": _convertDouble(controllerValor.text),
        "parcela": controllerParcelas.text,
        "devedor": null,
        "salario": _convertDouble(controllerSalario.text),
        "liquido": _convertDouble(controllerLiquido.text),
        "pensao": _convertDouble(controllerPensao.text),
        "consignado": _convertDouble(controllerConsignado.text),
        //"anexos": qtdeAnexos,
        "iof": 0.00,
        //"prestacao":  prestacao,
        "valorcr": _convertDouble(controllerValor.text),
        //"utilizada": utilizada
        "situacao": "P",
        "origem": "APP",
      }
    ];
  }

  @override
  void onClose() {
    controllerValor?.dispose();
    controllerSalario?.dispose();
    controllerLiquido?.dispose();
    controllerPensao?.dispose();
    controllerConsignado?.dispose();
    controllerParcelas?.dispose();
    super.onClose();
  }
}
