import 'dart:typed_data';

import 'package:http/http.dart' as http;

class ImagePostRepository {
  Future<bool> uploadImage(
    Uint8List image,
    int protocolo,
    String label,
    String pasta,
    String operacao,
    String extensao,
  ) async {
    String url =
        'http://54.207.211.41:3000/images'; //SERVIDOR = http://54.207.211.41:3000
    var data = DateTime.now().toString().substring(0, 10);
    var hora = DateTime.now().toString().substring(11, 19).split(':');
    var horaFormat = "${hora[0]}h${hora[1]}m${hora[2]}s";

    var request = http.MultipartRequest('POST', Uri.parse(url));

    List<int> listData = image.cast();

    request.files.add(http.MultipartFile.fromBytes('image', listData,
        filename: '$pasta*$protocolo*${label}_${data}_$horaFormat.$extensao'));

    var response = await request.send();
    print(response.statusCode);

    return response.statusCode == 200;
  }
}
