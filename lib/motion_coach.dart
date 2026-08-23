import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class MotionCoachPage extends StatefulWidget {
  const MotionCoachPage({super.key, this.exerciseName = 'Squat'});
  final String exerciseName;

  @override
  State<MotionCoachPage> createState() => _MotionCoachPageState();
}

class _MotionCoachPageState extends State<MotionCoachPage> {
  CameraController? _camera;
  late final PoseDetector _detector;
  List<CameraDescription> _cameras = const [];
  Pose? _pose;
  bool _busy = false;
  int _reps = 0;
  bool _phase = false;
  String _exercise = 'Squat';
  String _feedback = 'Keep your full body visible';
  Map<String, double> _angles = const {};
  Map<String, _AngleState> _states = const {};

  static const _exercises = <String>[
    'Squat', 'Glute Bridge', 'Knee Extension', 'Calf Raise',
    'Shoulder Raise', 'Biceps Curl', 'Lunge', 'Push Up',
    'Overhead Press', 'Hip Hinge', 'Plank',
  ];

  @override
  void initState() {
    super.initState();
    _exercise = _exercises.contains(widget.exerciseName) ? widget.exerciseName : 'Squat';
    _detector = PoseDetector(options: PoseDetectorOptions(mode: PoseDetectionMode.stream));
    _start(preferFront: true);
  }

