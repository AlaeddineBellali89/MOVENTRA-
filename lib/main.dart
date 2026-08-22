import 'package:flutter/material.dart';

void main() => runApp(const MoventraApp());

class MoventraApp extends StatelessWidget {
  const MoventraApp({super.key});

  void showProfile() {
    final labels = <String, Map<String, String>>{
      'en': {
        'title':'Profile','age':'Age','height':'Height (cm)','weight':'Weight (kg)',
        'sex':'Sex (optional)','male':'Male','female':'Female','preferNot':'Prefer not to say',
        'activity':'Activity level','sedentary':'Sedentary','light':'Lightly active','active':'Active','athlete':'Athlete',
        'sport':'Main activity / sport','fitness':'Fitness / gym','running':'Running','football':'Football',
        'cycling':'Cycling','swimming':'Swimming','other':'Other','days':'Training days / week',
        'experience':'Experience','beginner':'Beginner','intermediate':'Intermediate','advanced':'Advanced',
        'goal':'Main goal','general':'General fitness','strength':'Strength','muscle':'Build muscle',
        'endurance':'Endurance','return':'Return to training','save':'Save profile','saved':'Profile saved',
        'bmi':'BMI',
      },
      'ar': {
        'title':'الملف الشخصي','age':'العمر','height':'الطول (سم)','weight':'الوزن (كغ)',
        'sex':'الجنس (اختياري)','male':'ذكر','female':'أنثى','preferNot':'أفضل عدم الإجابة',
        'activity':'مستوى النشاط','sedentary':'قليل الحركة','light':'نشاط خفيف','active':'نشيط','athlete':'رياضي',
        'sport':'النشاط / الرياضة الأساسية','fitness':'اللياقة / الجيم','running':'الجري','football':'كرة القدم',
        'cycling':'الدراجات','swimming':'السباحة','other':'أخرى','days':'أيام التدريب أسبوعيًا',
        'experience':'الخبرة','beginner':'مبتدئ','intermediate':'متوسط','advanced':'متقدم',
        'goal':'الهدف الرئيسي','general':'لياقة عامة','strength':'القوة','muscle':'بناء العضلات',
        'endurance':'التحمل','return':'العودة إلى التدريب','save':'حفظ الملف الشخصي','saved':'تم حفظ الملف الشخصي',
        'bmi':'مؤشر كتلة الجسم',
      },
      'fr': {
        'title':'Profil','age':'Âge','height':'Taille (cm)','weight':'Poids (kg)',
        'sex':'Sexe (facultatif)','male':'Homme','female':'Femme','preferNot':'Je préfère ne pas répondre',
        'activity':"Niveau d'activité",'sedentary':'Sédentaire','light':'Légèrement actif','active':'Actif','athlete':'Sportif',
        'sport':'Activité / sport principal','fitness':'Fitness / salle','running':'Course','football':'Football',
        'cycling':'Cyclisme','swimming':'Natation','other':'Autre','days':"Jours d'entraînement / semaine",
        'experience':'Expérience','beginner':'Débutant','intermediate':'Intermédiaire','advanced':'Avancé',
        'goal':'Objectif principal','general':'Forme générale','strength':'Force','muscle':'Prise de muscle',
        'endurance':'Endurance','return':"Retour à l'entraînement",'save':'Enregistrer le profil','saved':'Profil enregistré',
        'bmi':'IMC',
      },
      'de': {
        'title':'Profil','age':'Alter','height':'Größe (cm)','weight':'Gewicht (kg)',
        'sex':'Geschlecht (optional)','male':'Männlich','female':'Weiblich','preferNot':'Keine Angabe',
        'activity':'Aktivitätsniveau','sedentary':'Überwiegend sitzend','light':'Leicht aktiv','active':'Aktiv','athlete':'Sportlich',
        'sport':'Hauptaktivität / Sport','fitness':'Fitness / Gym','running':'Laufen','football':'Fußball',
        'cycling':'Radfahren','swimming':'Schwimmen','other':'Andere','days':'Trainingstage / Woche',
        'experience':'Erfahrung','beginner':'Anfänger','intermediate':'Mittelstufe','advanced':'Fortgeschritten',
        'goal':'Hauptziel','general':'Allgemeine Fitness','strength':'Kraft','muscle':'Muskelaufbau',
        'endurance':'Ausdauer','return':'Zurück zum Training','save':'Profil speichern','saved':'Profil gespeichert',
        'bmi':'BMI',
      },
    };
    String p(String key) => labels[lang]?[key] ?? labels['en']![key]!;
    final ageController = TextEditingController(text: age.toString());
    final heightController = TextEditingController(text: heightCm.round().toString());
    final weightController = TextEditingController(text: weightKg.toStringAsFixed(1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final bmi = weightKg / ((heightCm / 100) * (heightCm / 100));
          return Directionality(
            textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20, 20, 20,
                  MediaQuery.of(sheetContext).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(children: [
                        const Icon(Icons.person, size: 28),
                        const SizedBox(width: 10),
                        Expanded(child: Text(p('title'),
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
                        IconButton(onPressed: () => Navigator.pop(sheetContext), icon: const Icon(Icons.close)),
                      ]),
                      const SizedBox(height: 18),
                      TextField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: p('age'), border: const OutlineInputBorder()),
                        onChanged: (v) {
                          final n = int.tryParse(v);
                          if (n != null && n > 0 && n < 120) age = n;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: p('height'), border: const OutlineInputBorder()),
                        onChanged: (v) {
                          final n = double.tryParse(v.replaceAll(',', '.'));
                          if (n != null && n > 80 && n < 250) setSheetState(() => heightCm = n);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(labelText: p('weight'), border: const OutlineInputBorder()),
                        onChanged: (v) {
                          final n = double.tryParse(v.replaceAll(',', '.'));
                          if (n != null && n > 20 && n < 350) setSheetState(() => weightKg = n);
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('${p('bmi')}: ${bmi.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: sex,
                        decoration: InputDecoration(labelText: p('sex'), border: const OutlineInputBorder()),
                        items: ['male','female','preferNot']
                          .map((v) => DropdownMenuItem(value: v, child: Text(p(v)))).toList(),
                        onChanged: (v) => setSheetState(() => sex = v ?? sex),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: activityLevel,
                        decoration: InputDecoration(labelText: p('activity'), border: const OutlineInputBorder()),
                        items: ['sedentary','light','active','athlete']
                          .map((v) => DropdownMenuItem(value: v, child: Text(p(v)))).toList(),
                        onChanged: (v) => setSheetState(() => activityLevel = v ?? activityLevel),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: sportType,
                        decoration: InputDecoration(labelText: p('sport'), border: const OutlineInputBorder()),
                        items: ['fitness','running','football','cycling','swimming','other']
                          .map((v) => DropdownMenuItem(value: v, child: Text(p(v)))).toList(),
                        onChanged: (v) => setSheetState(() => sportType = v ?? sportType),
                      ),
                      const SizedBox(height: 12),
                      Text('${p('days')}: $trainingDays',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      Slider(
                        value: trainingDays.toDouble(),
                        min: 0, max: 7, divisions: 7,
                        label: trainingDays.toString(),
                        onChanged: (v) => setSheetState(() => trainingDays = v.round()),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: experience,
                        decoration: InputDecoration(labelText: p('experience'), border: const OutlineInputBorder()),
                        items: ['beginner','intermediate','advanced']
                          .map((v) => DropdownMenuItem(value: v, child: Text(p(v)))).toList(),
                        onChanged: (v) => setSheetState(() => experience = v ?? experience),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: goal,
                        decoration: InputDecoration(labelText: p('goal'), border: const OutlineInputBorder()),
                        items: ['general','strength','muscle','endurance','return']
                          .map((v) => DropdownMenuItem(value: v, child: Text(p(v)))).toList(),
                        onChanged: (v) => setSheetState(() => goal = v ?? goal),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: () {
                          final parsedAge = int.tryParse(ageController.text);
                          final parsedHeight = double.tryParse(heightController.text.replaceAll(',', '.'));
                          final parsedWeight = double.tryParse(weightController.text.replaceAll(',', '.'));
                          setState(() {
                            if (parsedAge != null && parsedAge > 0 && parsedAge < 120) age = parsedAge;
                            if (parsedHeight != null && parsedHeight > 80 && parsedHeight < 250) heightCm = parsedHeight;
                            if (parsedWeight != null && parsedWeight > 20 && parsedWeight < 350) weightKg = parsedWeight;
                            profileSaved = true;
                          });
                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(p('saved'))));
                        },
                        icon: const Icon(Icons.save),
                        label: Padding(padding: const EdgeInsets.all(15), child: Text(p('save'))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

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
  double pain = 3;
  bool workoutDone = false;
  bool recoveryDone = false;
  String bodyArea = 'shoulder';
  String bodySide = 'right';
  String symptomDuration = 'days';
  String symptomOnset = 'gradual';
  bool recentTrauma = false;
  bool numbnessWeakness = false;
  bool feverUnwell = false;
  bool checkSaved = false;

  // Profile
  bool profileSaved = false;
  int age = 30;
  double heightCm = 175;
  double weightKg = 75;
  String sex = 'preferNot';
  String activityLevel = 'active';
  String sportType = 'fitness';
  int trainingDays = 3;
  String experience = 'intermediate';
  String goal = 'general';

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
    final labels = <String, Map<String, String>>{
      'en': {
        'area':'Pain area','side':'Side','duration':'Duration','onset':'How did it start?',
        'shoulder':'Shoulder','neck':'Neck','upperBack':'Upper back','lowerBack':'Lower back',
        'elbow':'Elbow','wrist':'Wrist / hand','hip':'Hip','knee':'Knee','ankle':'Ankle / foot',
        'right':'Right','left':'Left','center':'Center / both',
        'today':'Today','days':'A few days','weeks':'A few weeks','months':'Months or longer',
        'gradual':'Gradually','training':'During / after training','sudden':'Suddenly',
        'safety':'Safety check','trauma':'Recent fall, collision or significant injury',
        'neuro':'New numbness, marked weakness or loss of control',
        'systemic':'Fever or feeling seriously unwell',
        'save':'Save Body Check','saved':'Body Check saved',
        'warning':'Your answers include a warning sign. Pause strenuous training and seek qualified medical assessment.',
        'normal':'Check saved. MOVENTRA can now adapt the training and recovery screens.',
      },
      'ar': {
        'area':'منطقة الألم','side':'الجهة','duration':'مدة الأعراض','onset':'كيف بدأ الألم؟',
        'shoulder':'الكتف','neck':'الرقبة','upperBack':'أعلى الظهر','lowerBack':'أسفل الظهر',
        'elbow':'المرفق','wrist':'الرسغ / اليد','hip':'الورك','knee':'الركبة','ankle':'الكاحل / القدم',
        'right':'اليمين','left':'اليسار','center':'الوسط / الجهتان',
        'today':'اليوم','days':'عدة أيام','weeks':'عدة أسابيع','months':'أشهر أو أكثر',
        'gradual':'تدريجيًا','training':'أثناء / بعد التمرين','sudden':'فجأة',
        'safety':'فحص الأمان','trauma':'سقوط أو اصطدام أو إصابة قوية مؤخرًا',
        'neuro':'خدر جديد أو ضعف واضح أو فقدان التحكم',
        'systemic':'حمّى أو شعور بمرض شديد',
        'save':'حفظ فحص الجسم','saved':'تم حفظ فحص الجسم',
        'warning':'إجاباتك تتضمن علامة تستدعي الانتباه. أوقف التدريب الشديد واطلب تقييمًا طبيًا مختصًا.',
        'normal':'تم حفظ الفحص. يمكن لـ MOVENTRA الآن تكييف شاشات التدريب والتعافي.',
      },
      'fr': {
        'area':'Zone douloureuse','side':'Côté','duration':'Durée','onset':'Comment cela a commencé ?',
        'shoulder':'Épaule','neck':'Cou','upperBack':'Haut du dos','lowerBack':'Bas du dos',
        'elbow':'Coude','wrist':'Poignet / main','hip':'Hanche','knee':'Genou','ankle':'Cheville / pied',
        'right':'Droite','left':'Gauche','center':'Centre / les deux',
        'today':"Aujourd'hui",'days':'Quelques jours','weeks':'Quelques semaines','months':'Des mois ou plus',
        'gradual':'Progressivement','training':"Pendant / après l'entraînement",'sudden':'Soudainement',
        'safety':'Vérification de sécurité','trauma':'Chute, collision ou traumatisme important récent',
        'neuro':'Nouvel engourdissement, faiblesse marquée ou perte de contrôle',
        'systemic':'Fièvre ou sensation de maladie importante',
        'save':'Enregistrer le bilan','saved':'Bilan enregistré',
        'warning':"Vos réponses comportent un signe d'alerte. Évitez l'entraînement intense et demandez une évaluation médicale qualifiée.",
        'normal':"Bilan enregistré. MOVENTRA peut maintenant adapter l'entraînement et la récupération.",
      },
      'de': {
        'area':'Schmerzbereich','side':'Seite','duration':'Dauer','onset':'Wie hat es begonnen?',
        'shoulder':'Schulter','neck':'Nacken','upperBack':'Oberer Rücken','lowerBack':'Unterer Rücken',
        'elbow':'Ellenbogen','wrist':'Handgelenk / Hand','hip':'Hüfte','knee':'Knie','ankle':'Knöchel / Fuß',
        'right':'Rechts','left':'Links','center':'Mitte / beide Seiten',
        'today':'Heute','days':'Einige Tage','weeks':'Einige Wochen','months':'Monate oder länger',
        'gradual':'Allmählich','training':'Beim / nach dem Training','sudden':'Plötzlich',
        'safety':'Sicherheitscheck','trauma':'Kürzlicher Sturz, Zusammenstoß oder stärkere Verletzung',
        'neuro':'Neue Taubheit, deutliche Schwäche oder Kontrollverlust',
        'systemic':'Fieber oder starkes Krankheitsgefühl',
        'save':'Körper-Check speichern','saved':'Körper-Check gespeichert',
        'warning':'Deine Antworten enthalten ein Warnzeichen. Pausiere intensives Training und lass dich qualifiziert medizinisch untersuchen.',
        'normal':'Check gespeichert. MOVENTRA kann Training und Erholung jetzt anpassen.',
      },
    };

    String c(String key) => labels[lang]?[key] ?? labels['en']![key]!;
    final hasWarning = recentTrauma || numbnessWeakness || feverUnwell;

    return pageBody([
      Text(tr('body'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('${c(bodyArea)} • ${c(bodySide)}', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 22),

      DropdownButtonFormField<String>(
        initialValue: bodyArea,
        decoration: InputDecoration(labelText: c('area'), border: const OutlineInputBorder()),
        items: ['shoulder','neck','upperBack','lowerBack','elbow','wrist','hip','knee','ankle']
            .map((v) => DropdownMenuItem(value: v, child: Text(c(v)))).toList(),
        onChanged: (v) => setState(() => bodyArea = v ?? bodyArea),
      ),
      const SizedBox(height: 14),

      SegmentedButton<String>(
        segments: [
          ButtonSegment(value: 'right', label: Text(c('right'))),
          ButtonSegment(value: 'left', label: Text(c('left'))),
          ButtonSegment(value: 'center', label: Text(c('center'))),
        ],
        selected: {bodySide},
        onSelectionChanged: (v) => setState(() => bodySide = v.first),
      ),
      const SizedBox(height: 22),

      Text('${tr('pain')}: ${pain.round()} / 10',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Slider(
        value: pain,
        min: 0,
        max: 10,
        divisions: 10,
        label: pain.round().toString(),
        onChanged: (value) => setState(() => pain = value),
      ),
      const SizedBox(height: 14),

      DropdownButtonFormField<String>(
        initialValue: symptomDuration,
        decoration: InputDecoration(labelText: c('duration'), border: const OutlineInputBorder()),
        items: ['today','days','weeks','months']
            .map((v) => DropdownMenuItem(value: v, child: Text(c(v)))).toList(),
        onChanged: (v) => setState(() => symptomDuration = v ?? symptomDuration),
      ),
      const SizedBox(height: 14),

      DropdownButtonFormField<String>(
        initialValue: symptomOnset,
        decoration: InputDecoration(labelText: c('onset'), border: const OutlineInputBorder()),
        items: ['gradual','training','sudden']
            .map((v) => DropdownMenuItem(value: v, child: Text(c(v)))).toList(),
        onChanged: (v) => setState(() => symptomOnset = v ?? symptomOnset),
      ),
      const SizedBox(height: 22),

      Text(c('safety'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: recentTrauma,
        title: Text(c('trauma')),
        onChanged: (v) => setState(() => recentTrauma = v ?? false),
      ),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: numbnessWeakness,
        title: Text(c('neuro')),
        onChanged: (v) => setState(() => numbnessWeakness = v ?? false),
      ),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: feverUnwell,
        title: Text(c('systemic')),
        onChanged: (v) => setState(() => feverUnwell = v ?? false),
      ),

      if (hasWarning)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.warning_amber_rounded),
              const SizedBox(width: 12),
              Expanded(child: Text(c('warning'))),
            ]),
          ),
        ),

      const SizedBox(height: 18),
      FilledButton.icon(
        onPressed: () {
          setState(() => checkSaved = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(hasWarning ? c('warning') : c('normal'))),
          );
        },
        icon: const Icon(Icons.save),
        label: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(checkSaved ? c('saved') : c('save')),
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
      infoCard(Icons.fitness_center, tr('push'), tr('exercise')),
      const SizedBox(height: 18),
      FilledButton.icon(
        onPressed: () => setState(() => workoutDone = true),
        icon: Icon(workoutDone ? Icons.check_circle : Icons.play_arrow),
        label: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(workoutDone ? '✓ Completed' : 'Complete workout'),
        ),
      ),
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
      infoCard(Icons.healing, tr('focus'), tr('recText')),
      const SizedBox(height: 18),
      FilledButton.icon(
        onPressed: () => setState(() => recoveryDone = true),
        icon: Icon(recoveryDone ? Icons.check_circle : Icons.healing),
        label: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(recoveryDone ? '✓ Completed' : 'Complete recovery'),
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
      infoCard(Icons.trending_down, tr('pain'), '${pain.round()} / 10'),
      const SizedBox(height: 12),
      infoCard(
        Icons.accessibility_new,
        tr('check'),
        checkSaved ? '$bodyArea • $bodySide' : 'Not saved',
      ),
      const SizedBox(height: 12),
      infoCard(Icons.check_circle, tr('workout'), workoutDone ? '✓ Completed' : 'Pending'),
      const SizedBox(height: 12),
      infoCard(Icons.healing, tr('recovery'), recoveryDone ? '✓ Completed' : 'Pending'),
    ]);
  }
}
