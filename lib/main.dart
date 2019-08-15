import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'dart:async';

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
          title: FlatButton.icon(
            color: Colors.transparent,
            icon: 
            new IconTheme(
                data: new IconThemeData(
                    size: 46,
                    color: Colors.red), 
                child: new Icon(Icons.error_outline),
            ),
            label: Text('Be caution!',style: TextStyle(color:Colors.black,fontSize: 23)), 
            onPressed: null,
          ),
          content: 
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
            FlatButton.icon(
            color: Colors.teal,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
            icon: 
            new IconTheme(
                data: new IconThemeData(
                    size: 23,
                    color: Colors.white), 
                child: new Icon(Icons.delete_outline),
            ),
            label: Text('Delete',style: TextStyle(color:Colors.white,fontSize: 20)), 
            // shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(20)),
            onPressed: () {
                // setState(() {});
                cats.remove(textDelete);
                checkRecord();
                databaseReference.child('posts/'+textDelete).remove();
                Navigator.of(context).pop();
                trigerSnackBar('Deleted a list!');
                
              },
          ),
          ],
        );
      },
    );
  }
  snackbarFunction(BuildContext context,String wordsToDisplay){
    final snackBar = SnackBar(
      content: Text(wordsToDisplay,style: TextStyle(fontSize: 17),),
      action: SnackBarAction(
        label: 'Cancel',textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
      backgroundColor: Colors.teal
      );
    Scaffold.of(context).showSnackBar(snackBar);
    Timer(Duration(seconds: 9), () {
      print(wordsToDisplay);
      Scaffold.of(context).hideCurrentSnackBar();
      
    });
  }

  void trigerSnackBar(String wordToDisplay){
    snackbarFunction(contextPublic,wordToDisplay);
  }

  void testing(context) {
    setState(() {
      contextPublic=context;
    });

    showModalBottomSheet<void>(context: context,
    builder: (BuildContext context) {
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            // padding: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.only(top: 20.0,left: 20,right: 20,bottom: 34),
        child: Column(
          children: <Widget>[
            TextField(
              maxLength: 30,
              controller: myController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TextField2',
              ),
            ),

          FlatButton.icon(
            color: Colors.teal,
            icon: 
            new IconTheme(
                data: new IconThemeData(
                    size: 35,
                    color: Colors.white), 
                child: new Icon(Icons.add),
            ),
            label: Text('Add',style: TextStyle(color:Colors.white,fontSize: 23)), 
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
            onPressed: createRecord,
          ),
          new ListTile(
            leading: new Icon(Icons.music_note),
            title: new Text('Music'),
            onTap: () => null,          
          ),
          new ListTile(
            leading: new Icon(Icons.photo_album),
            title: new Text('Photos'),
            onTap: () => null,          
          ),
          new ListTile(
            leading: new Icon(Icons.videocam),
            title: new Text('Video'),
            onTap: () => null,          
          ),
          new ListTile(
            leading: new Icon(Icons.photo_album),
            title: new Text('Photos'),
            onTap: () => null,          
          ),
          
          ]
        )
          )
          
        ],
      );
   });

    
  }

  void createRecord(){
    if(myController.text != ""){
      var now = new DateTime.now();
      String newText = now.day.toString()+ "/" + now.month.toString()+ "/" + now.year.toString();
      var rng = new Random();
      var rng1 = rng.nextInt(100000000).toString();
      var path = "posts/"+rng1;
        databaseReference.child(path).set({'title': newText,'description': myController.text});
      myController.text = "";
      Navigator.pop(context);
      checkRecord();
      trigerSnackBar('Added new list!');
  
    }
    else{
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
          title: 
          FlatButton.icon(
            color: Colors.transparent,
            icon: 
            new IconTheme(
                data: new IconThemeData(
                    size: 46,
                    color: Colors.red), 
                child: new Icon(Icons.error_outline),
            ),
            label: Text('Be caution!',style: TextStyle(color:Colors.black,fontSize: 23)), 
            onPressed: null,
          ),
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

  void checkRecord(){
    
    cats.clear();
    dogs.clear();



    databaseReference.child('posts/').once().then((DataSnapshot snapshot) {
    Map<dynamic, dynamic> fridgesDs = snapshot.value;

    if(fridgesDs == null){
      setState(() {
        //refresh the screen
      });
    }
    else{
      fridgesDs.forEach((key, value) {
          //This one need to work with setstate so that it will render once
          setState(() {
            cats.addAll({key:value['description']});
            dogs.addAll({key:value['title']});
          });

        });
    }
        
    });
   
    
  }

  Map<String, String> cats = {};
  Map<String, String> dogs = {};
  var contextPublic;
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
          label: Text('AppleList',style: TextStyle(color:Colors.white,fontSize: 23)), 
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
          onPressed: null,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                testing(context);
                
              },),
          Builder(
        builder: (context) => 
            // action button
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                testing(context);
                
              },
              
            ),
            // action button
          ),
           
          ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: cats.length,
                itemBuilder: (context, index) {
                  var hey = cats.keys.toList();
                  var test = dogs.keys.toList();
                  final item = cats[hey[index]];
                  final itemNew = dogs[test[index]];
                  final item2 = hey[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Icon(Icons.navigate_next),
                      title: 
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Text(item,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 19.6)),
                          new Text(itemNew,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14.9))
                        ]
                      ),
                      // RichText(
                      //   text: TextSpan(
                      //     text: '',
                      //     style: 
                      //       new TextStyle(
                      //       inherit: true,
                      //       fontSize: 23,
                      //       fontWeight: FontWeight.w800,
                      //       decorationStyle: TextDecorationStyle.wavy,
                      //       color: Colors.black),

                      //     children: <TextSpan>[
                      //       TextSpan(text:'$item', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.6)),
                      //     ],
                      //   ),
                      // )
                      
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