  Future<void> _start({required bool preferFront}) async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) setState(() => _feedback = 'No camera available');
        return;
      }
      final wanted = preferFront ? CameraLensDirection.front : CameraLensDirection.back;
      final matches = _cameras.where((c) => c.lensDirection == wanted);
      final selected = matches.isNotEmpty ? matches.first : _cameras.first;
      await _openCamera(selected);
    } catch (_) {
      if (mounted) setState(() => _feedback = 'Camera permission is required');
    }
  }

  Future<void> _openCamera(CameraDescription selected) async {
    final old = _camera;
    if (old != null) {
      try { await old.stopImageStream(); } catch (_) {}
      await old.dispose();
    }
    final controller = CameraController(
      selected,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    await controller.initialize();
    if (!mounted) { await controller.dispose(); return; }
    setState(() { _camera = controller; _pose = null; _angles = const {}; _states = const {}; });
    await controller.startImageStream(_process);
  }

  Future<void> _switchCamera() async {
    final current = _camera?.description;
    if (current == null || _cameras.length < 2) return;
    final wanted = current.lensDirection == CameraLensDirection.front
        ? CameraLensDirection.back : CameraLensDirection.front;
    final matches = _cameras.where((c) => c.lensDirection == wanted);
    if (matches.isNotEmpty) await _openCamera(matches.first);
  }

  InputImage? _input(CameraImage image) {
    final c = _camera;
    if (c == null) return null;
    final rotation = InputImageRotationValue.fromRawValue(c.description.sensorOrientation);
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (rotation == null || format == null || image.planes.length != 1) return null;
    return InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  double? _angle(Pose pose, PoseLandmarkType a, PoseLandmarkType b, PoseLandmarkType c) {
    final p1 = pose.landmarks[a], p2 = pose.landmarks[b], p3 = pose.landmarks[c];
    if (p1 == null || p2 == null || p3 == null || p1.likelihood < .5 || p2.likelihood < .5 || p3.likelihood < .5) return null;
    final v1x = p1.x-p2.x, v1y = p1.y-p2.y, v2x = p3.x-p2.x, v2y = p3.y-p2.y;
    final m1 = math.sqrt(v1x*v1x+v1y*v1y), m2 = math.sqrt(v2x*v2x+v2y*v2y);
    if (m1 == 0 || m2 == 0) return null;
    return math.acos(((v1x*v2x+v1y*v2y)/(m1*m2)).clamp(-1.0,1.0))*180/math.pi;
  }

  double? _best(Pose p, List<(PoseLandmarkType,PoseLandmarkType,PoseLandmarkType)> sides) {
    for (final s in sides) { final v = _angle(p,s.$1,s.$2,s.$3); if (v != null) return v; }
    return null;
  }

  _AngleState _range(double v, double goodMin, double goodMax, {double tolerance = 15}) {
    if (v >= goodMin && v <= goodMax) return _AngleState.good;
    if (v >= goodMin-tolerance && v <= goodMax+tolerance) return _AngleState.warning;
    return _AngleState.bad;
  }

  void _analyze(Pose p) {
    final knee = _best(p, const [
      (PoseLandmarkType.leftHip,PoseLandmarkType.leftKnee,PoseLandmarkType.leftAnkle),
      (PoseLandmarkType.rightHip,PoseLandmarkType.rightKnee,PoseLandmarkType.rightAnkle),
    ]);
    final hip = _best(p, const [
      (PoseLandmarkType.leftShoulder,PoseLandmarkType.leftHip,PoseLandmarkType.leftKnee),
      (PoseLandmarkType.rightShoulder,PoseLandmarkType.rightHip,PoseLandmarkType.rightKnee),
    ]);
    final elbow = _best(p, const [
      (PoseLandmarkType.leftShoulder,PoseLandmarkType.leftElbow,PoseLandmarkType.leftWrist),
      (PoseLandmarkType.rightShoulder,PoseLandmarkType.rightElbow,PoseLandmarkType.rightWrist),
    ]);
    final shoulder = _best(p, const [
      (PoseLandmarkType.leftElbow,PoseLandmarkType.leftShoulder,PoseLandmarkType.leftHip),
      (PoseLandmarkType.rightElbow,PoseLandmarkType.rightShoulder,PoseLandmarkType.rightHip),
    ]);
    final ankle = _best(p, const [
      (PoseLandmarkType.leftKnee,PoseLandmarkType.leftAnkle,PoseLandmarkType.leftFootIndex),
      (PoseLandmarkType.rightKnee,PoseLandmarkType.rightAnkle,PoseLandmarkType.rightFootIndex),
    ]);

    final values = <String,double>{};
    if (knee != null) values['Knee'] = knee;
    if (hip != null) values['Hip'] = hip;
    if (elbow != null) values['Elbow'] = elbow;
    if (shoulder != null) values['Shoulder'] = shoulder;
    if (ankle != null) values['Ankle'] = ankle;
    final states = <String,_AngleState>{};
    String feedback = 'Good tracking — move with control';

    switch (_exercise) {
      case 'Squat':
        if (knee != null) states['Knee'] = _range(knee, 75, 115, tolerance: 25);
        if (hip != null) states['Hip'] = _range(hip, 55, 120, tolerance: 25);
        if (knee != null && knee < 110) { _phase = true; feedback = 'Bottom phase — keep knees controlled'; }
        if (knee != null && knee > 155 && _phase) { _reps++; _phase=false; feedback='Rep $_reps complete'; }
        break;
      case 'Glute Bridge':
        if (hip != null) states['Hip'] = _range(hip, 155, 180, tolerance: 18);
        if (knee != null) states['Knee'] = _range(knee, 70, 115, tolerance: 20);
        if (hip != null && hip > 155) _phase = true;
        if (hip != null && hip < 125 && _phase) { _reps++; _phase=false; }
        feedback = 'Lift hips without over-arching the lower back';
        break;
      case 'Knee Extension':
        if (knee != null) states['Knee'] = _range(knee, 155, 180, tolerance: 20);
        if (knee != null && knee > 155) _phase=true;
        if (knee != null && knee < 120 && _phase) { _reps++; _phase=false; }
        feedback = 'Extend smoothly; avoid snapping the knee';
        break;
      case 'Calf Raise':
        if (ankle != null) states['Ankle'] = _range(ankle, 115, 155, tolerance: 20);
        feedback = 'Rise vertically and keep ankles aligned';
        break;
      case 'Shoulder Raise':
        if (shoulder != null) states['Shoulder'] = _range(shoulder, 70, 105, tolerance: 20);
        if (elbow != null) states['Elbow'] = _range(elbow, 150, 180, tolerance: 20);
        if (shoulder != null && shoulder > 75) _phase=true;
        if (shoulder != null && shoulder < 30 && _phase) { _reps++; _phase=false; }
        feedback = 'Raise without shrugging; keep the elbow controlled';
        break;
      case 'Biceps Curl':
        if (elbow != null) states['Elbow'] = _range(elbow, 35, 75, tolerance: 25);
        if (elbow != null && elbow < 75) _phase=true;
        if (elbow != null && elbow > 145 && _phase) { _reps++; _phase=false; }
        feedback = 'Keep the upper arm stable while curling';
        break;
      case 'Lunge':
        if (knee != null) states['Knee'] = _range(knee, 75, 115, tolerance: 25);
        if (hip != null) states['Hip'] = _range(hip, 75, 135, tolerance: 25);
        if (knee != null && knee < 115) _phase=true;
        if (knee != null && knee > 155 && _phase) { _reps++; _phase=false; }
        feedback = 'Keep your front knee tracking over the foot';
        break;
      case 'Push Up':
        if (elbow != null) states['Elbow'] = _range(elbow, 70, 105, tolerance: 25);
        if (hip != null) states['Hip'] = _range(hip, 155, 180, tolerance: 15);
        if (elbow != null && elbow < 105) _phase=true;
        if (elbow != null && elbow > 155 && _phase) { _reps++; _phase=false; }
        feedback = 'Keep a straight trunk and lower with elbow control';
        break;
      case 'Overhead Press':
        if (shoulder != null) states['Shoulder'] = _range(shoulder, 145, 180, tolerance: 25);
        if (elbow != null) states['Elbow'] = _range(elbow, 155, 180, tolerance: 20);
        if (elbow != null && elbow > 155) _phase=true;
        if (elbow != null && elbow < 100 && _phase) { _reps++; _phase=false; }
        feedback = 'Press overhead without excessive trunk lean';
        break;
      case 'Hip Hinge':
        if (hip != null) states['Hip'] = _range(hip, 70, 120, tolerance: 25);
        if (knee != null) states['Knee'] = _range(knee, 135, 175, tolerance: 20);
        if (hip != null && hip < 120) _phase=true;
        if (hip != null && hip > 155 && _phase) { _reps++; _phase=false; }
        feedback = 'Hinge from the hips and keep the knees softly bent';
        break;
      case 'Plank':
        if (hip != null) states['Hip'] = _range(hip, 160, 180, tolerance: 15);
        if (shoulder != null) states['Shoulder'] = _range(shoulder, 70, 110, tolerance: 20);
        feedback = 'Keep shoulders, hips and ankles in a controlled line';
        break;
    }
    if (values.isEmpty) feedback = 'Move back until the relevant joints are visible';
    _angles = values; _states = states; _feedback = feedback;
  }

  Future<void> _process(CameraImage image) async {
    if (_busy) return;
    final input = _input(image); if (input == null) return;
    _busy = true;
    try {
      final poses = await _detector.processImage(input);
      if (!mounted) return;
      if (poses.isEmpty) {
        setState(() { _pose=null; _angles=const {}; _states=const {}; _feedback='Move back until your full body is visible'; });
      } else {
        final p=poses.first; _analyze(p); setState(() => _pose=p);
      }
    } finally { _busy=false; }
  }

  Color _stateColor(_AngleState? s) => switch(s) {
    _AngleState.good => const Color(0xFF35D07F),
    _AngleState.warning => const Color(0xFFFFB020),
    _AngleState.bad => const Color(0xFFFF4D67),
    null => Colors.white54,
  };

  @override
  void dispose() {
    final c=_camera; if(c!=null){ try { c.stopImageStream(); } catch(_){} c.dispose(); }
    _detector.close(); super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c=_camera;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MOVENTRA Motion Coach'),
        actions:[
          IconButton(iconSize:28,tooltip:'Switch camera',onPressed:_switchCamera,icon:const Icon(Icons.cameraswitch_rounded)),
          const SizedBox(width:6),
        ],
      ),
      body: c==null || !c.value.isInitialized
        ? Center(child:Column(mainAxisSize:MainAxisSize.min,children:[const CircularProgressIndicator(),const SizedBox(height:14),Text(_feedback)]))
        : SafeArea(child:Column(children:[
            Padding(
              padding:const EdgeInsets.fromLTRB(14,4,14,10),
              child:DropdownButtonFormField<String>(
                value:_exercise,
                decoration:const InputDecoration(labelText:'Exercise',prefixIcon:Icon(Icons.fitness_center)),
                items:_exercises.map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),
                onChanged:(v){ if(v!=null)setState((){_exercise=v;_reps=0;_phase=false;_angles=const{};_states=const{};}); },
              ),
            ),
            Expanded(child:Padding(
              padding:const EdgeInsets.symmetric(horizontal:12),
              child:ClipRRect(
                borderRadius:BorderRadius.circular(24),
                child:Stack(fit:StackFit.expand,children:[
                  CameraPreview(c),
                  CustomPaint(painter:_PosePainter(_pose,c.value.previewSize,_states,c.description.lensDirection==CameraLensDirection.front)),
                  Positioned(top:12,left:12,child:Container(
                    padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),
                    decoration:BoxDecoration(color:Colors.black54,borderRadius:BorderRadius.circular(16)),
                    child:Text(c.description.lensDirection==CameraLensDirection.front?'FRONT CAMERA':'BACK CAMERA',style:const TextStyle(color:Colors.white,fontWeight:FontWeight.w800)),
                  )),
                ]),
              ),
            )),
            Padding(padding:const EdgeInsets.all(14),child:Card(child:Padding(
              padding:const EdgeInsets.all(14),
              child:Column(children:[
                Wrap(alignment:WrapAlignment.center,spacing:18,runSpacing:8,children:[
                  SizedBox(width:70,child:_metric('REPS','$_reps',Theme.of(context).colorScheme.primary)),
                  ..._angles.entries.map((e)=>SizedBox(width:70,child:_metric(e.key,'${e.value.round()}°',_stateColor(_states[e.key])))),
                ]),
                const SizedBox(height:10),
                Text(_feedback,textAlign:TextAlign.center,style:const TextStyle(fontSize:16,fontWeight:FontWeight.w800)),
                const SizedBox(height:8),
                const Row(mainAxisAlignment:MainAxisAlignment.center,children:[
                  _LegendDot(Color(0xFF35D07F),'Good'),SizedBox(width:12),_LegendDot(Color(0xFFFFB020),'Adjust'),SizedBox(width:12),_LegendDot(Color(0xFFFF4D67),'Wrong'),
                ]),
                const SizedBox(height:8),
                const Text('Movement coaching only — not a medical diagnosis.',textAlign:TextAlign.center,style:TextStyle(fontSize:11)),
              ]),
            ))),
          ])),
    );
  }

  Widget _metric(String label,String value,Color color)=>Column(children:[
    Text(label.toUpperCase(),style:const TextStyle(fontSize:10,fontWeight:FontWeight.w800)),
    Text(value,style:TextStyle(fontSize:23,fontWeight:FontWeight.w900,color:color)),
  ]);
}

