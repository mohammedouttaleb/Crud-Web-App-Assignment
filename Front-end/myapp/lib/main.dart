import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'User Management Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _users = [];
  String user_found = "NULL";
  var user = {
    "name": "",
    "email": "",
    "phone": "",
    "address": "",
    "country": ""
  };
  var deleted_user_ID;
  var deleteMsg = "";
  var user_ID;

  void getAllUsers() async {
    var client = new http.Client();
    try {
      var url = Uri.parse('http://127.0.0.1:5000/api/users');
      var response = await client.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      setState(() {
        _users = convert.jsonDecode(response.body) as List;
      });
    } finally {
      client.close();
    }
  }

  void setName(value) {
    user["name"] = value;
  }

  void setPhone(value) {
    user["phone"] = value;
  }

  void setCountry(value) {
    user["country"] = value;
  }

  void setEmail(value) {
    user["email"] = value;
  }

  void setAddress(value) {
    user["address"] = value;
  }

  void setDeletedUserId(value) {
    deleted_user_ID = value;
  }

  void setUserId(value) {
    user_ID = value;
  }

  void setDleteMsg(value) {
    deleteMsg = value;
  }

  void createUser() async {
    var client = new http.Client();
    try {
      var url = Uri.parse('http://127.0.0.1:5000/api/users/add');
      var myUser = {
        'name': user["name"],
        'email': user["name"],
        'phone': user["phone"],
        'address': user["address"],
        'country': user["country"]
      };
      print(myUser);
      var response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode({
          'name': user["name"],
          'email': user["name"],
          'phone': user["phone"],
          'address': user["address"],
          'country': user["country"]
        }),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } finally {
      client.close();
    }
  }

  void deleteUser() async {
    var client = new http.Client();
    try {
      var url = Uri.parse(
          'http://127.0.0.1:5000/api/users/delete/' + deleted_user_ID);
      var response = await client.delete(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      setState(() {
        deleteMsg = response.body;
      });
      //setDleteMsg(response.body);
    } finally {
      client.close();
    }
  }

  void findUserById() async {
    var client = new http.Client();
    try {
      print(user_ID);
      var url = Uri.parse('http://127.0.0.1:5000/api/users/' + user_ID);
      var response = await client.get(url);
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');

      setState(() {
        user_found = response.body;
      });

      print(user_found);
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Add User Form"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: setName,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: setEmail,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your address',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: setAddress,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your country',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: setCountry,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your phone',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: setPhone,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: ElevatedButton(
                  onPressed: () {
                    // Process data.
                    createUser();
                  },
                  child: const Text("submit")),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: const Text("Delete User Form")),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter user Id',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: setDeletedUserId,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: ElevatedButton(
                    onPressed: () {
                      deleteUser();
                    },
                    child: const Text("delete"))),
            Text(deleteMsg),
            const Text("find User By Id Form"),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter user Id',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: setUserId,
            ),
            ElevatedButton(
                onPressed: () {
                  findUserById();
                },
                child: const Text("find User")),
            Text(user_found),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: ElevatedButton(
                    onPressed: () {
                      getAllUsers();
                    },
                    child: const Text("Get All Users"))),
            Text('${_users}')
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
