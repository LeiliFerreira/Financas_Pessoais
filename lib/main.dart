import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Transacao {
  String descricao;
  double valor;
  String tipo;

  Transacao({required this.descricao, required this.valor, required this.tipo});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF29AB87)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF29AB87)),
          ),
          labelStyle: TextStyle(color: Color(0xFF29AB87)),
        ),
        // Add cursorColor parameter
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF29AB87),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController descController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  String selecionarTipo = 'Ganho';
  List<Transacao> itens = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Finanças'),
        backgroundColor: Color(0xFF29AB87),
        centerTitle: false,
        titleSpacing: 8,
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.description, color: Color(0xFF29AB87)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                controller: valorController,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  prefixIcon:
                      Icon(Icons.monetization_on, color: Color(0xFF29AB87)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selecionarTipo,
              onChanged: (String? newValue) {
                setState(() {
                  selecionarTipo = newValue!;
                });
              },
              items: <String>['Ganho', 'Despesa']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Container(
            width: 135,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                addNewItem();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF29AB87),
              ),
              child: Text(
                'Adicionar Item',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(itens[index].descricao),
                  subtitle:
                      Text('R\$ ${itens[index].valor.toStringAsFixed(2)}'),
                  trailing: Icon(
                    itens[index].tipo == 'Ganho'
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: itens[index].tipo == 'Ganho'
                        ? Colors.green
                        : Colors.red,
                  ),
                  onLongPress: () {
                    deleteItem(index);
                  },
                );
              },
            ),
          ),
          Text(
            'Total de Receitas: ${getTotalIncomes()}',
            style: TextStyle(fontSize: 17),
          ),
          Text(
            'Total de Despesas: ${getTotalExpenses()}',
            style: TextStyle(fontSize: 17),
          ),
          Text(
            'Total: ${getTotal()}',
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }

  void addNewItem() {
    if (descController.text.isEmpty || valorController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Preencha todos os campos!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      itens.add(
        Transacao(
          descricao: descController.text,
          valor: double.parse(valorController.text),
          tipo: selecionarTipo,
        ),
      );
      descController.clear();
      valorController.clear();
      selecionarTipo = 'Ganho';
    });
  }

  void deleteItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Deseja apagar este item?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
                // Delete the item
                setState(() {
                  itens.removeAt(index);
                });
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Não'),
            ),
          ],
        );
      },
    );
  }

  double getTotalIncomes() {
    return itens
        .where((item) => item.tipo == 'Ganho')
        .map((transaction) => transaction.valor)
        .fold(0, (acc, cur) => acc + cur);
  }

  double getTotalExpenses() {
    return itens
        .where((item) => item.tipo == 'Despesa')
        .map((transaction) => transaction.valor)
        .fold(0, (acc, cur) => acc + cur);
  }

  double getTotal() {
    double totalIncomes = getTotalIncomes();
    double totalExpenses = getTotalExpenses();
    return totalIncomes - totalExpenses;
  }
}
