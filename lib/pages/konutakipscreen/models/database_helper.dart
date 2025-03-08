import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'subject.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'subjects_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE subjects(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        progress REAL NOT NULL,
        examType TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE topics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        subjectId INTEGER NOT NULL,
        FOREIGN KEY (subjectId) REFERENCES subjects (id) ON DELETE CASCADE
      )
    ''');

    // TYT dersleri
    await _addInitialTYTSubjects(db);
    // Say dersleri
    await _addInitialSaySubjects(db);
    //EA dersleri
    await _addInitialEaSubjects(db);
    // Soz dersleri
    await _addInitialSozSubjects(db);
  }

  Future<void> _addInitialTYTSubjects(Database db) async {
    // Türkçe
    final turkceId = await db.insert('subjects', {
      'name': 'Türkçe',
      'progress': 0.0,
      'examType': 'TYT',
    });

    final turkceTopics = [
      'Sözcükte Anlam',
      'Söz Yorumu',
      'Deyim ve Atasözü',
      'Cümlede Anlam',
      'Anlatım Bozukluğu',
      'Paragrafta Anlatım Teknikleri',
      'Paragrafta Düşünceyi Geliştirme Yolları',
      'Paragrafta Yapı',
      'Paragrafta Konu-Ana Düşünce',
      'Paragrafta Yardımcı Düşünce',
      'Ses Bilgisi',
      'Sözcükte Yapı/Ekler',
      'Sözcük Türleri',
      'İsimler',
      'Zamirler',
      'Sıfatlar',
      'Zarflar',
      'Edat – Bağlaç – Ünlem',
      'Fiiller',
      'Fiilde Anlam (Kip-Kişi-Yapı)',
      'Ek Fiil',
      'Fiilimsi',
      'Fiilde Çatı',
      'Sözcük Grupları',
      'Cümlenin Ögeleri',
      'Cümle Türleri',
      'Yazım Kuralları',
      'Noktalama İşaretleri'
    ];

    for (var topic in turkceTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': turkceId,
      });
    }

    // Matematik
    final matematikId = await db.insert('subjects', {
      'name': 'Matematik',
      'progress': 0.0,
      'examType': 'TYT',
    });

    final matematikTopics = [
      'Temel Kavramlar',
      'Sayı Basamakları',
      'Bölme ve Bölünebilme',
      'EBOB – EKOK',
      'Rasyonel Sayılar',
      'Basit Eşitsizlikler',
      'Mutlak Değer',
      'Üslü Sayılar',
      'Köklü Sayılar',
      'Çarpanlara Ayırma',
      'Oran Orantı',
      'Denklem Çözme',
      'Problemler-Sayı Problemleri',
      'Kesir Problemleri',
      'Yaş Problemleri',
      'Hareket Hız Problemleri',
      'İşçi Emek Problemleri',
      'Yüzde Problemleri',
      'Kar Zarar Problemleri',
      'Karışım Problemleri',
      'Grafik Problemleri',
      'Rutin Olmayan Problemleri',
      'Kümeler – Kartezyen Çarpım',
      'Mantık',
      'Fonskiyonlar',
      'Polinomlar',
      '2.Dereceden Denklemler',
      'Permütasyon ve Kombinasyon',
      'Olasılık',
      'Veri – İstatistik'
    ];

    for (var topic in matematikTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': matematikId,
      });
    }

    // Tarih
    final tarihId = await db.insert('subjects', {
      'name': 'Tarih',
      'progress': 0.0,
      'examType': 'TYT',
    });

    final tarihTopics = [
      'Tarih ve Zaman',
      'İnsanlığın İlk Dönemleri',
      'Ortaçağ\'da Dünya',
      'İlk ve Orta Çağlarda Türk Dünyası',
      'İslam Medeniyetinin Doğuşu',
      'İlk Türk İslam Devletleri',
      'Yerleşme ve Devletleşme Sürecinde Selçuklu Türkiyesi',
      'Beylikten Devlete Osmanlı Siyaseti(1300-1453)',
      'Dünya Gücü Osmanlı Devleti (1453-1600)',
      'Yeni Çağ Avrupa Tarihi',
      'Yakın Çağ Avrupa Tarihi',
      'Osmanlı Devletinde Arayış Yılları',
      '18. Yüzyılda Değişim ve Diplomasi',
      'En Uzun Yüzyıl',
      'Osmanlı Kültür ve Medeniyeti',
      '20. Yüzyılda Osmanlı Devleti',
      'I. Dünya Savaşı',
      'Mondros Ateşkesi, İşgaller ve Cemiyetler',
      'Kurtuluş Savaşına Hazırlık Dönemi',
      'I. TBMM Dönemi',
      'Kurtuluş Savaşı ve Antlaşmalar',
      'II. TBMM Dönemi ve Çok Partili Hayata Geçiş',
      'Türk İnkılabı',
      'Atatürk İlkeleri',
      'Atatürk Dönemi Türk Dış Politikası'
    ];

    for (var topic in tarihTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': tarihId,
      });

    }// Cografya
    final cografyaId = await db.insert('subjects', {
      'name': 'Coğrafya',
      'progress': 0.0,
      'examType': 'TYT',
    });

    final cografyaTopics = [
      'Doğa ve İnsan',
      'Dünya\'nın Şekli ve Hareketleri',
      'Coğrafi Konum',
      'Harita Bilgisi',
      'Atmosfer ve Sıcaklık',
      'İklimler',
      'Basınç ve Rüzgarlar',
      'Nem, Yağış ve Buharlaşma',
      'İç Kuvvetler / Dış Kuvvetler',
      'Su – Toprak ve Bitkiler',
      'Nüfus',
      'Göç',
      'Yerleşme',
      'Türkiye\'nin Yer Şekilleri',
      'Ekonomik Faaliyetler',
      'Bölgeler',
      'Uluslararası Ulaşım Hatları',
      'Çevre ve Toplum',
      'Doğal Afetler'
    ];

    for (var topic in cografyaTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': cografyaId,
      });

    }// Felsefe
    final felsefeId = await db.insert('subjects', {
      'name': 'Felsefe',
      'progress': 0.0,
      'examType': 'TYT',
    });

    final felsefeTopics = [
      'Felsefenin Konusu',
      'Bilgi Felsefesi',
      'Varlık Felsefesi',
      'Din, Kültür ve Medniyet',
      'Ahlak Felsefesi',
      'Sanat Felsefesi',
      'Din Felsefesi',
      'Siyaset Felsefesi',
      'Bilim Felsefesi'
    ];

    for (var topic in felsefeTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': felsefeId,
      });
    }// Din
    final dinId = await db.insert('subjects', {
      'name': 'Din Kültürü ',
      'progress': 0.0,
      'examType': 'TYT',
    });

    final dinTopics = [
      'İnanç',
      'İbadet',
      'Ahlak ve Değerler',
      'Din, Kültür ve Medeniyet',
      'Hz. Muhammed (S.A.V.)',
      'Vahiy ve Akıl',
      'Dünya ve Ahiret',
      'Kur\'an\'a göre Hz. Muhammed (S.A.V.)',
      'İnançla İlgili Meseleler',
      'Yahudilik ve Hristiyanlık',
      'İslam ve Bilim',
      'Anadolu da İslam',
      'İslam Düşüncesinde Tasavvufi Yorumlar',
      'Güncel Dini Meseler',
      'Hint ve Çin Dinleri'
    ];

    for (var topic in dinTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': dinId,
      });
    }

    // Fizik
    final fizikId = await db.insert('subjects', {
      'name': 'Fizik',
      'progress': 0.0,
      'examType': 'TYT',
    });

    final fizikTopics = [
      'Fizik Bilimine Giriş',
      'Madde ve Özellikleri',
      'Sıvıların Kaldırma Kuvveti',
      'Basınç',
      'Isı, Sıcaklık ve Genleşme',
      'Hareket ve Kuvvet',
      'Dinamik',
      'İş, Güç ve Enerji',
      'Elektrik',
      'Manyetizma',
      'Dalgalar',
      'Optik'
    ];

    for (var topic in fizikTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': fizikId,
      });
    }   // Kimya
    final kimyaId = await db.insert('subjects', {
      'name': 'Kimya',
      'progress': 0.0,
      'examType': 'TYT',
    });

    final kimyaTopics = [
      'Kimya Bilimi',
      'Atom ve Yapısı',
      'Periyodik Sistem',
      'Kimyasal Türler Arası Etkileşimler',
      'Maddenin Halleri',
      'Kimyanın Temel Kanunları',
      'Asitler, Bazlar ve Tuzlar',
      'Kimyasal Hesaplamalar',
      'Karışımlar',
      'Endüstride ve Canlılarda Enerji',
      'Kimya Her Yerde'
    ];

    for (var topic in kimyaTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': kimyaId,
      });
    }   // Biyoloji
    final biyolojiId = await db.insert('subjects', {
      'name': 'Biyoloji',
      'progress': 0.0,
      'examType': 'TYT',
    });

    final biyolojiTopics = [
      'Canlıların Ortak Özellikleri',
      'Canlıların Temel Bileşenleri',
      'Hücre ve Organeller – Madde Geçişleri',
      'Canlıların Sınıflandırılması',
      'Hücrede Bölünme – Üreme',
      'Kalıtım',
      'Bitki Biyolojisi',
      'Ekosistem'
    ];

    for (var topic in biyolojiTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': biyolojiId,
      });
    }

  }

  Future<void> _addInitialSaySubjects(Database db) async {
    // AYT Matematik
    final aytMatId = await db.insert('subjects', {
      'name': 'AYT Matematik',
      'progress': 0.0,
      'examType': 'SAY',
    });

    final aytMatTopics = [
      'Fonksiyonlar',
      'Polinomlar',
      '2.Dereceden Denklemler',
      'Permütasyon ve Kombinasyon',
      'Binom ve Olasılık',
      'İstatistik',
      'Karmaşık Sayılar',
      '2.Dereceden Eşitsizlikler',
      'Parabol',
      'Trigonometri',
      'Logaritma',
      'Diziler',
      'Limit',
      'Türev',
      'İntegral',
    ];

    for (var topic in aytMatTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': aytMatId,
      });
    }

    // AYT Fizik
    final aytFizikId = await db.insert('subjects', {
      'name': 'AYT Fizik',
      'progress': 0.0,
      'examType': 'SAY',
    });

    final aytFizikTopics = [
      'Vektörler',
      'Kuvvet, Tork ve Denge',
      'Kütle Merkezi',
      'Basit Makineler',
      'Hareket',
      'Newton\'un Hareket Yasaları',
      'İş, Güç ve Enerji II',
      'Atışlar',
      'İtme ve Momentum',
      'Elektrik Alan ve Potansiyel',
      'Paralel Levhalar ve Sığa',
      'Manyetik Alan ve Manyetik Kuvvet',
      'İndüksiyon, Alternatif Akım ve Transformatörler',
      'Çembersel Hareket',
      'Dönme, Yuvarlanma ve Açısal Momentum',
      'Kütle Çekim ve Kepler Yasaları',
      'Basit Harmonik Hareket',
      'Dalga Mekaniği ve Elektromanyetik Dalgalar',
      'Atom Modelleri',
      'Büyük Patlama ve Parçacık Fiziği',
      'Radyoaktivite',
      'Özel Görelilik',
      'Kara Cisim Işıması',
      'Fotoelektrik Olay ve Compton Olayı',
      'Modern Fiziğin Teknolojideki Uygulamaları',
    ];

    for (var topic in aytFizikTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': aytFizikId,
      });
    }

    // AYT Kimya
    final aytKimyaId = await db.insert('subjects', {
      'name': 'AYT Kimya',
      'progress': 0.0,
      'examType': 'SAY',
    });

    final aytKimyaTopics = [
      'Kimya Bilimi',
      'Atom ve Periyodik Sistem',
      'Kimyasal Türler Arası Etkileşimler',
      'Kimyasal Hesaplamalar',
      'Kimyanın Temel Kanunları',
      'Asit, Baz ve Tuz',
      'Maddenin Halleri',
      'Karışımlar',
      'Doğa ve Kimya',
      'Kimya Her Yerde',
      'Modern Atom Teorisi',
      'Gazlar',
      'Sıvı Çözeltiler',
      'Kimyasal Tepkimelerde Enerji',
      'Kimyasal Tepkimelerde Hız',
      'Kimyasal Tepkimelerde Denge',
      'Asit-Baz Dengesi',
      'Çözünürlük Dengesi',
      'Kimya ve Elektrik',
      'Organik Kimyaya Giriş',
      'Organik Kimya',
      'Enerji Kaynakları ve Bilimsel Gelişmeler',
    ];

    for (var topic in aytKimyaTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': aytKimyaId,
      });
    }

    // AYT Biyoloji
    final aytBiyolojiId = await db.insert('subjects', {
      'name': 'AYT Biyoloji',
      'progress': 0.0,
      'examType': 'SAY',
    });

    final aytBiyolojiTopics = [
      'Sinir Sistemi',
      'Endokrin Sistem ve Hormonlar',
      'Duyu Organları',
      'Destek ve Hareket Sistemi',
      'Sindirim Sistemi',
      'Dolaşım ve Bağışıklık Sistemi',
      'Solunum Sistemi',
      'Üriner Sistem (Boşaltım Sistemi)',
      'Üreme Sistemi ve Embriyonik Gelişim',
      'Komünite Ekolojisi',
      'Popülasyon Ekolojisi',
      'Genden Proteine',
      'Canlılarda Enerji Dönüşümleri',
      'Bitki Biyolojisi',
      'Canlılar ve Çevre',
    ];

    for (var topic in aytBiyolojiTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': aytBiyolojiId,
      });
    }
  }

  Future<void> _addInitialEaSubjects(Database db) async {
    // AYT Eşit Ağırlık Matematik
    final eaMatId = await db.insert('subjects', {
      'name': 'AYT Matematik',
      'progress': 0.0,
      'examType': 'EA',
    });

    final eaMatTopics = [
      'Fonksiyonlar',
      'Polinomlar',
      '2.Dereceden Denklemler',
      'Permütasyon ve Kombinasyon',
      'Binom ve Olasılık',
      'İstatistik',
      'Karmaşık Sayılar',
      '2.Dereceden Eşitsizlikler',
      'Parabol',
      'Trigonometri',
      'Logaritma',
      'Diziler',
      'Limit',
      'Türev',
      'İntegral',
    ];

    for (var topic in eaMatTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': eaMatId,
      });
    }

    // AYT Edebiyat
    final eaEdebiyatId = await db.insert('subjects', {
      'name': 'AYT Edebiyat',
      'progress': 0.0,
      'examType': 'EA',
    });

    final eaEdebiyatTopics = [
      'Anlam Bilgisi',
      'Dil Bilgisi',
      'Güzel Sanatlar ve Edebiyat',
      'Metinlerin Sınıflandırılması',
      'Şiir Bilgisi',
      'Edebi Sanatlar',
      'Türk Edebiyatı Dönemleri',
      'İslamiyet Öncesi Türk Edebiyatı ve Geçiş Dönemi',
      'Halk Edebiyatı',
      'Divan Edebiyatı',
      'Tanzimat Edebiyatı',
      'Servet-i Fünun Edebiyatı',
      'Fecr-i Ati Edebiyatı',
      'Milli Edebiyat',
      'Cumhuriyet Dönemi Edebiyatı',
      'Edebiyat Akımları',
      'Dünya Edebiyatı',
    ];

    for (var topic in eaEdebiyatTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': eaEdebiyatId,
      });
    }

    // AYT Tarih 1
    final eaTarih1Id = await db.insert('subjects', {
      'name': 'AYT Tarih-1',
      'progress': 0.0,
      'examType': 'EA',
    });

    final eaTarih1Topics = [
      'Tarih ve Zaman',
      'İnsanlığın İlk Dönemleri',
      'Orta Çağ\'da Dünya',
      'İlk ve Orta Çağlarda Türk Dünyası',
      'İslam Medeniyetinin Doğuşu',
      'Türklerin İslamiyet\'i Kabulü ve İlk Türk İslam Devletleri',
      'Yerleşme ve Devletleşme Sürecinde Selçuklu Türkiyesi',
      'Beylikten Devlete Osmanlı Siyaseti',
      'Devletleşme Sürecinde Savaşçılar ve Askerler',
      'Beylikten Devlete Osmanlı Medeniyeti',
      'Dünya Gücü Osmanlı',
      'Sultan ve Osmanlı Merkez Teşkilatı',
      'Klasik Çağ\'da Osmanlı Toplum Düzeni',
      'Değişen Dünya Dengeleri Karşısında Osmanlı Siyaseti',
      'Değişim Çağında Avrupa ve Osmanlı',
      'Uluslararası İlişkilerde Denge Stratejisi (1774-1914)',
      'Devrimler Çağında Değişen Devlet-Toplum İlişkileri',
      'Sermaye ve Emek',
      'XIX. ve XX. Yüzyılda Değişen Gündelik Hayat',
      'XX. Yüzyıl Başlarında Osmanlı Devleti ve Dünya',
      'Milli Mücadele',
      'Atatürkçülük ve Türk İnkılabı',
      'İki Savaş Arasındaki Dönemde Türkiye ve Dünya',
      'II. Dünya Savaşı Sürecinde Türkiye ve Dünya',
      'II. Dünya Savaşı Sonrasında Türkiye ve Dünya',
      'Toplumsal Devrim Çağında Türkiye ve Dünya',
      'XXI. Yüzyılın Eşiğinde Türkiye ve Dünya',
    ];

    for (var topic in eaTarih1Topics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': eaTarih1Id,
      });
    }

    // AYT Coğrafya 1
    final eaCografya1Id = await db.insert('subjects', {
      'name': 'AYT Coğrafya-1',
      'progress': 0.0,
      'examType': 'EA',
    });

    final eaCografya1Topics = [
      'Ekosistem',
      'Nüfus Politikaları',
      'Türkiye’de Nüfus ve Yerleşme',
      'Ekonomik Faaliyetler ve Doğal Kaynaklar',
      'Göç ve Şehirleşme',
      'Geçmişten Geleceğe Şehir ve Ekonomi',
      'Türkiye’nin İşlevsel Bölgeleri ve Kalkınma Projeleri',
      'Hizmet Sektörünün Ekonomideki Yeri',
      'Küresel Ticaret',
      'Bölgeler ve Ülkeler',
      'Çevre ve Toplum',
      'Doğal Afetler',
    ];

    for (var topic in eaCografya1Topics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': eaCografya1Id,
      });
    }
  }

  Future<void> _addInitialSozSubjects(Database db) async {
    // AYT Sözel Edebiyat
    final sozEdebiyatId = await db.insert('subjects', {
      'name': 'AYT Edebiyat',
      'progress': 0.0,
      'examType': 'SOZ',
    });

    final sozEdebiyatTopics = [
      'Anlam Bilgisi',
      'Dil Bilgisi',
      'Güzel Sanatlar ve Edebiyat',
      'Metinlerin Sınıflandırılması',
      'Şiir Bilgisi',
      'Edebi Sanatlar',
      'Türk Edebiyatı Dönemleri',
      'İslamiyet Öncesi Türk Edebiyatı ve Geçiş Dönemi',
      'Halk Edebiyatı',
      'Divan Edebiyatı',
      'Tanzimat Edebiyatı',
      'Servet-i Fünun Edebiyatı',
      'Fecr-i Ati Edebiyatı',
      'Milli Edebiyat',
      'Cumhuriyet Dönemi Edebiyatı',
      'Edebiyat Akımları',
      'Dünya Edebiyatı',
    ];

    for (var topic in sozEdebiyatTopics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': sozEdebiyatId,
      });
    }
    // Tarih-1
    final sozTarih1Id = await db.insert('subjects', {
      'progress': 0.0,
      'name': 'AYT Tarih-1',
      'examType': 'SOZ',
    });

    final sozTarih1Topics = [
      'Tarih ve Zaman',
      'İnsanlığın İlk Dönemleri',
      'Orta Çağ\'da Dünya',
      'İlk ve Orta Çağlarda Türk Dünyası',
      'İslam Medeniyetinin Doğuşu',
      'Türklerin İslamiyeti Kabulü ve İlk Türk - İslam Devletleri',
      'Yerleşme ve Devletleşme Sürecinde Selçuklu Türkiye\'si',
      'Beylikten Devlete Osmanlı Siyaseti',
      'Devletleşme Sürecinde Savaşçılar ve Askerler',
      'Beylikten Devlete Osmanlı Medeniyeti',
      'Dünya Gücü Osmanlı',
      'Sultan ve Osmanlı Merkez Teşkilatı',
      'Klasik Çağ\'da Osmanlı Toplum Düzeni',
      'Değişen Dünya Dengeleri Karşısında Osmanlı Siyaseti',
      'Değişim Çağında Avrupa ve Osmanlı',
      'Uluslararası İlişkilerde Denge Stratejisi (1774-1914)',
      'Devrimler Çağında Değişen Devlet-Toplum İlişkileri',
      'Sermaye ve Emek',
      'XIX. ve XX. Yüzyılda Değişen Gündelik Hayat',
      'XX. Yüzyıl Başlarında Osmanlı Devleti ve Dünya',
      'Milli Mücadele',
      'Atatürkçülük ve Türk İnkılabı',
      'İki Savaş Arasındaki Dönemde Türkiye ve Dünya',
      'II. Dünya Savaşı Sürecinde Türkiye ve Dünya',
      'II. Dünya Savaşı Sonrasında Türkiye ve Dünya',
      'Toplumsal Devrim Çağında Türkiye ve Dünya',
      'XXI. Yüzyılın Eşiğinde Türkiye ve Dünya',
    ];

    for (var topic in sozTarih1Topics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': sozTarih1Id,
      });
    }
    // AYT Cografya-1
    final sozCografya1Id = await db.insert('subjects', {
      'name': 'AYT Coğrafya-1',
      'progress': 0.0,
      'examType': 'SOZ',
    });

    final sozCografya1Topics = [
      'Ekosistem',
      'Nüfus Politikaları',
      'Türkiye’de Nüfus ve Yerleşme',
      'Ekonomik Faaliyetler ve Doğal Kaynaklar',
      'Göç ve Şehirleşme',
      'Geçmişten Geleceğe Şehir ve Ekonomi',
      'Türkiye’nin İşlevsel Bölgeleri ve Kalkınma Projeleri',
      'Hizmet Sektörünün Ekonomideki Yeri',
      'Küresel Ticaret',
      'Bölgeler ve Ülkeler',
      'Çevre ve Toplum',
      'Doğal Afetler',
    ];

    for (var topic in sozCografya1Topics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': sozCografya1Id,
      });
    }

    // AYT Tarih 2
    final sozTarih2Id = await db.insert('subjects', {
      'progress': 0.0,
      'name': 'AYT Tarih-2',
      'examType': 'SOZ',
    });

    final sozTarih2Topics = [
      'Tarih Bilimi',
      'İlk ve Orta Çağlarda Türk Dünyası',
      'Türklerin İslamiyeti Kabulü ve İlk Türk - İslam Devletleri',
      'Beylikten Devlete',
      'Orta Çağda Avrupa',
      'Osmanlı Devleti Yükselme Dönemi',
      'Osmanlı Devleti Dağılma Dönemi',
      'Birinci Dünya Savaşı',
      'Kurtuluş Savaşında Cepheler ve Antlaşmalar',
      'İki Savaş Arası Dönemde Türkiye',
    ];

    for (var topic in sozTarih2Topics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': sozTarih2Id,
      });
    }
    // AYT Cografya-2
    final sozCografya2Id = await db.insert('subjects', {
      'name': 'AYT Coğrafya-2',
      'progress': 0.0,
      'examType': 'SOZ',
    });

    final sozCografya2Topics = [
      'Doğa ve İnsan',
      'Dünya\'nın Şekli ve Hareketleri',
      'Coğrafi Konum',
      'Harita Bilgisi',
      'İklim Bilgisi',
      'Yerin Şekillenmesi',
      'Doğanın Varlıkları',
      'Beşeri Yapı',
      'Nüfusun Gelişimi, Dağılışı ve Niteliği',
      'Göçlerin Nedenleri ve Sonuçları',
      'Geçim Tarzları',
      'Türkiye\'nin Yeryüzü Şekilleri ve Özellikleri',
      'Türkiye İklimi ve Özellikleri',
      'Türkiye\'nin Doğal Varlıkları',
      'Türkiye\'de Yerleşme, Nüfus ve Göç',
      'Bölge Türleri ve Sınırları',
      'Konum ve Etkileşim',
      'Coğrafi Keşifler',
      'Doğa ile İnsan Arasındaki Etkileşim',
      'Doğal Afetler',
    ];

    for (var topic in sozCografya2Topics) {
      await db.insert('topics', {
        'name': topic,
        'isCompleted': 0,
        'subjectId': sozCografya2Id,
      });
    }
  }


  Future<List<Subject>> getSubjects(String examType) async {
    final db = await database;
    final List<Map<String, dynamic>> subjectMaps = await db.query(
      'subjects',
      where: 'examType = ?',
      whereArgs: [examType],
    );

    final List<Subject> subjects = [];
    for (var subjectMap in subjectMaps) {
      final topics = await getTopicsForSubject(subjectMap['id'] as int);
      subjects.add(Subject(
        id: subjectMap['id'] as int,
        name: subjectMap['name'] as String,
        progress: subjectMap['progress'] as double,
        topics: topics,
      ));
    }
    return subjects;
  }

  Future<List<Topic>> getTopicsForSubject(int subjectId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'topics',
      where: 'subjectId = ?',
      whereArgs: [subjectId],
    );

    return List.generate(maps.length, (i) {
      return Topic(
        name: maps[i]['name'],
        isCompleted: maps[i]['isCompleted'] == 1,
      );
    });
  }

  Future<void> updateTopicStatus(int subjectId, String topicName, bool isCompleted) async {
    final db = await database;
    await db.update(
      'topics',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'subjectId = ? AND name = ?',
      whereArgs: [subjectId, topicName],
    );
  }

  Future<void> updateSubjectProgress(int subjectId, double progress) async {
    final db = await database;
    await db.update(
      'subjects',
      {'progress': progress},
      where: 'id = ?',
      whereArgs: [subjectId],
    );
  }

  Future<Map<String, dynamic>> getTopicWithId(String topicName, int subjectId) async {
    final db = await database;
    final result = await db.query(
      'topics',
      where: 'name = ? AND subjectId = ?',
      whereArgs: [topicName, subjectId],
      limit: 1,
    );
    return result.first;
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('topics');
    await db.delete('subjects');
  }
}
