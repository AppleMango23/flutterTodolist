//firebase still cant connect to it

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
      title: 'AppleList',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // canvasColor: Colors.white,
        
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

  // Things to declare and use on search
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);

  Widget _appBarTitle = new FlatButton.icon(
    color: Colors.transparent,
    icon: new IconTheme(
      data: new IconThemeData(size: 35, color: Colors.white),
      child: new Icon(Icons.library_books),
    ),
    label: Text('Today is good',
        style: TextStyle(color: Colors.white, fontSize: 23)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    onPressed: null,
  );

  // Function for search listener
  _ExamplePageState() {
    // print(_filter.text);
    // print(cats.keys.toList());

    // cats.keys.toList
    // fruits.where((f) => f.startsWith('a')).toList(); //apples
  }

  @override
  void initState() {
    super.initState();
    checkRecord();
    //make text field connect to function
    _filter.addListener(_ExamplePageState);
    
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree & _printLatestValue listener
    myController.dispose();
    super.dispose();
  }

  //make this link to the firebase + map array
  _deleteFunction(String textDelete, String realName, String selection) {
    if(selection == 'swipe'){
      cats.remove(textDelete);
      checkRecord();
      databaseReference.child('posts/' + textDelete).remove();
      trigerSnackBar('Deleted a list!');
    }
    else{
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: FlatButton.icon(
            color: Colors.transparent,
            icon: new IconTheme(
              data: new IconThemeData(size: 46, color: Colors.red),
              child: new Icon(Icons.error_outline),
            ),
            label: Text('Be caution!',
                style: TextStyle(color: Colors.black, fontSize: 23)),
            onPressed: null,
          ),
          content: new Text(
            "Be caution you will be deleting text \"$realName\". Please double confirm.",
            style: TextStyle(fontSize: 18),
          ),
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
              icon: new IconTheme(
                data: new IconThemeData(size: 23, color: Colors.white),
                child: new Icon(Icons.delete_outline),
              ),
              label: Text('Delete',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              // shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                // setState(() {});
                cats.remove(textDelete);
                checkRecord();
                databaseReference.child('posts/' + textDelete).remove();
                Navigator.of(context).pop();
                trigerSnackBar('Deleted a list!');
              },
            ),
          ],
        );
      },
    );
    }
    
  }

  snackbarFunction(BuildContext context, String wordsToDisplay) {
    final snackBar = SnackBar(
        content: Text(
          wordsToDisplay,
          style: TextStyle(fontSize: 17),
        ),
        action: SnackBarAction(
          label: 'Cancel',
          textColor: Colors.white,
          onPressed: () {
            // Some code to undo the change.
          },
        ),
        backgroundColor: Colors.teal);
    Scaffold.of(context).showSnackBar(snackBar);
    Timer(Duration(seconds: 9), () {
      print(wordsToDisplay);
      Scaffold.of(context).hideCurrentSnackBar();
    });
  }

  void trigerSnackBar(String wordToDisplay) {
    snackbarFunction(contextPublic, wordToDisplay);
  }

  void testing(context) {
    setState(() {
      contextPublic = context;
    });

    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SingleChildScrollView(
                child:
              Container(
                color: 
                Color(0xFF737373)
                , // This line set the transparent background
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        )),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20, right: 20,bottom: MediaQuery.of(context).viewInsets.bottom),

                      child: Column(children: <Widget>[
                        TextField(
                          maxLength: 24,
                          controller: myController,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'TextField2',
                            counterText: "",
                          ),
                        ),
                        FlatButton.icon(
                          color: Colors.teal,
                          icon: new IconTheme(
                            data: new IconThemeData(
                                size: 35, color: Colors.white),
                            child: new Icon(Icons.add),
                          ),
                          label: Text('Add',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: createRecord,
                        ),
                        
                      ]),
                    )),
              )
              )],
          );
        });
        
  }

  void createRecord() {
    if (myController.text != "") {
      var now = new DateTime.now();
      String newText = now.day.toString() +
          "/" +
          now.month.toString() +
          "/" +
          now.year.toString();
      var rng = new Random();
      var rng1 = rng.nextInt(100000000).toString();
      var path = "posts/" + rng1;
      databaseReference
          .child(path)
          .set({'title': newText, 'description': myController.text});
      myController.text = "";
      Navigator.pop(context);
      checkRecord();
      trigerSnackBar('Added new list!');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: FlatButton.icon(
                color: Colors.transparent,
                icon: new IconTheme(
                  data: new IconThemeData(size: 46, color: Colors.red),
                  child: new Icon(Icons.error_outline),
                ),
                label: Text('Be caution!',
                    style: TextStyle(color: Colors.black, fontSize: 23)),
                onPressed: null,
              ),
              content: new Text(
                "There is nothing on textField.",
                style: TextStyle(fontSize: 18),
              ),
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
          });
    }
  }

  void checkRecord() {
    cats.clear();
    dogs.clear();

    databaseReference.child('posts/').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> fridgesDs = snapshot.value;

      if (fridgesDs == null) {
        setState(() {});
      } else {
        fridgesDs.forEach((key, value) {
          //This one need to work with setstate so that it will render once

          setState(() {
            cats.addAll({key: value['description']});
            dogs.addAll({key: value['title']});
          });
        });
      }
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 0),
          child: new TextField(
            style: TextStyle(color: Colors.white, fontSize: 22.0),
            controller: _filter,
            decoration: new InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              hintText: 'Search...',
              hintStyle: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new FlatButton.icon(
          color: Colors.transparent,
          icon: new IconTheme(
            data: new IconThemeData(size: 35, color: Colors.white),
            child: new Icon(Icons.library_books),
          ),
          label: Text('I love today',
              style: TextStyle(color: Colors.white, fontSize: 23)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: null,
        );
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  _showTextFunction(key, name, date) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Color(
                    0xFF737373), // This line set the transparent background
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        )),
                    child: Padding(
                      // padding: const EdgeInsets.all(20.0),
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20, right: 20, bottom: 34),

                      child: Column(children: <Widget>[
                        new ListTile(
                          leading: new Icon(Icons.data_usage),
                          title: new Text('$name'),
                          onTap: () => null,
                        ),
                        new ListTile(
                          leading: new Icon(Icons.date_range),
                          title: new Text('$date'),
                          onTap: () => null,
                        ),
                        new ListTile(
                          leading: new Icon(Icons.edit_attributes),
                          title: new Text('Rename'),
                          onTap: () => null,
                        ),
                        new ListTile(
                          leading: new Icon(Icons.delete_sweep),
                          title: new Text('Delete'),
                          onTap: () => {
                            Navigator.pop(context),
                            _deleteFunction(key, name,'notswipe')
                          },
                        ),
                      ]),
                    )),
              )
            ],
          );
        });
  }

  Map<String, String> cats = {};
  Map<String, String> dogs = {};
  var contextPublic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SecondRoute()),
              // );
              _searchPressed();
            },
          ),
          Builder(
            builder: (context) =>
                // action button
                IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // SomeClassFromMyLibrary hey = new SomeClassFromMyLibrary();
                // // print(hey.t);
                // hey.testFunction();

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
              child: FlatButton.icon(
                color: Colors.transparent,
                icon: new IconTheme(
                  data: new IconThemeData(size: 35, color: Colors.white),
                  child: new Icon(Icons.library_books),
                ),
                label: Text('I love today',
                    style: TextStyle(color: Colors.white, fontSize: 23)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                onPressed: null,
              ),
              decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(11.0),
                      bottomRight: Radius.circular(11.0))),
            ),
            Text('hello')
           
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            
           
            //Loading indicator
            // new CircularProgressIndicator(),
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
                        borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      height: 90,
                      child: 
                      Dismissible(
                        // Specify the direction to swipe and delete
                        direction: DismissDirection.endToStart,
                        key: Key(item),
                        onDismissed: (direction) {
                          // Removes that item the list on swipwe
                          _deleteFunction(item2, item, 'swipe');
                        },
                        background: Container(
                          decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                          child: Icon(Icons.delete,color:Colors.white,size:30),),
                        child: ListTile(
                        leading: Icon(Icons.notifications_active),
                        title: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              new Text(item,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 19.6)),
                              new Text(itemNew,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14.9))
                            ]),
                        onTap: () {
                          _showTextFunction(item2, item, itemNew);
                        },
                        onLongPress: () {
                          _deleteFunction(item2, item, 'notswipe');
                        },
                      ),
                      )


                      
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
