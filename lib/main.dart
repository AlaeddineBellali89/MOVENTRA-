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


  }
