import 'package:flutter/material.dart';
import 'package:takip_deneme/database/DatabaseHelper.dart';

import '../../../widgets/custombutton.dart';

class TytBrans extends StatefulWidget {
  const TytBrans({super.key});

  @override
  _BransDenemeleriPageState createState() => _BransDenemeleriPageState();
}

class _BransDenemeleriPageState extends State<TytBrans> {
  final TextEditingController _denemeAdiController = TextEditingController();
  final TextEditingController _dogruController = TextEditingController();
  final TextEditingController _yanlisController = TextEditingController();
  String? _selectedDers;
  final Map<String, int> soruSayilari = {
    'Türkçe': 40,
    'Matematik': 40,
    'Fen': 20,
    'Sosyal': 20,
  };

  void _kaydet() async {
    if (_selectedDers == null || _denemeAdiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun.")),
      );
      return;
    }

    int dogru = int.tryParse(_dogruController.text) ?? 0;
    int yanlis = int.tryParse(_yanlisController.text) ?? 0;
    int toplamSoru = soruSayilari[_selectedDers] ?? 0;
    int bos = toplamSoru - (dogru + yanlis);
    double net = dogru - (yanlis / 4);

    await DatabaseHelper.instance.insertBransTytDeneme({
      'denemeAdi': _denemeAdiController.text,
      'ders': _selectedDers,
      'dogru': dogru,
      'yanlis': yanlis,
      'bos': bos,
      'net': net,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deneme başarıyla kaydedildi!")),
    );

    _denemeAdiController.clear();
    _dogruController.clear();
    _yanlisController.clear();
    setState(() => _selectedDers = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 95, 51, 225),
          title: const Text("Branş Deneme Ekle",
          style: TextStyle(color: Colors.white),)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _denemeAdiController,
              decoration: const InputDecoration(labelText: "Deneme Adı",border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              decoration: const InputDecoration( border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              ) ,
              value: _selectedDers,
              hint: const Text("Ders Seç"),
              items: soruSayilari.keys.map((ders) {
                return DropdownMenuItem(
                  value: ders,
                  child: Text(ders),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDers = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dogruController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Doğru",
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _yanlisController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Yanlış",
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 20),
           CustomButton(text: "Kaydet", onPressed: _kaydet),
          ],
        ),
      ),
    );
  }
}
