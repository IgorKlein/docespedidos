import 'package:flutter/material.dart';

void main() {
  runApp(DocesPedidos());
}

class DocesPedidos extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ListaPedidos());
  }
}

class ListaPedidos extends StatefulWidget {
  final List<Pedido> _listaPedidos = List();

  @override
  State<StatefulWidget> createState() {
    return ListaPedidosState();
  }
}

class ListaPedidosState extends State<ListaPedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos à vencer'),
      ),
      body: ListView.builder(
        itemCount: widget._listaPedidos.length,
        itemBuilder: (context, indice) {
          final pedido = widget._listaPedidos[indice];
          return ItemPedido(pedido);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final Future<Pedido> future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioPedidos();
          }));
          future.then((pedidoRecebido) {
            debugPrint('chegou no then do future.');
            debugPrint('$pedidoRecebido');
            setState(() {
              widget._listaPedidos.add(pedidoRecebido);
            });
          });
        },
      ),
    );
  }
}

class FormularioPedidos extends StatelessWidget {
  final TextEditingController _controladorCampoCliente =
      TextEditingController();
  final TextEditingController _controladorCampoProduto =
      TextEditingController();
  final TextEditingController _controladorCampoQuantidade =
      TextEditingController();
  final TextEditingController _controladorCampoDataEntrega =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando um novo pedido'),
      ),
      body: Column(
        children: <Widget>[
          Editor(
            dica: 'Ex.: João da Silva',
            controlador: _controladorCampoCliente,
            rotulo: "Nome do cliente",
          ),
          Editor(
            dica: 'Ex.: Kit Doces Finos 24un.',
            controlador: _controladorCampoProduto,
            rotulo: "Produto",
          ),
          Editor(
            dica: 'Ex.: 01',
            controlador: _controladorCampoQuantidade,
            rotulo: "Quantidade",
          ),
          Editor(
            dica: 'Ex.: 01/12/2021',
            controlador: _controladorCampoDataEntrega,
            rotulo: "Data de Entrega",
          ),
          RaisedButton(
              child: Text(
                'Confirmar',
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () {
                debugPrint('Botão confirmar pressionado.');
                _criaPedido(context);
              },
          )
        ],
      ),
    );
  }

  void _criaPedido(BuildContext context) {
    final String nomeCliente = _controladorCampoCliente.text;
    final String produto = _controladorCampoProduto.text;
    final double quantidade = double.tryParse(_controladorCampoQuantidade.text);
    final String dataEntrega = _controladorCampoDataEntrega.text;

    if (nomeCliente != null && produto != null && quantidade != null && dataEntrega != null) {
    // if (true) {
      final Pedido pedidoCriado =
          Pedido(nomeCliente, produto, quantidade, dataEntrega);

      debugPrint('Criando Pedido.');
      debugPrint('$pedidoCriado');
      Navigator.pop(context, pedidoCriado);
    }
  }
}



class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;

  Editor({Key key, this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null, //Operador Ternário
          labelText: rotulo,
          hintText: dica,
        ),
      ),
    );
  }
}

class ItemPedido extends StatelessWidget {
  final Pedido pedido;

  ItemPedido(this.pedido);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text(pedido.cliente),
          subtitle: Text(pedido.calculaValorTotal().toString()),
        ),
    );
  }
}

class Pedido {
  final double precoKitDocesFinos = 24.00;

  final String _cliente;
  final String _produto;
  final double _quantidade;
  final String _dataEntrega;
  final String _dataPedido = '';
  final bool _entregue = true;

  Pedido(
    this._cliente,
    this._produto,
    this._quantidade,
    this._dataEntrega,
  );

  String get cliente => _cliente;

  String get produto => _produto;

  double get quantidade => _quantidade;

  double calculaValorTotal () {
    return precoKitDocesFinos * _quantidade;
  }

  @override
  String toString() {
    return 'Pedido{cliente: $cliente, produto: $produto, quantidade: $quantidade, valorTotal: $calculaValorTotal()}';
  }
}
