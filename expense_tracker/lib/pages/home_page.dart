import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();


  //add new expense
  void addNewExpense(){
    showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text('Add New Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //expense name
              TextField(
                controller: newExpenseNameController,
                decoration: const InputDecoration(
                  hintText: "Expense name",
                ),
              ),

              //expense amount
              Row(children: [
                //dollars
                Expanded(
                  child: TextField(
                    controller: newExpenseDollarController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Dollars",
                      )
                  ),
                ),

                //cents
                Expanded(
                  child: TextField(
                    controller: newExpenseCentsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Cents",
                      )
                  ),
                ),
              ],),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: save,
              child: Text('Save'),
            ),
            MaterialButton(
              onPressed: cancel,
              child: Text('Cancel'),
            ),
          ],
        ),
    );
  }

  void deleteExpense(ExpenseItem expense){
    Provider.of<ExpenseData>(context,listen: false).deleteExpense(expense);
  }

  void save(){
    //only save expense if all fields are filled
    if(newExpenseNameController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseCentsController.text.isNotEmpty){
      String amount = '${newExpenseDollarController.text}.${newExpenseCentsController.text}';

      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );
      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }


    Navigator.pop(context);
    clear();
  }

  void cancel(){
    Navigator.pop(context);
    clear();
  }

  void clear(){
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context,value,child) => Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        onPressed: addNewExpense,
        backgroundColor: Colors.grey[600],
        child: const Icon(Icons.add),

      ),
      body: ListView(children: [
        //weekly summary
        ExpenseSummary(startOfWeek: value.startOfWeekDate()),

        const SizedBox(height: 20,),
        //expense list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.getAllExpenseList().length,
          itemBuilder: (context,index) => ExpenseTile(
              name: value.getAllExpenseList()[index].name,
              amount: value.getAllExpenseList()[index].amount,
              dateTime: value.getAllExpenseList()[index].dateTime,
            deleteTapped: (p0 ) => deleteExpense(value.getAllExpenseList()[index]),
          ),
        )
      ]),
    ),
    );
  }
}
