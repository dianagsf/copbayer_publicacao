class UtilFunctions {
  String formatNome(String nome) {
    var nomeEsobrenome = nome.split(" ");
    nomeEsobrenome = [nomeEsobrenome[0] + " " + nomeEsobrenome[1]];

    return nomeEsobrenome[0];
  }

  String formatData(String data) {
    var dataFormat = data.substring(0, 10).split('-');
    dataFormat = ["${data[2]}-${data[1]}-${data[0]}"];

    return dataFormat[0];
  }
}
