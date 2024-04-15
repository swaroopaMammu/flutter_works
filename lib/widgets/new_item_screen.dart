
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:march09/data/categories.dart';
import 'package:http/http.dart' as http;
import 'package:march09/models/grocery_item.dart';
import 'dart:convert';

import '../models/category.dart';

class NewWidgetItem extends StatefulWidget {
  const NewWidgetItem({super.key});

  @override
  State<NewWidgetItem> createState() => _NewWidgetItemState();
}

class _NewWidgetItemState extends State<NewWidgetItem> {

  final _formKey = GlobalKey<FormState>();
  String _entredName = '';
  String _entredQty = '1';
  Category _entredCategory = categories[Categories.vegetables]!;
  bool isSending = false;

  void _saveItem() async{
    final flag =   _formKey.currentState!.validate();
    if(flag){
      _formKey.currentState!.save();
       setState(() {
         isSending = true;
       });
      final url = Uri.https('flutter-training-4d283-default-rtdb.firebaseio.com','shopping-list.json');
      final  resp = await http.post(url,
          headers:{'Content-Type': 'application/json'},
          body: json.encode(
            {
              'name': _entredName,
              'category': _entredCategory.categoryName,
              'quantity': int.parse(_entredQty)
            }
          ));

      final Map<String,dynamic> response = json.decode(resp.body);
     if(!context.mounted){
       return;
     }

     Navigator.of(context).pop(
       GroceryItem(name: _entredName, id: response['name'], category: _entredCategory, quantity: int.parse(_entredQty))
     );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new entry'),
        ),
        body: Center(
            child: Form(
          key: _formKey,
            child: Column(
                children: [
            TextFormField(
            decoration: const InputDecoration(
            label: Text('Name')
        ),
          maxLength: 50,
          validator: (value) {
              if(value == null || value.isEmpty || value.trim().length <= 1 || value.trim().length >50){
                return 'Input should be more than 1 and less than 50 characters';
              }
            return null;
          },
                onSaved: (value){
              _entredName = value!;
                }
        ),
        Row(
           crossAxisAlignment: CrossAxisAlignment.end,
            children: [
        Expanded(
          child: TextFormField(
            initialValue: '1',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
          label: Text('Quantity')
              ),
            validator: (value) {
              if(value == null || value.isEmpty || int.tryParse(value) ==  null || int.tryParse(value)! <=0){
                return 'Input should be less than or equal to 0';
              }
              return null;
            },
          onSaved: (value){
            _entredQty = value!;
          },),
        ),
    SizedBox(width: 12),

    Expanded(
      child: DropdownButtonFormField(
        value: _entredCategory,
          items:[
      for(final cat in categories.entries)
      DropdownMenuItem(
        value: cat.value,
          child: Row(
      children: [
      Container(
      width: 16,
      height: 16,
      color: cat.value.colorCode,
      ),
      const SizedBox(width: 12),
      Text(cat.value.categoryName)
      ],
      ))
      ], onChanged: (value){
          setState(() {
            _entredCategory = value!;
          });
      }),
    )

    ],
    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: isSending ? null : (){
                        _formKey.currentState!.reset();
                      }, child: Text('Reset')),
                      SizedBox(width: 5),
                      ElevatedButton(onPressed: isSending ? null: _saveItem, child: isSending ?
                          SizedBox(height: 16,width: 16,
                          child: CircularProgressIndicator()) :
                      Text('Add'))
                    ],
                  )
    ],
    )
    )),
    );
  }
}
