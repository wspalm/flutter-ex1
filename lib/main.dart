import 'dart:async';
import 'dart:convert';
//import 'dart:html';

import 'package:easy_localization/easy_localization.dart';
import 'package:final_6013532_mobile/languagepage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'connector.dart';
import 'Food.dart';

//fill all tab and layout
//don't forget to check for the page index
//your second page is cart page
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  return runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('th', 'TH')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: ChangeNotifierProvider(
        create: (BuildContext context) => Store(),
        child: MyApp(),
      ),
    ),
  );
} //ef

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  } //ef
} //ec

class LoginPage extends StatefulWidget {
  TextEditingController txt1 = new TextEditingController();
  TextEditingController txt2 = new TextEditingController();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://www.seekpng.com/png/full/72-729756_how-to-add-a-new-user-to-your.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: widget.txt1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: widget.txt2,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    login(context);
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Text("Login"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    //setup parameters
    String _username = widget.txt1.text;
    String _password = widget.txt2.text;
    String _url = 'http://192.168.1.41:1880/signin';
    var parameter_mapping = {'username': _username, 'password': _password};
    //json conversion
    var jsontxt = json.encode(parameter_mapping);
    //get response from server
    var response = await http.post(
      Uri.parse(_url),
      body: jsontxt,
      headers: {'Content-Type': "application/json"},
    );
    //this is response
    var result_map = json.decode(response.body);
    print(result_map);

    if (result_map['status_code'] != "200") {
      print(result_map['message']);
      _showDialog2(context);
      //return;
    } //end of if
    else if (result_map['status_code'] == "200") {
      print(result_map['message']);
      print("login success");
      //goTo(context, new HomePage());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } //end of else if
    else {
      print("server error");
    } //end of else
  } //end of function login
} //end of login page class

class HomePage extends StatelessWidget {
  //create an array to hold 5 different widgets for each tab
  List<Widget> tabs = [
    Tab1(),
    Tab2(),
    Tab3(),
    Tab4(),
    Tab5(),
  ];
  @override
  Widget build(BuildContext context) {
    var store1 = Provider.of<Store>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(store1.topic.tr()),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(
                    context: context,
                  ),
                ),
              );
            },
            icon: new Icon(Icons.map),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageSetupPage()),
              );
            },
            icon: new Icon(Icons.language_sharp),
          ),
        ],
      ),
      body: tabs[store1.activeTab],
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          return BottomAppBar(
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      Tab(context, 0, store1);
                    },
                    icon: Icon(
                      Icons.home,
                      color: store1.activeTab == 0
                          ? Colors.blue
                          : Colors.grey[450],
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      Tab(context, 1, store1);
                    },
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: store1.activeTab == 1
                          ? Colors.blue
                          : Colors.grey[450],
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      Tab(context, 2, store1);
                    },
                    icon: Icon(
                      Icons.more,
                      //make it two so that it would enter the correct
                      //condition in Tab function
                      color: store1.activeTab == 2
                          //use short hand if to make conditional rendering
                          ? Colors.blue
                          : Colors.grey[450],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      //drawer
      drawer: Container(
        width: MediaQuery.of(context).size.width * .5,
        child: Drawer(
          child: ListView(
            children: [
              //first item in your drawer list
              DrawerHeader(
                child: Image.asset('assets/pic1.PNG'),
              ),
              menu(context, 0, store1.home.tr(), Icons.home),
              menu(context, 1, store1.cart.tr(), Icons.shopping_cart_outlined),
              Text("----- Categories -----", textAlign: TextAlign.center),
              menu(context, 2, store1.maindish.tr(), Icons.dining_sharp),
              menu(context, 3, store1.dessert.tr(), Icons.icecream_outlined),
              menu(context, 4, store1.beverage.tr(),
                  Icons.emoji_food_beverage_outlined),
            ], //end of children
          ),
        ),
      ),
    );
  }
}