enum _AngleState { good, warning, bad }

class _LegendDot extends StatelessWidget {
  const _LegendDot(this.color,this.text); final Color color; final String text;
  @override Widget build(BuildContext context)=>Row(children:[Container(width:9,height:9,decoration:BoxDecoration(color:color,shape:BoxShape.circle)),const SizedBox(width:4),Text(text,style:const TextStyle(fontSize:11))]);
}

class _PosePainter extends CustomPainter {
  _PosePainter(this.pose,this.previewSize,this.states,this.mirror);
  final Pose? pose; final Size? previewSize; final Map<String,_AngleState> states; final bool mirror;
  Color colorFor(String joint)=>switch(states[joint]){_AngleState.good=>const Color(0xFF35D07F),_AngleState.warning=>const Color(0xFFFFB020),_AngleState.bad=>const Color(0xFFFF4D67),null=>const Color(0xFF35D07F)};
  @override void paint(Canvas canvas,Size size){
    final p=pose,ps=previewSize;if(p==null||ps==null)return;
    Offset? pt(PoseLandmarkType t){final l=p.landmarks[t];if(l==null||l.likelihood<.45)return null;final x=(l.x/ps.height)*size.width;return Offset(mirror?size.width-x:x,(l.y/ps.width)*size.height);}
    void line(PoseLandmarkType a,PoseLandmarkType b,String joint){final x=pt(a),y=pt(b);if(x!=null&&y!=null){canvas.drawLine(x,y,Paint()..color=colorFor(joint)..strokeWidth=5..strokeCap=StrokeCap.round);}}
    line(PoseLandmarkType.leftShoulder,PoseLandmarkType.rightShoulder,'Shoulder');
    line(PoseLandmarkType.leftShoulder,PoseLandmarkType.leftElbow,'Shoulder'); line(PoseLandmarkType.leftElbow,PoseLandmarkType.leftWrist,'Elbow');
    line(PoseLandmarkType.rightShoulder,PoseLandmarkType.rightElbow,'Shoulder'); line(PoseLandmarkType.rightElbow,PoseLandmarkType.rightWrist,'Elbow');
    line(PoseLandmarkType.leftShoulder,PoseLandmarkType.leftHip,'Hip'); line(PoseLandmarkType.rightShoulder,PoseLandmarkType.rightHip,'Hip');
    line(PoseLandmarkType.leftHip,PoseLandmarkType.rightHip,'Hip');
    line(PoseLandmarkType.leftHip,PoseLandmarkType.leftKnee,'Knee'); line(PoseLandmarkType.leftKnee,PoseLandmarkType.leftAnkle,'Knee');
    line(PoseLandmarkType.rightHip,PoseLandmarkType.rightKnee,'Knee'); line(PoseLandmarkType.rightKnee,PoseLandmarkType.rightAnkle,'Knee');
  }
  @override bool shouldRepaint(covariant _PosePainter old)=>old.pose!=pose||old.states!=states||old.mirror!=mirror;
}
