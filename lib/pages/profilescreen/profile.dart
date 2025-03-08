import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takip_deneme/providers/user_provider.dart';
import 'package:takip_deneme/widgets/custombutton.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  static const primaryColor = Color.fromARGB(255, 95, 51, 225);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Fonts",
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profil Bilgileri",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    Icons.person,
                    "Ad",
                    userProvider.name.isNotEmpty
                        ? userProvider.name
                        : "Belirtilmemiş",
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    Icons.school,
                    "Hedef Fakülte",
                    userProvider.targetDepartment.isNotEmpty
                        ? userProvider.targetDepartment
                        : "Belirtilmemiş",
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    Icons.assessment,
                    "Hedef TYT Neti",
                    userProvider.tytNet.toString(),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    Icons.assessment,
                    "Hedef AYT Neti",
                    userProvider.aytNet.toString(),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(Icons.auto_graph, "Hedef/Başarı Oranı", "%80"),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 20),
                 CustomButton(text: "Profili Düzenle",
                     onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content:
                          Text("Profil düzenleme yakında gelecek!",),
                            duration:  Duration(seconds: 2),

                          )
                      );
                     }
                 ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Bilgi satırını oluşturan yardımcı widget
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}