Widget menu(BuildContext context, int index, String name, IconData iconData) {
  var store1 = Provider.of<Store>(context);
  return ListTile(
    title: Text(name),
    trailing: Icon(
      iconData,
      color: store1.activeTab == index ? Colors.blue : Colors.grey[450],
    ),
    onTap: () {
      store1.setActiveTab(index);
      Navigator.pop(context);
    },
  );
} //end of function

void Tab(context, int index, store1) {
  if (index <= 1) {
    store1.setActiveTab(index);
  } //end of if
  else if (index == 2) {
    //enter the correct condition
    Scaffold.of(context).openDrawer();
  }
} //end of function tab

class Store extends ChangeNotifier {
  List<Food> foodCart = [];
  List<Food> get foods => foodCart;

  //language translation
  // the value of these string must be the key of Json dict
  String _home = "Home";
  String _topic = "Topic";
  String _cart = "Cart";
  String _maindish = "Main";
  String _dessert = "Dessert";
  String _beverage = "Beverage";
  String _setting = "Setting";

  String get home => _home;
  String get topic => _topic;
  String get cart => _cart;
  String get maindish => _maindish;
  String get dessert => _dessert;
  String get beverage => _beverage;
  String get setting => _setting;
  /////////////////////////////////
  String _myobj = "HelloWorld";
  String get myobj => _myobj;

  /////////////////// google map marker //////////////////////

  Set<Marker> markers = Set();
  void addNewMarker(
      {required String id,
      required String title,
      required double lat,
      required double lon}) {
    markers.clear();
    markers.add(mm(id: id, title: title, lat: lat, lon: lon));
    notifyListeners();
  }

  Marker mm(
      {required String id,
      required String title,
      required double lat,
      required double lon}) {
    Marker m1 = Marker(
      markerId: MarkerId(id),
      infoWindow: InfoWindow(title: title, snippet: title),
      position: LatLng(lat, lon),
    );
    return m1;
  } //end of function

  double _total() {
    double tot = 0;
    for (int i = 0; i < foodCart.length; i++) {
      tot += foodCart[i].price * foodCart[i].qty;
    } //end of for
    notifyListeners();
    return tot;
  } //end of function total

  void clearAll() {
    //make qty = 0 and then remove it using removeWhere
    for (int i = 0; i < foodCart.length; i++) {
      foodCart[i].qty = 0;
    } //end of for loop
    foodCart.removeWhere((element) => element.qty == 0);
    notifyListeners();
  } //end of function clear all

  void addFood(Food food) {
    food.qty++;
    if (food.qty == 1) {
      foodCart.add(food);
    } //end of if
  } //end of addFood function

  Future<String> sendOrder() async {
    var mapping = foodCart.map((i) => i.toMap()).toList();
    var order = {"orders": mapping};
    var _json = json.encode(order);
    //http post header
    var header1 = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var _uri = Uri.parse('http://192.168.1.41:1880/purchasecart');
    var response = await http.post(_uri, body: _json, headers: header1);
    print("Sending obj info -->> ");
    print(order['orders']);
    print("response status -->>");
    print(response.statusCode);
    print("response body -->> ");
    print(response.body);
    print("ok , it is all done");

    return "succeed";
  } //end of sendOrder function

  int _activeTab = 0;
  int get activeTab => _activeTab;

  void setActiveTab(int index) {
    _activeTab = index;
    notifyListeners();
  } //end of function active tab
} //end of store class

void goTo(context, Widget w) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => w),
  );
}

//create starter class to pass data to the second class
//this second class will render actual ui
//////////////////////////// Tab1 ///////////////////////////////////
class Tab1 extends StatefulWidget {
  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: foods(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //if snapshot.hasData == False
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } //end of if
        else {
          return Layout1(
            input_snapshot: snapshot,
          );
        } //end of else
      },
    );
  }
} //end of tab1 class

