import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:takip_deneme/navigation/main_navigation.dart';
import 'package:takip_deneme/widgets/user_info_form.dart';

class IntroScreen extends StatelessWidget {
  // IntroductionScreen için bir key tanımlıyoruz
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        key: introKey, // Key'i ekledik
        globalBackgroundColor: Colors.white,
        scrollPhysics: BouncingScrollPhysics(),
        pages: [
          PageViewModel(
            title: "Hedefine Birlikte Ulaşalım!",
            body:
            "Başarıya ulaşmak için eksiklerini analiz etmeli ve planlı çalışmalısın.",
            image: Image.asset("lib/assets/images/introimage1.png", height: 300),
          ),
          PageViewModel(
            title: "✍️ Seni Daha Yakından Tanıyalım!",
            image: Image.asset("lib/assets/images/introimage2.png", height: 400),
            bodyWidget: UserInfoForm(
              onComplete: () {
                // Form tamamlandığında bir sonraki sayfaya geç
                introKey.currentState?.next();
              },
            ),
          ),
          PageViewModel(
            title: "🚀 Hazırsan Başlıyoruz!",
            body: "Artık hedeflerin belli! Şimdi çalışmaya başlama zamanı.",
            image: Image.asset("lib/assets/images/introimage3.png", height: 300),
          ),
        ],
        done: Text("Başla", style: TextStyle(fontWeight: FontWeight.bold)),
        onDone: () async {
          var box = await Hive.openBox('appData');
          await box.put('isFirstLaunch', false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainNavigation()),
          );
        },
        next: Icon(Icons.arrow_forward, size: 30, weight: 5),
        dotsDecorator: DotsDecorator(
          size: Size(10, 10),
          color: Colors.grey,
          activeSize: Size(22, 10),
          activeColor: Colors.deepPurple,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}