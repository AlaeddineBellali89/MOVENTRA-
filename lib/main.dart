import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'motion_coach.dart';

void main() => runApp(const MoventraApp());

class MoventraApp extends StatefulWidget {
  const MoventraApp({super.key});

  @override
  State<MoventraApp> createState() => _MoventraAppState();
}

class _MoventraAppState extends State<MoventraApp> {
  ThemeMode themeMode = ThemeMode.system;

  static const brand = Color(0xFF8B5CF6);
  static const brand2 = Color(0xFF38BDF8);

  ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: brand,
      brightness: brightness,
      primary: brand,
      secondary: brand2,
      error: const Color(0xFFFF4D67),
      surface: dark ? const Color(0xFF121722) : const Color(0xFFF8FAFD),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          dark ? const Color(0xFF070B12) : const Color(0xFFF1F5F9),
      cardTheme: CardThemeData(
        elevation: 0,
        color: dark ? const Color(0xFF111722) : const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 74,
        backgroundColor: dark ? const Color(0xFF10141D) : Colors.white,
        indicatorColor: brand.withValues(alpha: dark ? .28 : .16),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: .4,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF111620) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: dark ? Colors.white10 : Colors.black12,
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: brand,
        thumbColor: brand,
        overlayColor: brand.withValues(alpha: .16),
      ),
    );
  }

  void cycleTheme() {
    setState(() {
      themeMode = switch (themeMode) {
        ThemeMode.system => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.light,
        ThemeMode.light => ThemeMode.system,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MOVENTRA',
      themeMode: themeMode,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: Shell(
        themeMode: themeMode,
        onCycleTheme: cycleTheme,
      ),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({
    super.key,
    required this.themeMode,
    required this.onCycleTheme,
  });

  final ThemeMode themeMode;
  final VoidCallback onCycleTheme;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int page = 0;
  String lang = 'en';

  // Profile
  bool profileSaved = false;
  String firstName = '';
  String lastName = '';
  bool privacyAccepted = false;
  int age = 30;
  double heightCm = 175;
  double weightKg = 75;
  String sex = 'preferNot';
  String activityLevel = 'active';
  String sportType = 'fitness';
  int trainingDays = 3;
  String experience = 'intermediate';
  String goal = 'general';

  // Body check
  double pain = 3;
  String bodyArea = 'shoulder';
  String bodySide = 'right';
  bool checkSaved = false;
  final Set<String> painfulZones = <String>{};
  bool bodyBackView = false;
  double bodyRotation = 0.0;
  bool useReal3D = true;
  String symptomDuration = 'recent';
  String symptomPattern = 'movement';
  bool redFlagTrauma = false;
  bool redFlagNeuro = false;
  bool redFlagSystemic = false;
  bool redFlagBowelBladder = false;
  bool trainingDone = false;
  bool recoveryDone = false;
  final List<String> checkHistory = <String>[];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      checkHistory
        ..clear()
        ..addAll(prefs.getStringList('moventra_check_history') ?? const []);
    });
  }

  Future<void> _saveCheckToHistory() async {
    final now = DateTime.now();
    final stamp =
        '${now.year.toString().padLeft(4,'0')}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} '
        '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}';
    final zones = painfulZones.isEmpty ? '$bodyArea/$bodySide' : painfulZones.join(', ');
    final entry = '$stamp|$zones|${pain.round()}|${hasSafetyFlag ? 'SAFETY' : 'OK'}';
    checkHistory.insert(0, entry);
    if (checkHistory.length > 60) checkHistory.removeRange(60, checkHistory.length);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('moventra_check_history', checkHistory);
  }

  final Map<String, Map<String, String>> t = {
    'en': {
      'today': 'Today',
      'check': 'Check',
      'workout': 'Workout',
      'recovery': 'Recovery',
      'progress': 'Progress',
      'slogan': 'Train. Recover. Return Stronger.',
      'plan': "Today's Plan",
      'push': 'Push Day • Upper Body',
      'focus': 'Recovery focus',
      'shoulder': 'Right shoulder • Mobility & controlled load',
      'start': 'Start body check-in',
      'body': 'Body check-in',
      'pain': 'Pain level',
      'ready': 'Readiness',
      'session': 'Today’s workout',
      'exercise': 'Training session and exercise guidance',
      'recTitle': 'Recovery',
      'recText': 'Mobility, controlled load and recovery guidance',
      'progTitle': 'Progress',
      'progText': 'Track your training and recovery progress',
      'notice':
          'Prototype only: MOVENTRA supports training decisions and symptom tracking. It does not diagnose injuries or replace qualified medical care.',
    },
    'ar': {
      'today': 'اليوم',
      'check': 'الفحص',
      'workout': 'التمرين',
      'recovery': 'التعافي',
      'progress': 'التقدم',
      'slogan': 'تمرّن. تعافَ. عُد أقوى.',
      'plan': 'خطة اليوم',
      'push': 'تمارين الدفع • الجزء العلوي',
      'focus': 'تركيز التعافي',
      'shoulder': 'الكتف الأيمن • الحركة والحمل المتحكم به',
      'start': 'ابدأ فحص الجسم',
      'body': 'فحص الجسم',
      'pain': 'مستوى الألم',
      'ready': 'الاستعداد',
      'session': 'تمرين اليوم',
      'exercise': 'جلسة التدريب وإرشادات التمارين',
      'recTitle': 'التعافي',
      'recText': 'الحركة والحمل المتحكم به وإرشادات التعافي',
      'progTitle': 'التقدم',
      'progText': 'تابع تقدم التدريب والتعافي',
      'notice':
          'نسخة تجريبية: تساعد MOVENTRA في قرارات التدريب ومتابعة الأعراض، ولا تشخّص الإصابات ولا تستبدل الرعاية الطبية المتخصصة.',
    },
    'fr': {
      'today': "Aujourd'hui",
      'check': 'Bilan',
      'workout': 'Entraînement',
      'recovery': 'Récupération',
      'progress': 'Progrès',
      'slogan': 'Entraînez-vous. Récupérez. Revenez plus fort.',
      'plan': 'Programme du jour',
      'push': 'Push Day • Haut du corps',
      'focus': 'Priorité récupération',
      'shoulder': 'Épaule droite • Mobilité et charge contrôlée',
      'start': 'Commencer le bilan',
      'body': 'Bilan corporel',
      'pain': 'Niveau de douleur',
      'ready': 'État de préparation',
      'session': "Entraînement du jour",
      'exercise': "Séance et conseils d'entraînement",
      'recTitle': 'Récupération',
      'recText': 'Mobilité, charge contrôlée et conseils de récupération',
      'progTitle': 'Progrès',
      'progText': "Suivez vos progrès d'entraînement et de récupération",
      'notice':
          "Prototype : MOVENTRA aide aux décisions d'entraînement et au suivi des symptômes. Elle ne diagnostique pas les blessures et ne remplace pas un professionnel de santé.",
    },
    'de': {
      'today': 'Heute',
      'check': 'Check',
      'workout': 'Training',
      'recovery': 'Erholung',
      'progress': 'Fortschritt',
      'slogan': 'Trainieren. Erholen. Stärker zurückkehren.',
      'plan': 'Heutiger Plan',
      'push': 'Push Day • Oberkörper',
      'focus': 'Erholungsfokus',
      'shoulder': 'Rechte Schulter • Mobilität & kontrollierte Belastung',
      'start': 'Körper-Check starten',
      'body': 'Körper-Check',
      'pain': 'Schmerzniveau',
      'ready': 'Bereitschaft',
      'session': 'Heutiges Training',
      'exercise': 'Trainingseinheit und Übungshinweise',
      'recTitle': 'Erholung',
      'recText': 'Mobilität, kontrollierte Belastung und Erholungshinweise',
      'progTitle': 'Fortschritt',
      'progText': 'Trainings- und Erholungsfortschritt verfolgen',
      'notice':
          'Prototyp: MOVENTRA unterstützt Trainingsentscheidungen und Symptomverfolgung. Die App diagnostiziert keine Verletzungen und ersetzt keine medizinische Versorgung.',
    },
  };

  String tr(String key) => t[lang]![key] ?? key;

  void showProfile() {
    String label(String en, String ar, String fr, String de) {
      if (lang == 'ar') return ar;
      if (lang == 'fr') return fr;
      if (lang == 'de') return de;
      return en;
    }

    final ageC = TextEditingController(text: age.toString());
    final heightC = TextEditingController(text: heightCm.round().toString());
    final weightC = TextEditingController(text: weightKg.toStringAsFixed(1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Directionality(
          textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 10),
                      Expanded(child: Text(
                        label('Profile','الملف الشخصي','Profil','Profil'),
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      )),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: label('First name','الاسم','Prénom','Vorname'),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => firstName = v.trim(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: label('Last name','اللقب','Nom','Nachname'),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => lastName = v.trim(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: ageC,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: label('Age','العمر','Âge','Alter'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: heightC,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: label('Height (cm)','الطول (سم)','Taille (cm)','Größe (cm)'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: weightC,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: label('Weight (kg)','الوزن (كغ)','Poids (kg)','Gewicht (kg)'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: sex,
                      decoration: InputDecoration(
                        labelText: label('Sex','الجنس','Sexe','Geschlecht'),
                      ),
                      items: [
                        DropdownMenuItem(value:'female', child: Text(label('Female','أنثى','Femme','Weiblich'))),
                        DropdownMenuItem(value:'male', child: Text(label('Male','ذكر','Homme','Männlich'))),
                        DropdownMenuItem(value:'preferNot', child: Text(label('Prefer not to say','أفضل عدم الإجابة','Préfère ne pas répondre','Keine Angabe'))),
                      ],
                      onChanged: (v) => setSheetState(() => sex = v ?? sex),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: activityLevel,
                      decoration: InputDecoration(
                        labelText: label('Activity level','مستوى النشاط',"Niveau d'activité",'Aktivitätsniveau'),
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value:'sedentary', child: Text(label('Sedentary','قليل الحركة','Sédentaire','Überwiegend sitzend'))),
                        DropdownMenuItem(value:'light', child: Text(label('Lightly active','نشاط خفيف','Légèrement actif','Leicht aktiv'))),
                        DropdownMenuItem(value:'active', child: Text(label('Active','نشيط','Actif','Aktiv'))),
                        DropdownMenuItem(value:'athlete', child: Text(label('Athlete','رياضي','Sportif','Sportlich'))),
                      ],
                      onChanged: (v) => setSheetState(() => activityLevel = v ?? activityLevel),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: sportType,
                      decoration: InputDecoration(
                        labelText: label('Main sport','الرياضة الأساسية','Sport principal','Hauptsport'),
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value:'fitness', child: Text(label('Fitness / gym','الجيم / اللياقة','Fitness / salle','Fitness / Gym'))),
                        DropdownMenuItem(value:'running', child: Text(label('Running','الجري','Course','Laufen'))),
                        DropdownMenuItem(value:'football', child: Text(label('Football','كرة القدم','Football','Fußball'))),
                        DropdownMenuItem(value:'cycling', child: Text(label('Cycling','الدراجات','Cyclisme','Radfahren'))),
                        DropdownMenuItem(value:'swimming', child: Text(label('Swimming','السباحة','Natation','Schwimmen'))),
                        DropdownMenuItem(value:'other', child: Text(label('Other','أخرى','Autre','Andere'))),
                      ],
                      onChanged: (v) => setSheetState(() => sportType = v ?? sportType),
                    ),
                    const SizedBox(height: 14),
                    Text('${label('Training days / week','أيام التدريب أسبوعيًا',"Jours d'entraînement / semaine",'Trainingstage / Woche')}: $trainingDays'),
                    Slider(
                      value: trainingDays.toDouble(),
                      min: 0, max: 7, divisions: 7,
                      label: trainingDays.toString(),
                      onChanged: (v) => setSheetState(() => trainingDays = v.round()),
                    ),
                    DropdownButtonFormField<String>(
                      value: experience,
                      decoration: InputDecoration(
                        labelText: label('Experience','الخبرة','Expérience','Erfahrung'),
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value:'beginner', child: Text(label('Beginner','مبتدئ','Débutant','Anfänger'))),
                        DropdownMenuItem(value:'intermediate', child: Text(label('Intermediate','متوسط','Intermédiaire','Mittelstufe'))),
                        DropdownMenuItem(value:'advanced', child: Text(label('Advanced','متقدم','Avancé','Fortgeschritten'))),
                      ],
                      onChanged: (v) => setSheetState(() => experience = v ?? experience),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: goal,
                      decoration: InputDecoration(
                        labelText: label('Goal','الهدف','Objectif','Ziel'),
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value:'general', child: Text(label('General fitness','لياقة عامة','Forme générale','Allgemeine Fitness'))),
                        DropdownMenuItem(value:'strength', child: Text(label('Strength','القوة','Force','Kraft'))),
                        DropdownMenuItem(value:'muscle', child: Text(label('Build muscle','بناء العضلات','Prise de muscle','Muskelaufbau'))),
                        DropdownMenuItem(value:'endurance', child: Text(label('Endurance','التحمل','Endurance','Ausdauer'))),
                        DropdownMenuItem(value:'return', child: Text(label('Return to training','العودة للتدريب',"Retour à l'entraînement",'Zurück zum Training'))),
                      ],
                      onChanged: (v) => setSheetState(() => goal = v ?? goal),
                    ),
                    const SizedBox(height: 18),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: privacyAccepted,
                      title: Text(label(
                        'I consent to storing these profile and Body Check data on this device for MOVENTRA personalization.',
                        'أوافق على حفظ بيانات الملف الشخصي وفحص الجسم على هذا الجهاز لتخصيص MOVENTRA.',
                        'J’accepte le stockage de ces données de profil et de bilan sur cet appareil pour personnaliser MOVENTRA.',
                        'Ich stimme der Speicherung dieser Profil- und Körpercheck-Daten auf diesem Gerät zur Personalisierung von MOVENTRA zu.'
                      )),
                      subtitle: Text(label(
                        'You can clear your profile data from this screen.',
                        'يمكنك حذف بيانات ملفك الشخصي من هذه الشاشة.',
                        'Vous pouvez effacer vos données de profil depuis cet écran.',
                        'Du kannst deine Profildaten in diesem Bereich löschen.'
                      )),
                      onChanged: (v) => setSheetState(() => privacyAccepted = v ?? false),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          firstName = '';
                          lastName = '';
                          profileSaved = false;
                          privacyAccepted = false;
                        });
                        Navigator.pop(sheetContext);
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: Text(label('Clear profile data','حذف بيانات الملف','Effacer les données','Profildaten löschen')),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: privacyAccepted ? () {
                        final a = int.tryParse(ageC.text);
                        final h = double.tryParse(heightC.text.replaceAll(',', '.'));
                        final w = double.tryParse(weightC.text.replaceAll(',', '.'));
                        setState(() {
                          if (a != null && a >= 13 && a <= 100) age = a;
                          if (h != null && h >= 100 && h <= 230) heightCm = h;
                          if (w != null && w >= 30 && w <= 300) weightKg = w;
                          profileSaved = true;
                        });
                        Navigator.pop(sheetContext);
                      } : null,
                      icon: const Icon(Icons.save),
                      label: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text(label('Save profile','حفظ الملف الشخصي','Enregistrer le profil','Profil speichern')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void chooseLanguage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('🇬🇧 English'),
              onTap: () => setLanguage('en'),
            ),
            ListTile(
              title: const Text('🇹🇳 العربية'),
              onTap: () => setLanguage('ar'),
            ),
            ListTile(
              title: const Text('🇫🇷 Français'),
              onTap: () => setLanguage('fr'),
            ),
            ListTile(
              title: const Text('🇩🇪 Deutsch'),
              onTap: () => setLanguage('de'),
            ),
          ],
        ),
      ),
    );
  }

  void setLanguage(String value) {
    Navigator.pop(context);
    setState(() => lang = value);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      checkPage(),
      workoutPage(),
      recoveryPage(),
      progressPage(),
    ];

    return Directionality(
      textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MOVENTRA', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('by Bellali', style: TextStyle(fontSize: 10)),
            ],
          ),
          actions: [
            IconButton(
              onPressed: showProfile,
              icon: const Icon(Icons.person_outline),
              tooltip: 'Profile',
            ),
            IconButton(
              onPressed: widget.onCycleTheme,
              icon: Icon(
                widget.themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : widget.themeMode == ThemeMode.light
                        ? Icons.light_mode
                        : Icons.brightness_auto,
              ),
              tooltip: 'System / Dark / Light',
            ),
            IconButton(
              onPressed: chooseLanguage,
              icon: const Icon(Icons.language),
              tooltip: 'Language',
            ),
          ],
        ),
        body: SafeArea(child: pages[page]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: page,
          onDestinationSelected: (value) => setState(() => page = value),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home),
              label: tr('today'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.accessibility_new),
              label: tr('check'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.fitness_center),
              label: tr('workout'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.healing),
              label: tr('recovery'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.insights),
              label: tr('progress'),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageBody(List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget infoCard(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: Icon(icon),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget homePage() {
    return pageBody([
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6D5DFB), Color(0xFF4776E6)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6D5DFB).withValues(alpha: .22),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MOVENTRA',
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            const SizedBox(height: 6),
            Text(tr('slogan'),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            Row(children: [
              const Icon(Icons.auto_awesome, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(
                lang == 'ar' ? 'فحص • تدريب • تعافٍ • تقدم' : 'Check • Train • Recover • Progress',
                style: const TextStyle(color: Colors.white70),
              )),
            ]),
          ],
        ),
      ),
      const SizedBox(height: 18),
      infoCard(
        Icons.person,
        lang == 'ar' ? 'الملف الشخصي' : (lang == 'fr' ? 'Profil' : (lang == 'de' ? 'Profil' : 'Profile')),
        profileSaved
            ? '${[firstName, lastName].where((e) => e.isNotEmpty).join(' ')} • $age • ${heightCm.round()} cm • ${weightKg.toStringAsFixed(1)} kg • $activityLevel'
            : (lang == 'ar' ? 'اضغط لإكمال بياناتك' : 'Tap to complete your details'),
        onTap: showProfile,
      ),
      const SizedBox(height: 25),
      infoCard(Icons.fitness_center, tr('plan'), tr('push'), onTap: () => setState(() => page = 2)),
      const SizedBox(height: 12),
      infoCard(Icons.healing, tr('focus'), tr('shoulder'), onTap: () => setState(() => page = 3)),
      const SizedBox(height: 22),
      FilledButton.icon(
        onPressed: () => setState(() => page = 1),
        icon: const Icon(Icons.monitor_heart),
        label: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            tr('start'),
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
      const SizedBox(height: 25),
      Text(
        tr('notice'),
        style: const TextStyle(fontSize: 15),
      ),
    ]);
  }

  bool get hasSafetyFlag =>
      redFlagTrauma || redFlagNeuro || redFlagSystemic || redFlagBowelBladder;

  String safetyMessage() {
    if (lang == 'ar') {
      return hasSafetyFlag
          ? 'تم رصد علامة تستدعي الحذر. MOVENTRA لن يقترح برنامج تأهيل تلقائي لهذه الحالة. اطلب تقييماً طبياً مناسباً، وبشكل عاجل عند أعراض عصبية شديدة أو تغير التحكم بالمثانة/الأمعاء.'
          : 'لم يتم تحديد علامة خطر في هذه الشاشة. هذا الفحص لا يشخّص إصابة ولا يستبدل التقييم الطبي.';
    }
    if (lang == 'fr') {
      return hasSafetyFlag
          ? 'Un signal de sécurité a été identifié. MOVENTRA ne proposera pas de rééducation automatique dans ce cas. Demandez une évaluation médicale adaptée.'
          : 'Aucun signal de sécurité n’a été sélectionné ici. Ce bilan ne pose pas de diagnostic et ne remplace pas une évaluation médicale.';
    }
    if (lang == 'de') {
      return hasSafetyFlag
          ? 'Ein Sicherheitshinweis wurde erkannt. MOVENTRA erstellt dafür kein automatisches Reha-Programm. Bitte medizinisch abklären lassen.'
          : 'Hier wurde kein Sicherheitshinweis ausgewählt. Dieser Check stellt keine Diagnose und ersetzt keine medizinische Untersuchung.';
    }
    return hasSafetyFlag
        ? 'A safety flag was identified. MOVENTRA will not generate an automatic rehab plan for this presentation. Seek appropriate medical assessment.'
        : 'No safety flag was selected here. This check does not diagnose an injury or replace medical assessment.';
  }

  Widget precisePainMap() {
    String l(String en, String ar, String fr, String de) {
      if (lang == 'ar') return ar;
      if (lang == 'fr') return fr;
      if (lang == 'de') return de;
      return en;
    }

    final frontZones = <Map<String, dynamic>>[
      {'id':'neck','label':l('Neck','الرقبة','Cou','Nacken'),'top':22.0,'left':112.0,'w':56.0,'h':34.0},
      {'id':'leftShoulder','label':l('Left shoulder','الكتف الأيسر','Épaule gauche','Linke Schulter'),'top':58.0,'left':58.0,'w':58.0,'h':42.0},
      {'id':'rightShoulder','label':l('Right shoulder','الكتف الأيمن','Épaule droite','Rechte Schulter'),'top':58.0,'left':164.0,'w':58.0,'h':42.0},
      {'id':'chest','label':l('Chest','الصدر','Poitrine','Brust'),'top':90.0,'left':103.0,'w':74.0,'h':62.0},
      {'id':'abdomen','label':l('Abdomen','البطن','Abdomen','Bauch'),'top':154.0,'left':105.0,'w':70.0,'h':58.0},
      {'id':'leftElbow','label':l('Left elbow','المرفق الأيسر','Coude gauche','Linker Ellenbogen'),'top':142.0,'left':68.0,'w':38.0,'h':42.0},
      {'id':'rightElbow','label':l('Right elbow','المرفق الأيمن','Coude droit','Rechter Ellenbogen'),'top':142.0,'left':174.0,'w':38.0,'h':42.0},
      {'id':'leftWrist','label':l('Left wrist / hand','الرسغ / اليد اليسرى','Poignet / main gauche','Linkes Handgelenk / Hand'),'top':218.0,'left':61.0,'w':46.0,'h':42.0},
      {'id':'rightWrist','label':l('Right wrist / hand','الرسغ / اليد اليمنى','Poignet / main droite','Rechtes Handgelenk / Hand'),'top':218.0,'left':173.0,'w':46.0,'h':42.0},
      {'id':'leftHip','label':l('Left hip','الورك الأيسر','Hanche gauche','Linke Hüfte'),'top':204.0,'left':82.0,'w':48.0,'h':52.0},
      {'id':'rightHip','label':l('Right hip','الورك الأيمن','Hanche droite','Rechte Hüfte'),'top':204.0,'left':150.0,'w':48.0,'h':52.0},
      {'id':'leftKnee','label':l('Left knee','الركبة اليسرى','Genou gauche','Linkes Knie'),'top':318.0,'left':89.0,'w':42.0,'h':42.0},
      {'id':'rightKnee','label':l('Right knee','الركبة اليمنى','Genou droit','Rechtes Knie'),'top':318.0,'left':149.0,'w':42.0,'h':42.0},
      {'id':'leftAnkle','label':l('Left ankle / foot','الكاحل / القدم اليسرى','Cheville / pied gauche','Linker Knöchel / Fuß'),'top':420.0,'left':82.0,'w':50.0,'h':42.0},
      {'id':'rightAnkle','label':l('Right ankle / foot','الكاحل / القدم اليمنى','Cheville / pied droit','Rechter Knöchel / Fuß'),'top':420.0,'left':148.0,'w':50.0,'h':42.0},
    ];

    final backZones = <Map<String, dynamic>>[
      {'id':'backNeck','label':l('Back of neck','خلف الرقبة','Arrière du cou','Nacken hinten'),'top':22.0,'left':112.0,'w':56.0,'h':34.0},
      {'id':'leftRearShoulder','label':l('Left rear shoulder','خلف الكتف الأيسر','Épaule gauche arrière','Linke hintere Schulter'),'top':58.0,'left':58.0,'w':58.0,'h':42.0},
      {'id':'rightRearShoulder','label':l('Right rear shoulder','خلف الكتف الأيمن','Épaule droite arrière','Rechte hintere Schulter'),'top':58.0,'left':164.0,'w':58.0,'h':42.0},
      {'id':'upperBack','label':l('Upper back','أعلى الظهر','Haut du dos','Oberer Rücken'),'top':88.0,'left':103.0,'w':74.0,'h':70.0},
      {'id':'lowerBack','label':l('Lower back','أسفل الظهر','Bas du dos','Unterer Rücken'),'top':158.0,'left':105.0,'w':70.0,'h':58.0},
      {'id':'leftGlute','label':l('Left glute','الألية اليسرى','Fessier gauche','Linkes Gesäß'),'top':212.0,'left':84.0,'w':48.0,'h':52.0},
      {'id':'rightGlute','label':l('Right glute','الألية اليمنى','Fessier droit','Rechtes Gesäß'),'top':212.0,'left':148.0,'w':48.0,'h':52.0},
      {'id':'leftHamstring','label':l('Left hamstring','خلف الفخذ الأيسر','Ischio-jambier gauche','Linke hintere Oberschenkel'),'top':260.0,'left':88.0,'w':44.0,'h':70.0},
      {'id':'rightHamstring','label':l('Right hamstring','خلف الفخذ الأيمن','Ischio-jambier droit','Rechte hintere Oberschenkel'),'top':260.0,'left':148.0,'w':44.0,'h':70.0},
      {'id':'leftCalf','label':l('Left calf','ربلة الساق اليسرى','Mollet gauche','Linke Wade'),'top':354.0,'left':88.0,'w':44.0,'h':70.0},
      {'id':'rightCalf','label':l('Right calf','ربلة الساق اليمنى','Mollet droit','Rechte Wade'),'top':354.0,'left':148.0,'w':44.0,'h':70.0},
    ];

    final zones = bodyBackView ? backZones : frontZones;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final silhouetteColor = isDark ? const Color(0xFF9CA8BA) : const Color(0xFF475569);
    final mapBackground = isDark ? const Color(0xFF0B111B) : const Color(0xFFE8EEF7);
    final mapBorder = isDark ? const Color(0xFF253044) : const Color(0xFFCBD5E1);

    void toggleZone(Map<String, dynamic> z) {
      final id = z['id'] as String;
      setState(() {
        painfulZones.contains(id) ? painfulZones.remove(id) : painfulZones.add(id);
        final low = id.toLowerCase();
        bodySide = low.startsWith('left') ? 'left' : (low.startsWith('right') ? 'right' : 'both');
        if (low.contains('shoulder')) bodyArea = 'shoulder';
        else if (low.contains('elbow')) bodyArea = 'elbow';
        else if (low.contains('wrist')) bodyArea = 'wrist';
        else if (low.contains('knee')) bodyArea = 'knee';
        else if (low.contains('hip') || low.contains('glute')) bodyArea = 'hip';
        else if (low.contains('ankle') || low.contains('calf')) bodyArea = 'ankle';
        else if (low.contains('neck')) bodyArea = 'neck';
        else if (low.contains('upperback')) bodyArea = 'upperBack';
        else if (low.contains('lowerback')) bodyArea = 'lowerBack';
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l('360° Body selector','محدد الجسم 360°','Sélecteur corporel 360°','360° Körperauswahl'),
          style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold),
          textAlign:TextAlign.center,
        ),
        const SizedBox(height:8),
        Text(
          l('Drag the control to rotate. The active anatomical side changes automatically.',
            'حرّك المؤشر لتدوير الجسم. تتغير الجهة التشريحية النشطة تلقائياً.',
            'Faites glisser pour tourner. La face anatomique active change automatiquement.',
            'Zum Drehen schieben. Die aktive Körperseite wechselt automatisch.'),
          textAlign:TextAlign.center,
        ),
        Slider(
          value:bodyRotation,
          min:0,max:360,divisions:72,
          label:'${bodyRotation.round()}°',
          onChanged:(v)=>setState((){
            bodyRotation=v;
            final normalized=v%360;
            bodyBackView=normalized>90 && normalized<270;
          }),
        ),
        Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children:[
            Text(l('Front','أمام','Avant','Vorne')),
            Text('${bodyRotation.round()}°',style:const TextStyle(fontWeight:FontWeight.bold)),
            Text(l('Back','خلف','Arrière','Hinten')),
          ],
          ),
        ),
        const SizedBox(height:14),
        Text(l('Tap every painful area','اضغط على كل منطقة تؤلمك','Touchez chaque zone douloureuse','Tippe auf jede schmerzende Stelle'),
          style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
        const SizedBox(height:6),
        Text(l('Selected areas turn red. Tap again to remove.',
          'المناطق المختارة تصبح حمراء. اضغط مرة أخرى لإلغائها.',
          'Les zones sélectionnées deviennent rouges. Touchez à nouveau pour retirer.',
          'Ausgewählte Bereiche werden rot. Erneut tippen zum Entfernen.')),
        const SizedBox(height:14),
        Container(
          padding:const EdgeInsets.symmetric(vertical:18),
          decoration:BoxDecoration(
            color:mapBackground,
            borderRadius:BorderRadius.circular(28),
            border:Border.all(color:mapBorder),
            boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:isDark?.24:.08),blurRadius:24,offset:const Offset(0,10))],
          ),
          child:Center(
            child:Transform(
            alignment:Alignment.center,
            transform:Matrix4.identity()
              ..setEntry(3,2,0.0012)
              ..rotateY(bodyRotation * 3.141592653589793 / 180),
            child:SizedBox(
              width:280,height:480,
              child:Stack(children:[
              Positioned(left:110,top:0,child:Container(width:60,height:60,
                decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:silhouetteColor,width:2)))),
              Positioned(left:100,top:55,child:Container(width:80,height:180,
                decoration:BoxDecoration(border:Border.all(color:silhouetteColor,width:2),borderRadius:BorderRadius.circular(38)))),
              Positioned(left:72,top:62,child:Container(width:28,height:190,
                decoration:BoxDecoration(border:Border.all(color:silhouetteColor,width:2),borderRadius:BorderRadius.circular(16)))),
              Positioned(left:180,top:62,child:Container(width:28,height:190,
                decoration:BoxDecoration(border:Border.all(color:silhouetteColor,width:2),borderRadius:BorderRadius.circular(16)))),
              Positioned(left:103,top:230,child:Container(width:32,height:225,
                decoration:BoxDecoration(border:Border.all(color:silhouetteColor,width:2),borderRadius:BorderRadius.circular(18)))),
              Positioned(left:145,top:230,child:Container(width:32,height:225,
                decoration:BoxDecoration(border:Border.all(color:silhouetteColor,width:2),borderRadius:BorderRadius.circular(18)))),
              ...zones.map((z){
                final selected=painfulZones.contains(z['id']);
                return Positioned(
                  top:z['top'],left:z['left'],width:z['w'],height:z['h'],
                  child:Semantics(
                    button:true,label:z['label'],
                    child:InkWell(
                      borderRadius:BorderRadius.circular(18),
                      onTap:()=>toggleZone(z),
                      child:AnimatedContainer(
                        duration:const Duration(milliseconds:180),
                        decoration:BoxDecoration(
                          color:selected?const Color(0xFFFF334F).withValues(alpha:0.78):Colors.transparent,
                          border:Border.all(color:selected?const Color(0xFFFF6B7F):Colors.transparent,width:2),
                          borderRadius:BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              ]),
            ),
          ),
        ),
        if(painfulZones.isNotEmpty) ...[
          Text('${l('Selected','المحدد','Sélection','Ausgewählt')}: ${painfulZones.length}',
            textAlign:TextAlign.center,style:const TextStyle(fontWeight:FontWeight.bold)),
          TextButton.icon(
            onPressed:()=>setState(()=>painfulZones.clear()),
            icon:const Icon(Icons.restart_alt),
            label:Text(l('Clear body map','مسح تحديد الجسم','Effacer la sélection','Körperauswahl löschen')),
          ),
        ],
      ],
    );
  }


  Widget body3DViewer() {
    String l(String en, String ar, String fr, String de) {
      if (lang == 'ar') return ar;
      if (lang == 'fr') return fr;
      if (lang == 'de') return de;
      return en;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: .18),
                Theme.of(context).colorScheme.secondary.withValues(alpha: .07),
              ],
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: .22),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.view_in_ar),
                const SizedBox(width: 10),
                Expanded(child: Text(
                  l('3D Body + Pain Map','3D + خريطة الألم','Corps 3D + carte douleur','3D-Körper + Schmerzkarte'),
                  style: const TextStyle(fontSize:21,fontWeight:FontWeight.w800),
                )),
              ]),
              const SizedBox(height:8),
              Text(l(
                'Rotate and zoom the 3D body, then tap every painful area on the anatomical map below.',
                'دوّر وكبّر الجسم 3D، ثم اضغط على كل منطقة مؤلمة في الخريطة التشريحية أسفله.',
                'Tournez et zoomez le corps 3D, puis touchez chaque zone douloureuse sur la carte ci-dessous.',
                '3D-Körper drehen/zoomen und danach jede schmerzende Stelle auf der Karte darunter antippen.',
              )),
            ],
          ),
        ),
        const SizedBox(height:14),
        SizedBox(
          height: 440,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: const ModelViewer(
              src: 'assets/models/human.glb',
              alt: 'MOVENTRA 3D human body',
              ar: false,
              autoRotate: false,
              cameraControls: true,
              disableZoom: false,
              backgroundColor: Color(0xFF0D121C),
            ),
          ),
        ),
        const SizedBox(height:18),
        precisePainMap(),
      ],
    );
  }

  Widget checkPage() {
    String l(String en, String ar, String fr, String de) {
      if (lang == 'ar') return ar;
      if (lang == 'fr') return fr;
      if (lang == 'de') return de;
      return en;
    }

    final areas = <String, String>{
      'shoulder': l('Shoulder','الكتف','Épaule','Schulter'),
      'neck': l('Neck','الرقبة','Cou','Nacken'),
      'upperBack': l('Upper back','أعلى الظهر','Haut du dos','Oberer Rücken'),
      'lowerBack': l('Lower back','أسفل الظهر','Bas du dos','Unterer Rücken'),
      'elbow': l('Elbow','المرفق','Coude','Ellenbogen'),
      'wrist': l('Wrist / hand','الرسغ / اليد','Poignet / main','Handgelenk / Hand'),
      'hip': l('Hip','الورك','Hanche','Hüfte'),
      'knee': l('Knee','الركبة','Genou','Knie'),
      'ankle': l('Ankle / foot','الكاحل / القدم','Cheville / pied','Knöchel / Fuß'),
    };

    return pageBody([
      Text(tr('body'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      body3DViewer(),
      const SizedBox(height: 22),
      DropdownButtonFormField<String>(
        value: bodyArea,
        decoration: InputDecoration(
          labelText: l('Pain area','منطقة الألم','Zone douloureuse','Schmerzbereich'),
          border: const OutlineInputBorder(),
        ),
        items: areas.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
        onChanged: (v) => setState(() => bodyArea = v ?? bodyArea),
      ),
      const SizedBox(height: 14),
      SegmentedButton<String>(
        segments: [
          ButtonSegment(value:'right', label: Text(l('Right','يمين','Droite','Rechts'))),
          ButtonSegment(value:'left', label: Text(l('Left','يسار','Gauche','Links'))),
          ButtonSegment(value:'both', label: Text(l('Both','الجهتان','Les deux','Beide'))),
        ],
        selected: {bodySide},
        onSelectionChanged: (v) => setState(() => bodySide = v.first),
      ),
      const SizedBox(height:18),
      DropdownButtonFormField<String>(
        value:symptomDuration,
        decoration:InputDecoration(
          labelText:l('How long?','منذ متى؟','Depuis combien de temps ?','Seit wann?'),
          border:const OutlineInputBorder(),
        ),
        items:[
          DropdownMenuItem(value:'recent',child:Text(l('Less than 2 weeks','أقل من أسبوعين','Moins de 2 semaines','Weniger als 2 Wochen'))),
          DropdownMenuItem(value:'weeks',child:Text(l('2–6 weeks','2–6 أسابيع','2–6 semaines','2–6 Wochen'))),
          DropdownMenuItem(value:'persistent',child:Text(l('More than 6 weeks','أكثر من 6 أسابيع','Plus de 6 semaines','Mehr als 6 Wochen'))),
        ],
        onChanged:(v)=>setState(()=>symptomDuration=v??symptomDuration),
      ),
      const SizedBox(height:12),
      DropdownButtonFormField<String>(
        value:symptomPattern,
        decoration:InputDecoration(
          labelText:l('When is it most noticeable?','متى يظهر أكثر؟','Quand est-ce le plus présent ?','Wann ist es am stärksten?'),
          border:const OutlineInputBorder(),
        ),
        items:[
          DropdownMenuItem(value:'movement',child:Text(l('With movement/load','مع الحركة/الحمل','Avec mouvement/charge','Bei Bewegung/Belastung'))),
          DropdownMenuItem(value:'rest',child:Text(l('At rest','في الراحة','Au repos','In Ruhe'))),
          DropdownMenuItem(value:'both',child:Text(l('Both','كلاهما','Les deux','Beides'))),
        ],
        onChanged:(v)=>setState(()=>symptomPattern=v??symptomPattern),
      ),
      const SizedBox(height:18),
      Text(l('Safety screen','فحص الأمان','Écran de sécurité','Sicherheitscheck'),
        style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      CheckboxListTile(
        contentPadding:EdgeInsets.zero,value:redFlagTrauma,
        title:Text(l('Major recent trauma','إصابة/صدمة قوية حديثة','Traumatisme important récent','Stärkeres kürzliches Trauma')),
        onChanged:(v)=>setState(()=>redFlagTrauma=v??false),
      ),
      CheckboxListTile(
        contentPadding:EdgeInsets.zero,value:redFlagNeuro,
        title:Text(l('New or worsening marked weakness/numbness','ضعف أو خدر واضح جديد أو متفاقم','Faiblesse/engourdissement marqué nouveau ou aggravé','Neue/zunehmende deutliche Schwäche/Taubheit')),
        onChanged:(v)=>setState(()=>redFlagNeuro=v??false),
      ),
      CheckboxListTile(
        contentPadding:EdgeInsets.zero,value:redFlagSystemic,
        title:Text(l('Fever or feeling systemically unwell with the pain','حمى أو شعور عام بالمرض مع الألم','Fièvre ou malaise général avec la douleur','Fieber oder starkes Krankheitsgefühl mit Schmerzen')),
        onChanged:(v)=>setState(()=>redFlagSystemic=v??false),
      ),
      CheckboxListTile(
        contentPadding:EdgeInsets.zero,value:redFlagBowelBladder,
        title:Text(l('New bladder/bowel control change or saddle numbness','تغير جديد في التحكم بالمثانة/الأمعاء أو خدر بمنطقة العجان','Nouveau trouble vessie/intestin ou anesthésie en selle','Neue Blasen-/Darmstörung oder Taubheit im Sattelbereich')),
        onChanged:(v)=>setState(()=>redFlagBowelBladder=v??false),
      ),
      Card(
        child:Padding(
          padding:const EdgeInsets.all(14),
          child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Icon(hasSafetyFlag?Icons.warning_amber_rounded:Icons.verified_user_outlined),
            const SizedBox(width:10),
            Expanded(child:Text(safetyMessage())),
          ]),
        ),
      ),
      const SizedBox(height: 22),
      Text('${tr('pain')}: ${pain.round()} / 10',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Slider(
        value: pain, min: 0, max: 10, divisions: 10,
        label: pain.round().toString(),
        onChanged: (v) => setState(() => pain = v),
      ),
      const SizedBox(height: 12),
      infoCard(Icons.favorite, tr('ready'), '${(10 - pain * 0.7).round().clamp(1, 10)} / 10'),
      const SizedBox(height: 18),
      FilledButton.icon(
        onPressed: () async {
          setState(() => checkSaved = true);
          await _saveCheckToHistory();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l('Body Check saved','تم حفظ فحص الجسم','Bilan enregistré','Körper-Check gespeichert'))),
          );
        },
        icon: const Icon(Icons.save),
        label: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(checkSaved
            ? l('Saved','تم الحفظ','Enregistré','Gespeichert')
            : l('Save Body Check','حفظ فحص الجسم','Enregistrer le bilan','Körper-Check speichern')),
        ),
      ),
    ]);
  }

  String adaptiveTrainingText() {
    if (hasSafetyFlag) return safetyMessage();
    if (!checkSaved) return tr('exercise');
    if (pain >= 7) {
      return lang == 'ar'
          ? 'الألم مرتفع. تجنب التدريب الشديد على المنطقة المحددة وركز على الحركة الخفيفة فقط.'
          : 'Pain is high. Avoid strenuous loading of the selected area and keep activity light.';
    }
    if (pain >= 4) {
      return lang == 'ar'
          ? 'خفّض الحمل والمدى حسب الأعراض. لا تدفع خلال ألم متزايد.'
          : 'Reduce load and range according to symptoms. Do not push through increasing pain.';
    }
    return lang == 'ar'
        ? 'الأعراض منخفضة: يمكن التدريب بحمل متحكم به مع مراقبة الاستجابة.'
        : 'Symptoms are low: controlled training can continue while monitoring the response.';
  }

  String adaptiveRecoveryText() {
    if (hasSafetyFlag) return safetyMessage();
    if (!checkSaved) return tr('recText');
    if (pain >= 7) {
      return lang == 'ar'
          ? 'تعافٍ خفيف ومراقبة الأعراض. الألم الشديد أو المتفاقم يحتاج تقييمًا مختصًا.'
          : 'Use gentle recovery and monitor symptoms. Severe or worsening pain needs professional assessment.';
    }
    return lang == 'ar'
        ? 'حركة مريحة وحمل تدريجي ونوم وتعافٍ مناسب، مع إعادة تقييم الألم في الفحص القادم.'
        : 'Comfortable movement, gradual loading, sleep and recovery, then reassess pain at the next check.';
  }


  List<(String, String)> rehabExercises() {
    if (hasSafetyFlag) return [];
    final low = bodyArea.toLowerCase();

    if (low.contains('knee')) {
      return lang == 'ar'
          ? [
              ('حركة ركبة مريحة', '2–3 مجموعات بحركة ضمن مدى مريح، دون دفع الألم للارتفاع.'),
              ('تقوية عضلات الفخذ تدريجيًا', 'ابدأ بمقاومة خفيفة وزد الحمل حسب الاستجابة.'),
            ]
          : [
              ('Comfortable knee motion', '2–3 sets in a comfortable range; do not push through increasing pain.'),
              ('Progressive thigh strengthening', 'Start light and progress resistance according to response.'),
            ];
    }
    if (low.contains('shoulder')) {
      return lang == 'ar'
          ? [
              ('حركة كتف مريحة', 'حركة بطيئة ضمن المدى المتحمل، 1–2 دقيقة.'),
              ('تقوية خفيفة متدرجة', 'مقاومة خفيفة مع تحكم جيد، ثم زيادة تدريجية حسب الاستجابة.'),
            ]
          : [
              ('Comfortable shoulder motion', 'Slow movement in a tolerated range for 1–2 minutes.'),
              ('Light progressive strengthening', 'Use light resistance with control, then progress according to response.'),
            ];
    }
    if (low.contains('back') || low.contains('neck')) {
      return lang == 'ar'
          ? [
              ('حركة لطيفة ومتكررة', 'غيّر الوضعية وتحرك بانتظام ضمن المدى المريح.'),
              ('عودة تدريجية للنشاط', 'زد النشاط تدريجيًا بدل الراحة الطويلة إذا لم توجد علامة أمان.'),
            ]
          : [
              ('Gentle repeated movement', 'Change position and move regularly within a comfortable range.'),
              ('Gradual return to activity', 'Build activity progressively rather than prolonged rest when no safety flag is present.'),
            ];
    }
    return lang == 'ar'
        ? [
            ('حركة مريحة', 'حافظ على الحركة ضمن مدى متحمل وراقب الاستجابة.'),
            ('تحميل تدريجي', 'ابدأ خفيفًا وزد الحجم أو المقاومة تدريجيًا إذا بقيت الأعراض مستقرة.'),
          ]
        : [
            ('Comfortable movement', 'Keep moving in a tolerated range and monitor the response.'),
            ('Gradual loading', 'Start light and increase volume or resistance progressively if symptoms remain stable.'),
          ];
  }

  Widget mediaPlaceholder(String title, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children:[
          Icon(icon,size:34),
          const SizedBox(width:14),
          Expanded(child:Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children:[
              Text(title,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:17)),
              const SizedBox(height:4),
              Text(lang=='ar'
                ? 'مكان جاهز لإضافة صورة أو فيديو التمرين بعد اعتماد المحتوى.'
                : 'Ready for an approved exercise image or video in the media library.'),
            ],
          )),
        ]),
      ),
    );
  }

  Widget exerciseVisualCard(String asset, String title, String subtitle) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(asset, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF0B1018),
              alignment: Alignment.center,
              child: const Icon(Icons.fitness_center, size: 54),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(subtitle),
          ]),
        ),
      ]),
    );
  }

  Widget gluteBridgeSequence() {
    final steps = [
      ('assets/exercises/glute_start.png', lang=='ar'?'1 • البداية':'1 • Start'),
      ('assets/exercises/glute_movement.png', lang=='ar'?'2 • أثناء الحركة':'2 • Movement'),
      ('assets/exercises/glute_finish.png', lang=='ar'?'3 • النهاية':'3 • Finish'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(lang=='ar'?'خطوات التمرين 3D':'3D exercise steps',
          style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900)),
        const SizedBox(height:10),
        ...steps.map((e)=>Padding(
          padding:const EdgeInsets.only(bottom:10),
          child:exerciseVisualCard(e.$1,e.$2,
            lang=='ar'?'اتبع الوضعية المعروضة وتحرك ببطء وتحكم.':'Match the shown position and move slowly with control.'),
        )),
      ],
    );
  }

  Widget exerciseLibraryPreview() {
    final items = [
      ('assets/exercises/squat_3d.png','Squat','3 × 12'),
      ('assets/exercises/glute_bridge_3d.png','Glute Bridge','3 × 15'),
      ('assets/exercises/knee_extension_3d.png','Knee Extension','3 × 12'),
      ('assets/exercises/calf_raise_3d.png','Calf Raise','3 × 15'),
    ];
    return Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      Text(lang=='ar'?'مكتبة التمارين العلاجية':'Exercise library',
        style:const TextStyle(fontSize:20,fontWeight:FontWeight.w900)),
      const SizedBox(height:10),
      GridView.builder(
        shrinkWrap:true,
        physics:const NeverScrollableScrollPhysics(),
        itemCount:items.length,
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.78),
        itemBuilder:(context,i){ final e=items[i]; return exerciseVisualCard(e.$1,e.$2,e.$3); },
      ),
    ]);
  }

  Widget workoutPage() {
    return pageBody([
      Text(tr('session'),style:const TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
      const SizedBox(height:20),
      infoCard(
        Icons.fitness_center,
        tr('push'),
        checkSaved ? adaptiveTrainingText() : tr('exercise'),
      ),
      const SizedBox(height:12),
      if(profileSaved)
        infoCard(Icons.person,tr('ready'),'$activityLevel • $trainingDays days/week • $goal'),
      if(checkSaved) ...[
        const SizedBox(height:12),
        infoCard(Icons.accessibility_new,tr('check'),
          '$bodyArea/$bodySide • ${pain.round()}/10 • ${painfulZones.length} zone(s)'),
      ],
      const SizedBox(height:18),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children:[
                const Icon(Icons.videocam_outlined,size:30),
                const SizedBox(width:12),
                Expanded(child:Text(
                  lang=='ar'?'MOVENTRA Motion Coach':'MOVENTRA Motion Coach',
                  style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800),
                )),
              ]),
              const SizedBox(height:8),
              Text(lang=='ar'
                ? 'الكاميرا تحلل وضعية الجسم، ترسم الهيكل، وتحسب زاوية الركبة وعدد تكرارات السكوات على الجهاز.'
                : 'Use the camera for on-device pose tracking, skeleton overlay, knee-angle analysis and squat rep counting.'),
              const SizedBox(height:12),
              FilledButton.icon(
                onPressed:hasSafetyFlag ? null : ()=>Navigator.of(context).push(
                  MaterialPageRoute(builder:(_)=>const MotionCoachPage())),
                icon:const Icon(Icons.camera_alt_outlined),
                label:Text(lang=='ar'?'فتح الكاميرا وتحليل الحركة':'Open camera & analyze movement'),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height:18),
      exerciseLibraryPreview(),
      const SizedBox(height:18),
      gluteBridgeSequence(),
      const SizedBox(height:18),
      FilledButton.icon(
        onPressed:hasSafetyFlag ? null : ()=>setState(()=>trainingDone=!trainingDone),
        icon:Icon(trainingDone?Icons.check_circle:Icons.circle_outlined),
        label:Padding(
          padding:const EdgeInsets.all(14),
          child:Text(trainingDone
            ? (lang=='ar'?'تم تسجيل التدريب':'Training completed')
            : (lang=='ar'?'تسجيل التدريب كمكتمل':'Mark training complete')),
        ),
      ),
    ]);
  }

  Widget recoveryPage() {
    return pageBody([
      Text(tr('recTitle'),style:const TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
      const SizedBox(height:20),
      infoCard(Icons.healing,tr('focus'),adaptiveRecoveryText()),
      if(checkSaved) ...[
        const SizedBox(height:12),
        infoCard(Icons.monitor_heart,tr('pain'),
          '$bodyArea/$bodySide • ${pain.round()}/10 • ${painfulZones.length} zone(s)'),
      ],
      const SizedBox(height:18),
      Text(
        lang == 'ar' ? 'خطة MOVENTRA المقترحة' : 'MOVENTRA suggested plan',
        style: const TextStyle(fontSize:20,fontWeight:FontWeight.w800),
      ),
      const SizedBox(height:10),
      ...rehabExercises().map((e) => Padding(
        padding: const EdgeInsets.only(bottom:10),
        child: infoCard(Icons.play_circle_outline, e.$1, e.$2),
      )),
      const SizedBox(height:8),
      exerciseVisualCard(
        'assets/exercises/glute_bridge_3d.png',
        lang=='ar'?'Glute Bridge • دليل 3D':'Glute Bridge • 3D guide',
        lang=='ar'?'3 مجموعات × 15 تكرار — ضمن المدى المريح فقط.':'3 sets × 15 reps — stay within a comfortable range.',
      ),
      const SizedBox(height:12),
      gluteBridgeSequence(),
      const SizedBox(height:18),
      FilledButton.icon(
        onPressed:hasSafetyFlag ? null : ()=>setState(()=>recoveryDone=!recoveryDone),
        icon:Icon(recoveryDone?Icons.check_circle:Icons.circle_outlined),
        label:Padding(
          padding:const EdgeInsets.all(14),
          child:Text(recoveryDone
            ? (lang=='ar'?'تم تسجيل التعافي':'Recovery completed')
            : (lang=='ar'?'تسجيل التعافي كمكتمل':'Mark recovery complete')),
        ),
      ),
    ]);
  }

  Widget progressPage() {
    return pageBody([
      Text(
        tr('progTitle'),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      infoCard(Icons.insights, tr('progTitle'), tr('progText')),
      const SizedBox(height: 12),
      if (profileSaved)
        infoCard(Icons.person, 'Profile', '$age • ${heightCm.round()} cm • ${weightKg.toStringAsFixed(1)} kg • $activityLevel'),
      const SizedBox(height: 12),
      if (checkSaved)
        infoCard(
          Icons.monitor_heart,
          tr('check'),
          '$bodyArea/$bodySide • ${pain.round()}/10 • ${painfulZones.length} selected zone(s)',
        ),
      const SizedBox(height:12),
      infoCard(
        Icons.task_alt,
        lang=='ar'?'إنجاز اليوم':'Today completion',
        '${trainingDone ? '✓' : '○'} Training   ${recoveryDone ? '✓' : '○'} Recovery',
      ),
      const SizedBox(height:12),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lang=='ar'?'مؤشر الألم الحالي':'Current pain trend',
                style: const TextStyle(fontSize:18,fontWeight:FontWeight.w800)),
              const SizedBox(height:12),
              LinearProgressIndicator(
                minHeight: 10,
                borderRadius: BorderRadius.circular(20),
                value: (pain / 10).clamp(0, 1),
                color: pain >= 7 ? const Color(0xFFFF5C6C)
                    : pain >= 4 ? const Color(0xFFFFB547)
                    : const Color(0xFF39D98A),
              ),
              const SizedBox(height:8),
              Text('${pain.round()}/10 • ${painfulZones.length} ${lang=='ar'?'منطقة محددة':'selected zone(s)'}'),
            ],
          ),
        ),
      ),
      const SizedBox(height:18),
      Row(children:[
        Expanded(child:Text(
          lang=='ar'?'سجل الفحوصات':'Body Check history',
          style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800),
        )),
        if(checkHistory.isNotEmpty)
          TextButton(
            onPressed:() async {
              final prefs=await SharedPreferences.getInstance();
              await prefs.remove('moventra_check_history');
              if(mounted) setState(()=>checkHistory.clear());
            },
            child:Text(lang=='ar'?'مسح':'Clear'),
          ),
      ]),
      const SizedBox(height:8),
      if(checkHistory.isEmpty)
        infoCard(Icons.history,lang=='ar'?'لا يوجد سجل بعد':'No history yet',
          lang=='ar'?'احفظ Body Check ليظهر هنا بالتاريخ والوقت.':'Save a Body Check to add a dated entry here.')
      else
        ...checkHistory.take(8).map((raw){
          final p=raw.split('|');
          final safety=p.length>3 && p[3]=='SAFETY';
          return Padding(
            padding:const EdgeInsets.only(bottom:10),
            child:Card(child:ListTile(
              leading:CircleAvatar(child:Icon(safety?Icons.warning_amber:Icons.history)),
              title:Text(p.isNotEmpty?p[0]:''),
              subtitle:Text(p.length>2?'${p[1]} • Pain ${p[2]}/10':''),
              trailing:Icon(safety?Icons.health_and_safety:Icons.check_circle_outline),
            )),
          );
        }),
      const SizedBox(height:12),
      infoCard(
        Icons.science_outlined,
        lang=='ar'?'منهج MOVENTRA':'MOVENTRA approach',
        lang=='ar'
          ? 'تحديد الأعراض ومراقبة التقدم وتوجيه النشاط — وليس تشخيصاً طبياً.'
          : 'Symptom mapping, progress monitoring and activity guidance — not medical diagnosis.',
      ),
    ]);
  }
}