//////////////////////////// Tab2 ///////////////////////////////////
class Tab2 extends StatefulWidget {
  @override
  _Tab2State createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  @override
  Widget build(BuildContext context) {
    var store1 = Provider.of<Store>(context);
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: ListView.builder(
            itemCount: store1.foodCart.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.white70,
                child: Dismissible(
                  key: UniqueKey(),
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      Food _food = store1.foodCart[index];
                      store1.foodCart
                          .removeWhere((element) => element.id == _food.id);
                    });
                  },
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          Food _food = store1.foodCart[index];
                          _food.qty -= 1;
                          if (_food.qty == 0) {
                            store1.foodCart.removeWhere(
                                (element) => element.id == _food.id);
                          }
                        });
                      },
                      icon: Icon(
                        Icons.exposure_minus_1,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(
                      '${store1.foodCart[index].name} X ${store1.foodCart[index].qty}',
                      textScaleFactor: 1,
                    ),
                    subtitle: Text(
                      (double.parse((store1.foodCart[index].qty *
                                  store1.foodCart[index].price)
                              .toStringAsFixed(2)))
                          .toString(),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          store1.foodCart[index].qty += 1;
                          if (store1.foodCart[index].qty == 1) {
                            store1.addFood(store1.foodCart[index]);
                          }
                        });
                      },
                      icon: Icon(
                        Icons.plus_one,
                        color: Colors.green[200],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "Total: " + store1._total().toString(),
            textScaleFactor: 2,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () async {
              await store1.sendOrder();
              _showDialog(context);
              store1.clearAll();
            },
            icon: Icon(Icons.send_sharp),
          ),
        ),
      ],
    );
  }
} //end of tab2 class

//////////////////////////// Tab3 ///////////////////////////////////
class Tab3 extends StatefulWidget {
  @override
  _Tab3State createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: main_dishes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //if snapshot.hasData == False
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } //end of if
        else {
          return Layout1(
            input_snapshot: snapshot,
          );
        } //end of else
      },
    );
  }
} //end of tab3 class

//////////////////////////// Tab4 ///////////////////////////////////
class Tab4 extends StatefulWidget {
  @override
  _Tab4State createState() => _Tab4State();
}

class _Tab4State extends State<Tab4> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: desserts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //if snapshot.hasData == False
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } //end of if
        else {
          return Layout1(
            input_snapshot: snapshot,
          );
        } //end of else
      },
    );
  }
} //end of tab4 class

//////////////////////////// Tab5 ///////////////////////////////////
class Tab5 extends StatefulWidget {
  @override
  _Tab5State createState() => _Tab5State();
}

class _Tab5State extends State<Tab5> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: beverages(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //if snapshot.hasData == False
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } //end of if
        else {
          return Layout1(
            input_snapshot: snapshot,
          );
        } //end of else
      },
    );
  }
} //end of tab5

////////////////////////// Beginnig of Layout ////////////////////////////////
////////////////////////// Layout1 ////////////////////////////////
class Layout1 extends StatefulWidget {
  AsyncSnapshot input_snapshot;
  Layout1({required this.input_snapshot});

  @override
  _Layout1State createState() => _Layout1State();
}

