
import 'package:takip_deneme/database/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:takip_deneme/widgets/custombutton.dart';

class TytGenel extends StatefulWidget {
  const TytGenel({super.key});

  @override
  State<TytGenel> createState() => _DenemeState();
}

class _DenemeState extends State<TytGenel> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final TextEditingController denemeAdi = TextEditingController();
  final TextEditingController turkceDogru = TextEditingController();
  final TextEditingController turkceYanlis = TextEditingController();
  final TextEditingController turkceBos = TextEditingController();
  final TextEditingController matematikDogru = TextEditingController();
  final TextEditingController matematikYanlis = TextEditingController();
  final TextEditingController matematikBos = TextEditingController();
  final TextEditingController sosyalDogru = TextEditingController();
  final TextEditingController sosyalYanlis = TextEditingController();
  final TextEditingController sosyalBos = TextEditingController();
  final TextEditingController fenDogru = TextEditingController();
  final TextEditingController fenYanlis = TextEditingController();
  final TextEditingController fenBos = TextEditingController();

  void _hesaplaVeKaydet() async {
    String denemeAdiText = denemeAdi.text.trim();
    if (denemeAdiText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen deneme adını girin!")),
      );
      return;
    }

    int tDogru = int.tryParse(turkceDogru.text) ?? 0;
    int tYanlis = int.tryParse(turkceYanlis.text) ?? 0;
    int tBos = int.tryParse(turkceBos.text) ?? 0; // Boş alan için ekleme
    int mDogru = int.tryParse(matematikDogru.text) ?? 0;
    int mYanlis = int.tryParse(matematikYanlis.text) ?? 0;
    int mBos = int.tryParse(matematikBos.text) ?? 0; // Boş alan için ekleme
    int sDogru = int.tryParse(sosyalDogru.text) ?? 0;
    int sYanlis = int.tryParse(sosyalYanlis.text) ?? 0;
    int sBos = int.tryParse(sosyalBos.text) ?? 0; // Boş alan için ekleme
    int fDogru = int.tryParse(fenDogru.text) ?? 0;
    int fYanlis = int.tryParse(fenYanlis.text) ?? 0;
    int fBos = int.tryParse(fenBos.text) ?? 0; // Boş alan için ekleme

    double toplamNet = (tDogru + mDogru + sDogru + fDogru) -
        ((tYanlis + mYanlis + sYanlis + fYanlis) / 4);

    await _dbHelper.insertDeneme(
      denemeAdiText,
      tDogru,
      tYanlis,
      tBos, // Boş alanlar da veritabanına eklenmeli
      mDogru,
      mYanlis,
      mBos, // Boş alanlar
      sDogru,
      sYanlis,
      sBos, // Boş alanlar
      fDogru,
      fYanlis,
      fBos, // Boş alanlar
      toplamNet, // double türünde
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Deneme Kaydedildi: $denemeAdiText Net: $toplamNet")),
    );

    Navigator.pop(context);
  }

  Widget _buildLessonInput(String lesson, TextEditingController correctController, TextEditingController wrongController) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildInputField("Doğru", correctController)),
                const SizedBox(width: 10),
                Expanded(child: _buildInputField("Yanlış", wrongController)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "0",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
            "TYT Deneme Ekle", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 95, 51, 225),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: denemeAdi,
              decoration: const InputDecoration(
                  labelText: "Deneme Adı", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            _buildLessonInput("Türkçe", turkceDogru, turkceYanlis),
            _buildLessonInput("Matematik", matematikDogru, matematikYanlis),
            _buildLessonInput("Sosyal", sosyalDogru, sosyalYanlis),
            _buildLessonInput("Fen", fenDogru, fenYanlis),
            const SizedBox(height: 16),
            CustomButton(text: "Kaydet", onPressed: _hesaplaVeKaydet),
          ],
        ),
      ),
    );
  }
  }

