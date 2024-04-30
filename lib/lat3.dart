import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class University {
  String name;
  String website;

  University({required this.name, required this.website});
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<List<University>> futureUniversities;

  String apiUrl = "http://universities.hipolabs.com/search?country=Indonesia";

  Future<List<University>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Jika server mengembalikan 200 OK (berhasil),
      // parse json
      List<dynamic> data = jsonDecode(response.body);
      List<University> universities = [];
      for (var item in data) {
        universities.add(
          University(
            name: item['name'],
            website: item['web_pages'].length > 0 ? item['web_pages'][0] : '',
          ),
        );
      }
      return universities;
    } else {
      // Jika gagal (bukan 200 OK),
      // lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversities = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University List',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('University List'),
        ),
        body: Center(
          child: FutureBuilder<List<University>>(
            future: futureUniversities,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].website),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
