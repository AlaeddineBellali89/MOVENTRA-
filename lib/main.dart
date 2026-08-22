import 'package:flutter/material.dart';

void main() => runApp(const MoventraApp());

class MoventraApp extends StatelessWidget {
  const MoventraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MOVENTRA',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF7C5CFC),
        scaffoldBackgroundColor: const Color(0xFF0B0F17),
      ),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int page = 0;
  String lang = 'en';

  // Profile
  bool profileSaved = false;
  int age = 30;
  double heightCm = 175;
  double weightKg = 75;
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
                    FilledButton.icon(
                      onPressed: () {
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
                      },
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
      Text(
        tr('slogan'),
        style: const TextStyle(fontSize: 18),
      ),
      const SizedBox(height: 18),
      infoCard(
        Icons.person,
        lang == 'ar' ? 'الملف الشخصي' : (lang == 'fr' ? 'Profil' : (lang == 'de' ? 'Profil' : 'Profile')),
        profileSaved
            ? '$age • ${heightCm.round()} cm • ${weightKg.toStringAsFixed(1)} kg • $activityLevel'
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
        onPressed: () {
          setState(() => checkSaved = true);
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

  Widget workoutPage() {
    return pageBody([
      Text(
        tr('session'),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      infoCard(
        Icons.fitness_center,
        tr('push'),
        checkSaved
            ? '${tr('exercise')} • $bodyArea/$bodySide • ${pain.round()}/10'
            : tr('exercise'),
      ),
      const SizedBox(height: 12),
      if (profileSaved)
        infoCard(Icons.person, tr('ready'), '$activityLevel • $trainingDays days/week • $goal'),
    ]);
  }

  Widget recoveryPage() {
    return pageBody([
      Text(
        tr('recTitle'),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      infoCard(
        Icons.healing,
        tr('focus'),
        checkSaved
            ? '${tr('recText')} • $bodyArea/$bodySide • ${pain.round()}/10'
            : tr('recText'),
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
        infoCard(Icons.monitor_heart, tr('check'), '$bodyArea/$bodySide • ${pain.round()}/10'),
    ]);
  }
}
