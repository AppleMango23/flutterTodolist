import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'dart:async';
import 'second.dart';

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
        // canvasColor: Colors.transparent,
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
        );

  // Function for search listener
  _ExamplePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

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

    showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          
          Container(
            color: Color(0xFF737373), // This line set the transparent background
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular( 16.0),
                      
                  )
                
              ),
              child: Padding(
            // padding: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.only(top: 20.0,left: 20,right: 20,bottom: 34),
            
        child: Column(
          children: <Widget>[
            TextField(
              maxLength: 24,
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
          ,)
            ),
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
      setState(() {});
    }
    else{
      fridgesDs.forEach((key, value) {
          //This one need to work with setstate so that it will render once
          setState(() {
            cats.addAll({key:value['description']});
            dogs.addAll({key:value['title']});
          });

        });
    }});
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          style: TextStyle(color: Colors.white),
          controller: _filter,
          decoration: new InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
            ),
            prefixIcon: new IconTheme(
              data: new IconThemeData(
                  color: Colors.white), 
              child: new Icon(Icons.search),
            ),
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: 22.0, color: Colors.white),
            
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new FlatButton.icon(
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
        );
        filteredNames = names;
        _filter.clear();
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
        title:_appBarTitle,
        actions: <Widget>[
          IconButton(
              icon: _searchIcon,
              onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SecondRoute()),
                  // );
                  _searchPressed();
                
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
              child: FlatButton.icon(
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
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(11.0),
                bottomRight: Radius.circular(11.0))
              ),
            ),
            ListTile(
              title: Text('To do list'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Rating'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Terms and condition'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Help'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Logout'),
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
                          new Text(item,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 19.6)),
                          new Text(itemNew,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14.9))
                        ]
                      ),
                      
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

