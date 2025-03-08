import 'package:takip_deneme/database/DatabaseHelper.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custombutton.dart';

class AytGenel extends StatefulWidget {
  const AytGenel({super.key});

  @override
  _DenemeGirisPageState createState() => _DenemeGirisPageState();
}

class _DenemeGirisPageState extends State<AytGenel> {
  String? seciliBolum;
  final Map<String, TextEditingController> dogruKontrolleri = {};
  final Map<String, TextEditingController> yanlisKontrolleri = {};
  final TextEditingController denemeAdiController = TextEditingController();

  final List<String> dersler = ['Edebiyat', 'Matematik', 'Sosyal', 'Fen'];

  @override
  void initState() {
    super.initState();
    for (var ders in dersler) {
      dogruKontrolleri[ders] = TextEditingController();
      yanlisKontrolleri[ders] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in dogruKontrolleri.values) {
      controller.dispose();
    }
    for (var controller in yanlisKontrolleri.values) {
      controller.dispose();
    }
    denemeAdiController.dispose();
    super.dispose();
  }

  Future<void> kaydet() async {
    if (seciliBolum == null || denemeAdiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen bir bölüm ve deneme adı girin!")));
      return;
    }

    Map<String, int> netler = {};
    for (var ders in dersler) {
      int dogru = int.tryParse(dogruKontrolleri[ders]?.text ?? '0') ?? 0;
      int yanlis = int.tryParse(yanlisKontrolleri[ders]?.text ?? '0') ?? 0;
      int net = dogru - (yanlis ~/ 4);
      netler[ders] = net;
    }
    int hesap(String a) {
      int totalQuestions = 40;
      int correctAnswers =
          int.tryParse(dogruKontrolleri[a]?.text ?? '0') ?? 0;
      int incorrectAnswers =
          int.tryParse(yanlisKontrolleri[a]?.text ?? '0') ?? 0;
      int emptyAnswers = totalQuestions - (correctAnswers + incorrectAnswers);
      return emptyAnswers;
    }

    await DatabaseHelper.instance.insertAytDeneme({
      'denemeAdi': denemeAdiController.text,
      'bolum': seciliBolum,
      'edebiyatDogru':
      int.tryParse(dogruKontrolleri['Edebiyat']?.text ?? '0') ?? 0,
      'edebiyatYanlis':
      int.tryParse(yanlisKontrolleri['Edebiyat']?.text ?? '0') ?? 0,
      'edebiyatBos': hesap('Edebiyat'), // Boş soru sayısı
      'matematikDogru':
      int.tryParse(dogruKontrolleri['Matematik']?.text ?? '0') ?? 0,
      'matematikYanlis':
      int.tryParse(yanlisKontrolleri['Matematik']?.text ?? '0') ?? 0,
      'matematikBos': hesap('Matematik'),
      'sosyalDogru': int.tryParse(dogruKontrolleri['Sosyal']?.text ?? '0') ?? 0,
      'sosyalYanlis':
      int.tryParse(yanlisKontrolleri['Sosyal']?.text ?? '0') ?? 0,
      'sosyalBos': hesap('Sosyal'),
      'fenDogru': int.tryParse(dogruKontrolleri['Fen']?.text ?? '0') ?? 0,
      'fenYanlis': int.tryParse(yanlisKontrolleri['Fen']?.text ?? '0') ?? 0,
      'fenBos': hesap('Fen'),
      'net': netler.values.reduce((a, b) => a + b)
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Deneme başarıyla kaydedildi!")));
  }

  List<String> getGosterilecekDersler() {
    switch (seciliBolum) {
      case 'Eşit Ağırlık':
        return ['Edebiyat', 'Matematik'];
      case 'Sözel':
        return ['Edebiyat', 'Sosyal'];
      case 'Sayısal':
        return ['Matematik', 'Fen'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
      appBar: AppBar(title: const Text("AYT Deneme Ekle",style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 95, 51, 225),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: denemeAdiController,
              decoration: const InputDecoration(labelText: "Deneme Adı",border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Sözel', 'Eşit Ağırlık', 'Sayısal'].map((bolum) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      seciliBolum = bolum;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    seciliBolum == bolum ? const Color.fromARGB(255, 95, 51, 225) : Colors.black12,
                  ),
                  child: Text(bolum,
                      style: const TextStyle(
                      color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ...getGosterilecekDersler().map((ders) {
              return Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ders,
                          style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(

                            child: TextField(
                              controller: dogruKontrolleri[ders],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: "Doğru",border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: yanlisKontrolleri[ders],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: "Yanlış",border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            CustomButton(text: "Kaydet", onPressed: kaydet),
          ],
        ),
      ),
    );
  }
}
