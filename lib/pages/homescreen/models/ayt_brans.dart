import 'package:takip_deneme/database/DatabaseHelper.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custombutton.dart';

class AytBrans extends StatefulWidget {
  const AytBrans({super.key});

  @override
  _AytBransDenemeState createState() => _AytBransDenemeState();
}

class _AytBransDenemeState extends State<AytBrans> {
  final TextEditingController denemeAdiController = TextEditingController();
  final TextEditingController dogruController = TextEditingController();
  final TextEditingController yanlisController = TextEditingController();

  // 🔹 Başlangıçta ilk elemanı seçili yapıyoruz
  String selectedDers = "Edebiyat";
  final List<String> dersler = ["Edebiyat", "Matematik", "Fen", "Sosyal"];

  void _hesaplaVeKaydet() async {
    int dogru = int.tryParse(dogruController.text) ?? 0;
    int yanlis = int.tryParse(yanlisController.text) ?? 0;
    int toplamSoru = 40;
    int bos = toplamSoru - (dogru + yanlis);
    double net = dogru - (yanlis / 4);

    Map<String, dynamic> yeniDeneme = {
      'denemeAdi': denemeAdiController.text,
      'ders': selectedDers,
      'dogru': dogru,
      'yanlis': yanlis,
      'bos': bos,
      'net': net
    };

    await DatabaseHelper.instance.insertBransAytDeneme(yeniDeneme);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sonuç"),
        content: Text(
            "Deneme: ${denemeAdiController.text}\nDers: $selectedDers\nDoğru: $dogru\nYanlış: $yanlis\nBoş: $bos\nNet: ${net.toStringAsFixed(2)}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              dogruController.clear();
              yanlisController.clear();
              denemeAdiController.clear();
            },
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text("AYT Branş Deneme",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 95, 51, 225),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
                controller: denemeAdiController,
                decoration: const InputDecoration(hintText: "Deneme Adı",border: OutlineInputBorder())),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              decoration: const InputDecoration( border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              ) ,
              value: selectedDers,
              onChanged: (value) {
                setState(() {
                  selectedDers = value!;
                });
              },
              items: dersler.map((ders) {
                return DropdownMenuItem(
                  value: ders,
                  child: Text(ders),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dogruController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Doğru",
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: yanlisController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Yanlış",
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 20),
            CustomButton(text: "Kaydet", onPressed: _hesaplaVeKaydet),

          ],
        ),
      ),
    );
  }
}
