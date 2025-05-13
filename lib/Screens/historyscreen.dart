import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project04_repaired/Screens/homescreen.dart';
import 'package:project04_repaired/history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Historyscreen extends StatefulWidget {
  const Historyscreen({
    super.key,
    required List<History> history,
  });
  @override
  State<Historyscreen> createState() => _HistoryscreenState();
}

class _HistoryscreenState extends State<Historyscreen> {

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
  @override
  void initState() {
    super.initState();
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
                'Your Search History',
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
              height: 40.0,
            ),
            //History container
            Container(
              height: 550,
              width: 320,
              decoration: BoxDecoration(
                  color: const Color(0xff004696),
                  borderRadius: BorderRadius.circular(50.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 15.0,
                      offset: Offset(0, 0),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(15.0),

                //Important **watchlater
                child: Expanded(
                  child: history.isEmpty
                      ? Center(
                          child: Text('No History',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: const Color(0xffA3F1FF))))
                      : ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) => Card(
                                color: const Color(0xFF013B7E),
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      Text(history[index].vehicleName,
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xffA3F1FF))),
                                      Text(history[index].country,
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:const Color(0xFF589AFD))),
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: 70,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 45,
                                        ),
                                        GestureDetector(
                                          child: const Icon(Icons.delete,
                                              color: Colors.white),
                                          onTap: () {
                                            setState(() {
                                              history.removeAt(index);
                                              saveData();
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                ),
              ),
            ),
          ],
        )),
      ),
    ));
  }
}
