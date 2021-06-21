
import 'package:cronometro/model/jogador.dart';

class JogadorController{
  List<Jogador> _lista = [];

  JogadorController(){} 

  List<Jogador> listar(){
    return _lista;
  }

  void salvar(Jogador jogador){
    _lista.add(jogador);
    
  }

  void remover(Jogador jogador){
    _lista.remove(jogador);
  }


   
}

