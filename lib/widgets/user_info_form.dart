import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takip_deneme/providers/user_provider.dart';

class UserInfoForm extends StatefulWidget {
  final VoidCallback? onComplete;

  const UserInfoForm({Key? key, this.onComplete}) : super(key: key);

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _tytNetController = TextEditingController();
  final _aytNetController = TextEditingController();

  @override
  void dispose() {
    _tytNetController.dispose();
    _aytNetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Ad",
                hintText: "Adınızı girin",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Lütfen adınızı girin";
                }
                return null;
              },
              onChanged: (value) {
                userProvider.setName(value);
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Hedef Bölüm",
                hintText: "Hedef bölümünüzü girin",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Lütfen hedef bölümünüzü girin";
                }
                return null;
              },
              onChanged: (value) {
                userProvider.setTargetDepartment(value);
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _tytNetController,
              decoration: const InputDecoration(
                labelText: "Hedef TYT Neti",
                hintText: "Örn: 90",
                border: OutlineInputBorder(),
              ),
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Lütfen TYT netinizi girin";
                }
                final double? tytNet = double.tryParse(value);
                if (tytNet == null) {
                  return "Lütfen geçerli bir TYT neti girin";
                }
                return null;
              },
              onChanged: (value) {
                final double tytNet = double.tryParse(value) ?? 0.0;
                userProvider.setTytNet(tytNet);
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _aytNetController,
              decoration: const InputDecoration(
                labelText: "Hedef AYT Neti",
                hintText: "Örn: 65 ",
                border: OutlineInputBorder(),
              ),
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Lütfen AYT netinizi girin";
                }
                final double? aytNet = double.tryParse(value);
                if (aytNet == null) {
                  return "Lütfen geçerli bir AYT neti girin";
                }
                return null;
              },
              onChanged: (value) {
                final double aytNet = double.tryParse(value) ?? 0.0;
                userProvider.setAytNet(aytNet);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await userProvider.saveUserData();
                  if (widget.onComplete != null) {
                    widget.onComplete!();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              ).copyWith(
                backgroundColor: MaterialStateProperty.all(Colors.transparent), // Arka planı şeffaf yap
                overlayColor: MaterialStateProperty.all(Colors.black12), // Tıklama efekti
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurple, Colors.deepPurpleAccent], // Degrade renkler
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Center(
                  child: Text(
                    "Kaydet",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}