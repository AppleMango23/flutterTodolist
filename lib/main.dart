import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// import 'second.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListView',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyCustomForm(),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  //To create a textfield connector step1
  final myController = TextEditingController();
  String textfield1 = "";
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();

    //make text field connect to function
    // myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree & _printLatestValue listener
    myController.dispose();
    super.dispose();
  }

  passwordChecker() {
    if (myController.text == "test") {
      print("password verified completed!");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Password Verified completed!!"),
            content: new Text(
                "Good job User, your password is correct! Please double check your user password to make sure it is secure and safe\n\nYour password is ${myController.text}"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print("password verified FAIL!");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Password verified FAIL!"),
            content: new Text(
                "A very sad news please go check your password with admin! Please double check your user password to make sure it is secure and safe\n\n${myController.text} is not a correct password!"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  _deleteFunction(int index) {

    var textIs =titles[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Be caution!",style: TextStyle(fontSize: 22),),
          content: new Text(
              "Be caution you will be deleting text \"$textIs\", make sure that you selected the correct one. Thank you.",style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new RaisedButton(
              onPressed: () {
                setState(() {
                  titles.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: new Text('Confirm',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void submitData() {
    int index = 0;
    if(myController.text != ""){
      setState(() {
      titles.insert(index, myController.text);
    });
    myController.text = "";
    }
    else{
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Be caution!",style: TextStyle(fontSize: 22),),
          content: new Text(
              "There is nothing on textField.",style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
      );
    }
  }
  void createRecord(){
    print('saving');
    databaseReference.child("0").set({
      'title': 'Mastering Happy',
      'description': 'Programming Guide for J2EE'
    });
    databaseReference.child("1").set({
      'title': 'Flutter in Noah',
      'description': 'Complete Programming Guide to learn Flutter'
    });
  }

  void checkRecord(){
    var x;
    databaseReference.child("").once().then((DataSnapshot snapshot) {
    // print(snapshot.value);
    // this one can seperate 2 object
    // for(x in snapshot.value){
    //   print(x);
    // //   setState(() {
    // //   // titles.insert(0, x);
    // //   titles.addAll(x);
    // // });
    
    // }
    // This one can show where u are
    // print(snapshot.key);
    //This one will show the whole object path
    // print(snapshot.value);
    //This one will show the amount of thing
    // print(snapshot.value.length);

    // list.forEach((element) => print(element));




    // var items = [];
    // snapshot.forEach((child) => {
    //   items.push({
    //     id: child.key,
    //     description: child.val(),
    //   });
    // });
    
  });


  

  }

  List<String> titles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            TextField(
              maxLength: 200,
              controller: myController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TextField2',
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(bottom: 2.0),
              child: new RaisedButton(
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                onPressed: submitData,
                child: new Text('Submit data',
                    style: TextStyle(fontSize: 23, color: Colors.white)),
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(bottom: 6.0),
              child: new RaisedButton(
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                onPressed: createRecord,
                child: new Text('Create Record',
                    style: TextStyle(fontSize: 23, color: Colors.white)),
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(bottom: 6.0),
              child: new RaisedButton(
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                onPressed: checkRecord,
                child: new Text('Check Record',
                    style: TextStyle(fontSize: 23, color: Colors.white)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  final item = titles[index];
                  return Card(
                    child: ListTile(
                      title: Text(item),
                      onTap: () {
                        //                                  <-- onTap
                        setState(() {
                          titles.insert(index, 'Planet');
                        });
                      },
                      onLongPress: (){_deleteFunction(index);},
                        
                      
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
