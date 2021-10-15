import 'package:copbayer_app/model/solicitacao_model.dart';
import 'package:copbayer_app/repositories/solicitacoes_repository.dart';
import 'package:get/get.dart';

class SolicitacoesController extends GetxController {
  SolicitacoesRepository repositorySolicitacoes = SolicitacoesRepository();

  final _solicitacoes = <SolicitacaoModel>[].obs;
  final _solicitacoesRecentes = <SolicitacaoModel>[].obs;

  List<SolicitacaoModel> get solicitacoes => _solicitacoes;
  set solicitacoes(value) => this._solicitacoes.assignAll(value);

  List<SolicitacaoModel> get solicitacoesRecentes => _solicitacoesRecentes;
  set solicitacoesRecentes(value) =>
      this._solicitacoesRecentes.assignAll(value);

  void getSolicitacoes(int matricula) {
    repositorySolicitacoes
        .findAll(matricula)
        .then((data) => {this._solicitacoes.assignAll(data)});
  }

  void getSolicitacoesRecentes(int matricula) {
    repositorySolicitacoes
        .getSolRecentes(matricula)
        .then((data) => {this._solicitacoesRecentes.assignAll(data)});
  }
}
