import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();

  List<Map<String, dynamic>> payers = [];
  List<Map<String, dynamic>> participants = [];
  List<Map<String, dynamic>> transactions = [];

  String splitType = 'Equal';

  void _addPayer() {
    setState(() {
      payers.add({
        'name': TextEditingController(),
        'amount': TextEditingController(),
        'involved': <String>[]
      });
    });
  }

  void _addParticipant() {
    setState(() {
      participants.add({'name': TextEditingController()});
    });
  }

  void _removePayer(int index) {
    setState(() {
      payers[index]['name'].dispose();
      payers[index]['amount'].dispose();
      payers.removeAt(index);
    });
  }

  void _removeParticipant(int index) {
    setState(() {
      participants[index]['name'].dispose();
      participants.removeAt(index);
    });
  }

  void _removeTransaction(int index) {
    setState(() {
      transactions.removeAt(index);
    });
  }

  void _submitTransaction() {
    if (_formKey.currentState!.validate()) {
      double totalPaid = payers.fold(0.0, (sum, payer) => sum + (double.tryParse(payer['amount'].text) ?? 0.0));
      double totalAmount = double.tryParse(_totalAmountController.text) ?? 0.0;

      if (totalPaid != totalAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Total paid does not match total amount')),
        );
        return;
      }

      setState(() {
        transactions.add({
          'expense': _expenseController.text,
          'totalAmount': _totalAmountController.text,
          'payers': List.from(payers.map((p) => {
            'name': p['name'].text,
            'amount': p['amount'].text,
            'involved': List.from(p['involved'])
          })),
          'participants': List.from(participants.map((p) => (p['name'] as TextEditingController).text)),
          'splitType': splitType,
        });
      });

      _expenseController.clear();
      _totalAmountController.clear();
      setState(() {
        payers.clear();
        participants.clear();
      });
    }
  }

  List<String> get participantNames =>
      participants.map((p) => (p['name'] as TextEditingController).text).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _expenseController,
                      decoration: InputDecoration(labelText: 'Expense Name'),
                      validator: (val) => val!.isEmpty ? 'Enter expense name' : null,
                    ),
                    TextFormField(
                      controller: _totalAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Total Amount'),
                      validator: (val) => val!.isEmpty ? 'Enter total amount' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Participants:', style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: _addParticipant,
                          icon: Icon(Icons.group_add),
                        )
                      ],
                    ),
                    Column(
                      children: participants.asMap().entries.map((entry) {
                        int index = entry.key;
                        var participant = entry.value;
                        return ListTile(
                          title: TextFormField(
                            controller: participant['name'],
                            decoration: InputDecoration(labelText: 'Participant Name'),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeParticipant(index),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payers:', style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: _addPayer,
                          icon: Icon(Icons.add_circle),
                        )
                      ],
                    ),
                    Column(
                      children: payers.asMap().entries.map((entry) {
                        int index = entry.key;
                        var payer = entry.value;
                        return Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  value: participantNames.contains(payer['name'].text) ? payer['name'].text : null,
                                  items: participantNames.map((name) {
                                    return DropdownMenuItem<String>(
                                      value: name,
                                      child: Text(name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      payer['name'].text = value!;
                                    });
                                  },
                                  decoration: InputDecoration(labelText: 'Payer Name'),
                                ),
                                TextFormField(
                                  controller: payer['amount'],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(labelText: 'Amount Paid'),
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  children: participantNames.map((participant) {
                                    return FilterChip(
                                      label: Text(participant),
                                      selected: payer['involved'].contains(participant),
                                      onSelected: (selected) {
                                        setState(() {
                                          if (selected) {
                                            payer['involved'].add(participant);
                                          } else {
                                            payer['involved'].remove(participant);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removePayer(index),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitTransaction,
                        child: Text('Submit Transaction'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Transactions:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey.shade300),
                    dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    columns: [
                      DataColumn(label: Text('Expense', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Split Type', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Payers', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Participants', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: List.generate(transactions.length, (index) {
                      var t = transactions[index];
                      return DataRow(cells: [
                        DataCell(Text(t['expense'])),
                        DataCell(Text(t['totalAmount'])),
                        DataCell(Text(t['splitType'])),
                        DataCell(Text(t['payers'].map((p) => '${p['name']} (${p['amount']})').join('; '))),
                        DataCell(Text(t['participants'].join(', '))),
                        DataCell(IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeTransaction(index),
                        )),
                      ]);
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
