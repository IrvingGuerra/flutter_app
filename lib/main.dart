import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<dynamic> fullList = [];

  @override
  void initState () {
     super.initState();
     fetchData();
  }

  void fetchData() async {
    try{
        final response1 = await http.get(Uri.parse('https://stage-api.ftnmethod.com/api/landing-psychologist/basic/'));
        final response2 = await http.get(Uri.parse('https://stage-api.ftnmethod.com/api/landing-coaches/basic/'));
        final response3 = await http.get(Uri.parse('https://stage-api.ftnmethod.com/api/landing-nutritionist/basic/'));
        List<dynamic> r1 = json.decode(response1.body);
        List<dynamic> r2 = json.decode(response2.body);
        List<dynamic> r3 = json.decode(response3.body);
        List<dynamic> list = [];
        int maxLength = 0;
        for(List<dynamic> array in [r1, r2, r3]){
            if(array.length > maxLength){
                maxLength = array.length;
            }
        }
        for(int i = 0 ; i < maxLength ; i++) {
            if(r1.length > i && r1[i] != null){
             list.add(r1[i]);
            }
            if(r2.length > i &&  r2[i] != null){
             list.add(r2[i]);
            }
            if(r3.length > i &&  r3[i] != null){
             list.add(r3[i]);
            }
        }
        setState(() {
            fullList = list;
        });
    } on Exception catch (_){
        rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: fullList.length,
        itemBuilder: (context, index) {
            return Card(
               child: ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(fullList[index]['avatar'])),
                    title: Text(fullList[index]['username']),
               ),
            );
        },
      ),
    );
  }
}
