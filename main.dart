import 'package:flutter/material.dart';

void main() => runApp(const MoventraApp());

class MoventraApp extends StatelessWidget {
  const MoventraApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
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

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int page = 0, pain = 3;
  @override Widget build(BuildContext context) {
    final pages = [
      Home(next: () => setState(() => page = 1)),
      Check(pain: pain, changed: (v) => setState(() => pain=v), next: () => setState(() => page=2)),
      Workout(pain: pain),
      const Recovery(),
      const Progress(),
    ];
    return Scaffold(
      body: SafeArea(child: pages[page]),
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
