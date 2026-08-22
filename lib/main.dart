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
          title: const Text(
            'MOVENTRA',
            style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget infoCard(IconData icon, String title, String subtitle) {
    return Card(
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
    );
  }

  Widget homePage() {
    return pageBody([
      Text(
        tr('slogan'),
        style: const TextStyle(fontSize: 18),
      ),
      const SizedBox(height: 25),
      infoCard(Icons.fitness_center, tr('plan'), tr('push')),
      const SizedBox(height: 12),
      infoCard(Icons.healing, tr('focus'), tr('shoulder')),
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
    return pageBody([
      Text(
        tr('body'),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 25),
      Text('${tr('pain')}:'),
      Slider(
        value: 3,
        min: 0,
        max: 10,
        divisions: 10,
        onChanged: (_) {},
      ),
      const SizedBox(height: 20),
      infoCard(Icons.favorite, tr('ready'), '7 / 10'),
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
    ]);
  }
}      body: SafeArea(child: pages[page]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (v)=>setState(()=>page=v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label:'Today'),
          NavigationDestination(icon: Icon(Icons.accessibility_new), label:'Check'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label:'Workout'),
          NavigationDestination(icon: Icon(Icons.healing), label:'Recovery'),
          NavigationDestination(icon: Icon(Icons.insights), label:'Progress'),
        ],
      ),
    );
  }
}

Widget pad(List<Widget> c) => SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:c),
);
Widget card(String a,String b,IconData i)=>Card(child:ListTile(
  contentPadding:const EdgeInsets.all(16), leading:CircleAvatar(child:Icon(i)),
  title:Text(a,style:const TextStyle(fontWeight:FontWeight.bold)), subtitle:Text(b)));

class Home extends StatelessWidget {
  final VoidCallback next; const Home({super.key,required this.next});
  @override Widget build(BuildContext context)=>pad([
    Text('MOVENTRA',style:Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight:FontWeight.bold)),
    const Text('Train. Recover. Return Stronger.'), const SizedBox(height:24),
    card("Today's Plan",'Push Day • Upper Body',Icons.fitness_center),
    card('Recovery focus','Right shoulder • Mobility & controlled load',Icons.healing),
    const SizedBox(height:12),
    SizedBox(width:double.infinity,child:FilledButton.icon(
      onPressed:next,icon:const Icon(Icons.monitor_heart),
      label:const Padding(padding:EdgeInsets.all(15),child:Text('Start body check-in')))),
    const SizedBox(height:20),
    const Text('Prototype only: MOVENTRA supports training decisions and symptom tracking. It does not diagnose injuries or replace qualified medical care.')
  ]);
}

class Check extends StatelessWidget {
  final int pain; final ValueChanged<int> changed; final VoidCallback next;
  const Check({super.key,required this.pain,required this.changed,required this.next});
  @override Widget build(BuildContext context)=>pad([
    Text('Body check-in',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.bold)),
    const SizedBox(height:12), const Center(child:Icon(Icons.accessibility_new,size:150)),
    const Text('Selected area: Right shoulder',style:TextStyle(fontWeight:FontWeight.bold)),
    const SizedBox(height:12), Text('Discomfort: $pain/10',style:Theme.of(context).textTheme.titleLarge),
    Slider(value:pain.toDouble(),min:0,max:10,divisions:10,onChanged:(v)=>changed(v.round())),
    const Text('Severe, sudden, worsening, or concerning symptoms should be assessed by a qualified clinician.'),
    const SizedBox(height:20),
    SizedBox(width:double.infinity,child:FilledButton(onPressed:next,child:const Padding(
      padding:EdgeInsets.all(15),child:Text("Adapt today's workout"))))
  ]);
}

class Workout extends StatelessWidget {
  final int pain; const Workout({super.key,required this.pain});
  @override Widget build(BuildContext context) {
    final modified=pain>=4;
    return pad([
      Text('Modified workout',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.bold)),
      const SizedBox(height:12),
      card('Warm-up','Band pull-apart • 3 × 15',Icons.fitness_center),
      card(modified?'Alternative':'Main lift',modified?'Neutral-grip dumbbell press • 3 × 8–12':'Bench press • 3 × 8–12',Icons.fitness_center),
      card('Cable row','3 × 10–12',Icons.fitness_center),
      card('Biceps curl','3 × 10–15',Icons.fitness_center),
      const SizedBox(height:12),
      const Text('Adaptation rules are placeholders and require clinical review before a public release.')
    ]);
  }
}

class Recovery extends StatelessWidget {
  const Recovery({super.key});
  @override Widget build(BuildContext context)=>pad([
    Text('Recovery',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.bold)),
    const SizedBox(height:12),
    card('Scapular wall slide','Mobility • 3 × 10',Icons.healing),
    card('Banded external rotation','Controlled load • 3 × 12',Icons.healing),
    card('Thoracic extension','Mobility • 2 × 10',Icons.healing),
    const Text('Example exercises only; not a personalized treatment plan.')
  ]);
}

class Progress extends StatelessWidget {
  const Progress({super.key});
  @override Widget build(BuildContext context)=>pad([
    Text('Progress',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.bold)),
    const SizedBox(height:16),
    card('Discomfort trend','6 → 3 / 10',Icons.trending_down),
    card('Workout adherence','82%',Icons.check_circle),
    card('Return-to-training goal','60%',Icons.flag),
  ]);
}
