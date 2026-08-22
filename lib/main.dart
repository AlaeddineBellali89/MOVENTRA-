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
