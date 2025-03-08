

import 'package:flutter/material.dart';
import 'package:takip_deneme/database/DatabaseHelper.dart';
import 'package:takip_deneme/pages/homescreen/models/ayt_brans.dart';
import 'package:takip_deneme/pages/homescreen/models/ayt_genel.dart';
import 'package:takip_deneme/pages/homescreen/models/tyt_brans.dart';
import 'package:takip_deneme/widgets/custombutton.dart';
import 'package:takip_deneme/widgets/denemecard.dart';

import 'models/tyt_genel.dart';


class ListeScreen extends StatefulWidget {
  final String denemeTuru; // TYT, AYT veya BRANŞ bilgisini almak için

  const ListeScreen({super.key, required this.denemeTuru});

  @override
  State<ListeScreen> createState() => _DenemelerListesiState();
}

class _DenemelerListesiState extends State<ListeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _denemeler;

  @override
  void initState() {
    super.initState();
    _denemeler = _getDenemeler();
  }

  Future<List<Map<String, dynamic>>> _getDenemeler() async {
    if (widget.denemeTuru == "TYT") {
      return _dbHelper.getAllDenemeler();
    } else if (widget.denemeTuru == "AYT") {
      return _dbHelper.getAllAytDenemeler();
    } else if (widget.denemeTuru == "TYT_Brans") {
      return _dbHelper.getAllBransTytDenemeler(); // TYT branş denemeleri
    } else if (widget.denemeTuru == "AYT_Brans") {
      return _dbHelper.getAllBransAytDenemeler(); // AYT branş denemeleri
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text("${widget.denemeTuru} Denemelerim",
            style: const TextStyle(
                color: Colors.white, fontFamily: "Fonts", fontSize: 23)),
        backgroundColor: const Color.fromARGB(255, 95, 51, 225),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _denemeler,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz kaydedilen deneme yok.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var deneme = snapshot.data![index];
              return NetListItem(
                  name: deneme['denemeAdi'],
                  score: deneme['net'].toString(),
                  onDelete: () async {
                  await _dbHelper.deleteDeneme(deneme['id']);
                  setState(() {
                    _denemeler = _getDenemeler();
                  });
                  }
                  );
            },
          );
        },
      ),
      floatingActionButton: CustomButton(
        text: "Deneme Ekle",
        onPressed: () {
          if (widget.denemeTuru == "TYT") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TytGenel()),
            );
          } else if (widget.denemeTuru == "AYT") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AytGenel()),
            );
          } else if (widget.denemeTuru == "TYT_Brans") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TytBrans()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AytBrans()),
            );
          }
        }, // Artı butonu
      ),
    );
  }
  }

