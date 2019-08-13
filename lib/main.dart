import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

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
    checkRecord();
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

  //make this link to the firebase + map array
  _deleteFunction(String textDelete, String realName) {

    // var textIs =titles[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: FlatButton.icon(
            color: Colors.transparent,
            icon: 
            new IconTheme(
                data: new IconThemeData(
                    size: 35,
                    color: Colors.red), 
                child: new Icon(Icons.delete),
            ),
            label: Text('Be caution!',style: TextStyle(color:Colors.black,fontSize: 23)), 
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
            onPressed: null,
          ),
          content: 
          // FlatButton.icon(onPressed: null, icon: null, label: null),
          new Text(
              "Be caution you will be deleting text \"$realName\". Please double confirm.",style: TextStyle(fontSize: 18),),
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
                cats.remove(textDelete);
                checkRecord();
                databaseReference.child('posts/'+textDelete).remove();
                print(cats);
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
    //This one will create a random number
    var rng = new Random();
    var rng1 = rng.nextInt(10000000).toString();
    // var path = "posts/";
    var path = "posts/"+rng1;
    //.push() will give random number
    // databaseReference.child(path).push().set({
      databaseReference.child(path).set({
      'title': 'zzz',
      'description': myController.text
    });
    myController.text = "";

    checkRecord();
  }

  void checkRecord(){
    titles=[];

    databaseReference.child('posts/').once().then((DataSnapshot snapshot) {
     Map<dynamic, dynamic> fridgesDs = snapshot.value;
        fridgesDs.forEach((key, value) {
          // This one will be printing the key of the db
          print(key);

          //Use map to solve this object problem

          // Map<String, int> cats = {"hello":5,"test":88};

          // items: List<ListItem>.generate(1,(i) => MessageItem("hello 5", "Message is 5"),);

          // String sendThis : MessageItem("hello 5", "Message is 5");
          String sendThis = key + "\n" + value['description'];
          
          setState(() {
            titles.insert(0, sendThis);
          });

          
          cats.addAll({key:value['description']});
          print(cats);
          
          // setState(() {
          //   titles.insert(0, sendThis);
          // });

          //This one will be printing the value of the db if one specific something get in array
          // print(value);
          // print(value['description']);

          

         

        });
  });
  }

  List<String> titles = [];
  Map<String, String> cats = {};

  // List<String> description = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  
        FlatButton.icon(
          color: Colors.transparent,
          icon: 
          new IconTheme(
              data: new IconThemeData(
                  size: 35,
                  color: Colors.white), 
              child: new Icon(Icons.library_books),
          ),
          label: Text('ListView',style: TextStyle(color:Colors.white,fontSize: 23)), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
          onPressed: null,
        ),
        actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // _select(choices[0]);
              },
            ),
            // action button
            
          ],
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
            // new Container(
            //   margin: const EdgeInsets.only(bottom: 2.0),
            //   child: new RaisedButton(
            //     color: Colors.teal,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20)),
            //     onPressed: submitData,
            //     child: new Text('Submit data',
            //         style: TextStyle(fontSize: 23, color: Colors.white)),
            //   ),
            // ),

          FlatButton.icon(
            color: Colors.teal,
            icon: 
            new IconTheme(
                data: new IconThemeData(
                    size: 35,
                    color: Colors.white), 
                child: new Icon(Icons.add),
            ),
            label: Text('Add a Record',style: TextStyle(color:Colors.white,fontSize: 23)), 
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
            onPressed: createRecord,
          ),

            Expanded(
              child: ListView.builder(
                itemCount: cats.length,
                itemBuilder: (context, index) {
                  var hey = cats.keys.toList();

                  final item = cats[hey[index]];
                  final item2 = hey[index];

                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.navigate_next),
                      title: 
                      
                      // Text('$item2 \n$item ',style: TextStyle(fontSize: 18),)
                      
                      RichText(
                        text: TextSpan(
                          text: '',
                          style: 
                            new TextStyle(
                            inherit: true,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            decorationStyle: TextDecorationStyle.wavy,
                            color: Colors.black),

                          children: <TextSpan>[
                            TextSpan(text:'$item', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.6)),
                          ],
                        ),
                      )
                      
                      ,

                      onLongPress: (){_deleteFunction(item2,item);},
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
// The base class for the different types of items the list can contain.
abstract class ListItem {}

// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);
}
