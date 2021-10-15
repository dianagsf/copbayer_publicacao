import 'package:flutter/material.dart';

class EnviarComprovanteButton extends StatelessWidget {
  final Function handleComprovante;

  const EnviarComprovanteButton({Key key, this.handleComprovante})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SizedBox(
      height: alturaTela * 0.055, //45,
      width: MediaQuery.of(context).size.width * 0.73,
      child: ElevatedButton(
        onPressed: handleComprovante,
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
            "Solicitar Quitação",
            style: TextStyle(
                color: Colors.white,
                fontSize: alturaTela * 0.025,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
