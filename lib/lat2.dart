import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class Activity {
  String aktivitas;
  String jenis;

  Activity({required this.aktivitas, required this.jenis});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity;
  String url = "https://www.boredapi.com/api/activity";

  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat aktivitas');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = fetchData();
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      futureActivity = fetchData();
                    });
                  },
                  child: const Text("Saya bosan ..."),
                ),
              ),
              FutureBuilder<Activity>(
                future: futureActivity,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(snapshot.data!.aktivitas),
                        Text("Jenis: ${snapshot.data!.jenis}")
                      ],
                    );
                  } else {
                    return const Text('Tidak ada aktivitas ditemukan.');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
