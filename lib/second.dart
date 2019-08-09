import 'package:flutter/material.dart';
import 'main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Second Screen yahoo!',
      home: SecondRoute(),
    );
  }
}

// Define a custom Form widget.
class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  //To create a textfield connector step1
  final myController = TextEditingController();
  String textfield1 = "";

  @override
  void initState() {
    super.initState();
    //make text field connect to function
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree & _printLatestValue listener
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Text field edited to: ${myController.text}");

    if(myController.text == "heythere"){
      print("password correct");
    }
  }

   void _incrementCounter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("This Application is a fancy and cool app please press close if you dont like it. Please contact noah is you interested to flutter because it is cool. \n\n${myController.text}"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new RaisedButton(
            onPressed: (){print('Pressed magic button');},
            child: new Text(
              'Make some magic',
              style: TextStyle(fontSize: 20,color: Colors.white)
            ),
          ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second screen yahoo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Flutter', //                              <--- text
              style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),
            ),
          ),
            Text(
              "welcome to next screen",
              style: TextStyle(
                fontSize: 30,
              ),
              
            ),
            TextField(
              maxLength: 20,
              controller: myController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TextField2',
              ),
            ),
            Text(' '),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: _incrementCounter,
            child: const Text(
              'Enabled Button',
              style: TextStyle(fontSize: 20)
            ),
          ),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyCustomForm()),
            );
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'Go back to main screen',
                style: TextStyle(fontSize: 20)
              ),
            ),
          ),
          
          
    
    
            
            
          ],
        ),
      ),
    );
  }
  
}