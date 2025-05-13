import 'dart:convert';
import 'package:project04_repaired/history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:project04_repaired/Screens/historyscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

final TextEditingController name = TextEditingController();
String country = '';
bool isLoading = false;
List<History> history = List.empty(growable: true);

class _HomescreenState extends State<Homescreen> {

//Important **watchlater
  late SharedPreferences sp;

  Future<void> getSharedPreferences() async {
    sp = await SharedPreferences.getInstance();
    readData();
  }
//Important **watchlater
  void saveData() {
    List<String> historyList =
        history.map((country) => jsonEncode(country.toJson())).toList();
    sp.setStringList("myData", historyList);
  }
//Important **watchlater
  void readData() {
    List<String>? historyList = sp.getStringList('myData');
    if (historyList != null) {
      setState(() {
        history = historyList
            .map((item) => History.fromJson(jsonDecode(item)))
            .toList();
      });
    }
  }
//Important **watchlater
  String toSentenceCase(String input) {
    if (input.isEmpty) return input;
    String lowerCaseInput = input.toLowerCase();

    String sentenceCaseInput =
        lowerCaseInput[0].toUpperCase() + lowerCaseInput.substring(1);

    return sentenceCaseInput;
  }

  void getData() async {
    String vehicleName = name.text.trim();
    var url =
        Uri.parse('https://cars-test-api.vercel.app/api/vehicle/$vehicleName');
    Response rs = await get(url);
    String urs = jsonDecode(rs.body);
//Important **watchlater
    setState(() {
      isLoading = false;
      country = urs;

      if (vehicleName.isNotEmpty && country.isNotEmpty) {
        history.add(History(vehicleName: vehicleName, country: country));
        saveData();
      }
    });
  }
//Important **watchlater
  @override
  void initState() {
    super.initState();
    getData();
    getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xff011B25),
            Color(0xff02688D),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 320,
                    decoration: BoxDecoration(
                        color: const Color(0xff004696),
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 15.0,
                            offset: Offset(0, 0),
                          )
                        ]),
                    child: Center(
                        child: Text(
                      'ManufacturerINFO',
                      style: GoogleFonts.poppins(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xff00FF73),
                          shadows: [
                            const Shadow(
                              color: Colors.black,
                              blurRadius: 9.0,
                              offset: Offset(4.0, 5.0),
                            )
                          ]),
                    )),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  Container(
                    height: 199,
                    width: 320,
                    decoration: BoxDecoration(
                        color: const Color(0xff004696),
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 15.0,
                            offset: Offset(0, 0),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Center(
                          child: Text(
                        'This app provides a quick and easy way to find out where a vehicle brand was made ',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xffA3F1FF),
                          shadows: [
                            const Shadow(
                              color: Colors.black,
                              blurRadius: 9.0,
                              offset: Offset(3.0, 3.0),
                            )
                          ],
                        ),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  Container(
                    height: 280,
                    width: 320,
                    decoration: BoxDecoration(
                        color: const Color(0xff004696),
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 15.0,
                            offset: Offset(0, 0),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            color: const Color(0xFFA3F1FF),
                            child: TextField(
                                controller: name,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Vehicle Brand',
                                  hintStyle: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(),
                                )),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),

                          //Important **watchlater
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              String sentenceCaseName =
                                  toSentenceCase(name.text);
                              name.value = TextEditingValue(
                                text: sentenceCaseName,
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: sentenceCaseName.length),
                                ),
                              );
                              getData();
                            },
                            child: Column(
                              children: [
                                Container(
                                    width: 240,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF141234),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: const Center(
                                        child: Text(
                                      'Search',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ))),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          if (isLoading)
                            const Text(
                              'Loading...',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          else
                            Text(
                              'Made in: $country',
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                    child: Column(
                      children: [
                        Container(
                            width: 240,
                            height: 40,
                            decoration: BoxDecoration(
                                color: const Color(0xFF141234),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: const Center(
                                child: Text(
                              'See Search History',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ))),
                      ],
                    ),
                    //Important **watchlater
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Historyscreen(
                                  history: [],
                                )),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