class _Layout1State extends State<Layout1> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.input_snapshot.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //two item per row
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              goTo(
                  context,
                  DetailPage(
                    food: widget.input_snapshot.data[index],
                  ));
            },
            child: Stack(
              children: [
                Hero(
                  tag: widget.input_snapshot,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.9), BlendMode.dstATop),
                        image:
                            NetworkImage(widget.input_snapshot.data[index].pic),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color: Colors.amber[50],
                      child: Text(
                        widget.input_snapshot.data[index].name,
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color: Colors.amber[50],
                      child: Text(
                        widget.input_snapshot.data[index].price.toString() +
                            " Baht",
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} //end of layout1

//there is no layout2 because I don't want to confuse myself
//with tab2

////////////////////////// Layout3 ////////////////////////////////
class Layout3 extends StatefulWidget {
  AsyncSnapshot input_snapshot;
  Layout3({required this.input_snapshot});
  @override
  _Layout3State createState() => _Layout3State();
}

class _Layout3State extends State<Layout3> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.input_snapshot.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //two item per row
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              goTo(
                  context,
                  DetailPage(
                    food: widget.input_snapshot.data[index],
                  ));
            },
            child: Stack(
              children: [
                Hero(
                  tag: widget.input_snapshot,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.9), BlendMode.dstATop),
                        image:
                            NetworkImage(widget.input_snapshot.data[index].pic),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color: Colors.amber[50],
                      child: Text(
                        widget.input_snapshot.data[index].name,
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color: Colors.amber[50],
                      child: Text(
                        widget.input_snapshot.data[index].price.toString() +
                            " Baht",
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} //end of layout3

////////////////////////// Layout4 ////////////////////////////////
class Layout4 extends StatefulWidget {
  AsyncSnapshot input_snapshot;
  Layout4({required this.input_snapshot});
  @override
  _Layout4State createState() => _Layout4State();
}

class _Layout4State extends State<Layout4> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.input_snapshot.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //two item per row
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              goTo(
                  context,
                  DetailPage(
                    food: widget.input_snapshot.data[index],
                  ));
            },
            child: Stack(
              children: [
                Hero(
                  tag: widget.input_snapshot,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.9), BlendMode.dstATop),
                        image:
                            NetworkImage(widget.input_snapshot.data[index].pic),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color: Colors.amber[50],
                      child: Text(
                        widget.input_snapshot.data[index].name,
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color: Colors.amber[50],
                      child: Text(
                        widget.input_snapshot.data[index].price.toString() +
                            " Baht",
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} //end of layout4

////////////////////////// Layout5 ////////////////////////////////
class Layout5 extends StatefulWidget {
  AsyncSnapshot input_snapshot;
  Layout5({required this.input_snapshot});
  @override
  _Layout5State createState() => _Layout5State();
}

class _Layout5State extends State<Layout5> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.input_snapshot.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //two item per row
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              goTo(
                  context,
                  DetailPage(
                    food: widget.input_snapshot.data[index],
                  ));
            },
            child: Stack(
              children: [
                Hero(
                  tag: widget.input_snapshot,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.9), BlendMode.dstATop),
                        image:
                            NetworkImage(widget.input_snapshot.data[index].pic),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color: Colors.amber[50],
                      child: Text(
                        widget.input_snapshot.data[index].name,
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color: Colors.amber[50],
                      child: Text(
                        widget.input_snapshot.data[index].price.toString() +
                            " Baht",
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} //end of layout5

////////////////////////// Detail Page ////////////////////////////////
class DetailPage extends StatefulWidget {
  Food food;
  DetailPage({required this.food});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    var store1 = Provider.of<Store>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Detail Page"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageSetupPage()),
              );
            },
            icon: new Icon(Icons.language_sharp),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              Hero(
                tag: widget.food.id,
                child: Container(
                  width: 500,
                  height: 550,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.food.pic),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.amber[50],
                  child: Column(
                    children: [
                      Text(
                        "Name : " + widget.food.name.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        "Name : " + widget.food.price.toString() + " baht",
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        "Type : " + widget.food.type.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ], //end of inner children
                  ),
                ),
              ),
              Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      store1.addFood(widget.food);
                    });
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        Text("Add to Basket"),
                      ],
                    ),
                  ),
                ),
              ),
            ], //end of outter children
          ),
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Notification"),
        content: new Text("Your order has been sent"),
        actions: <Widget>[
          FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
} //end of show dialog function

void _showDialog2(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Notification"),
        content: new Text("Incorrect input"),
        actions: <Widget>[
          FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
} //end of show dialog function

class MapPage extends StatefulWidget {
  BuildContext context;
  MapPage({required this.context});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller1 = new Completer();
  @override
  Widget build(BuildContext context) {
    var store1 = Provider.of<Store>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Map Page"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            13.61220,
            100.83730,
          ),
          zoom: 18,
        ),
        onMapCreated: (GoogleMapController c) {
          _controller1.complete(c);
        },
        markers: store1.markers,
      ),
    );
  } //end of build function

  @override
  void initState() {
    var store1 = Provider.of<Store>(widget.context);
    super.initState();
    store1.addNewMarker(
      id: '1',
      title: 'our shop',
      lat: 13.61220,
      lon: 100.83730,
    );
  } //end of initstate
}//end of mappage state class
