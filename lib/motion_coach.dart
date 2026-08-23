import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum JointQuality { good, warning, bad }

class ExerciseRule {
  const ExerciseRule(this.id, this.name, this.primary, this.downBelow, this.upAbove);
  final String id, name, primary;
  final double downBelow, upAbove;
}

const exerciseRules = <ExerciseRule>[
  ExerciseRule('squat', 'Squat', 'Knee', 105, 155),
  ExerciseRule('glute_bridge', 'Glute Bridge', 'Hip', 145, 170),
  ExerciseRule('knee_extension', 'Knee Extension', 'Knee', 120, 160),
  ExerciseRule('calf_raise', 'Calf Raise', 'Ankle', 105, 125),
  ExerciseRule('shoulder_raise', 'Shoulder Raise', 'Shoulder', 75, 145),
  ExerciseRule('biceps_curl', 'Biceps Curl', 'Elbow', 70, 145),
  ExerciseRule('lunge', 'Lunge', 'Knee', 105, 155),
];

class MotionCoachPage extends StatefulWidget {
  const MotionCoachPage({super.key, this.initialExercise = 'squat'});
  final String initialExercise;

  @override
  State<MotionCoachPage> createState() => _MotionCoachPageState();
}

class _MotionCoachPageState extends State<MotionCoachPage> {
  CameraController? _camera;
  late final PoseDetector _detector;
  Pose? _pose;
  bool _busy = false;
  int _reps = 0;
  bool _phase = false;
  String _exercise = 'squat';
  String _feedback = 'Move back until your full body is visible';
  Map<String, double> _angles = const {};
  Map<String, JointQuality> _quality = const {};

  ExerciseRule get rule => exerciseRules.firstWhere((e) => e.id == _exercise);

  @override
  void initState() {
    super.initState();
    _exercise = exerciseRules.any((e) => e.id == widget.initialExercise) ? widget.initialExercise : 'squat';
    _detector = PoseDetector(options: PoseDetectorOptions(mode: PoseDetectionMode.stream));
    _start();
  }

  Future<void> _start() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _feedback = 'No camera was found on this device');
        return;
      }
      final front = cameras.where((c) => c.lensDirection == CameraLensDirection.front);
      final selected = front.isNotEmpty ? front.first : cameras.first;
      final controller = CameraController(selected, ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888);
      await controller.initialize();
      if (!mounted) { await controller.dispose(); return; }
      setState(() => _camera = controller);
      await controller.startImageStream(_process);
    } catch (e) {
      if (mounted) setState(() => _feedback = 'Camera unavailable. Check camera permission and try again.');
    }
  }

  InputImage? _input(CameraImage image) {
    final c = _camera;
    if (c == null) return null;
    final rotation = InputImageRotationValue.fromRawValue(c.description.sensorOrientation);
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (rotation == null || format == null || image.planes.length != 1) return null;
    return InputImage.fromBytes(bytes: image.planes.first.bytes, metadata: InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()), rotation: rotation,
      format: format, bytesPerRow: image.planes.first.bytesPerRow));
  }

  double? _angle(Pose p, PoseLandmarkType a, PoseLandmarkType b, PoseLandmarkType c) {
    final x=p.landmarks[a], y=p.landmarks[b], z=p.landmarks[c];
    if(x==null||y==null||z==null||x.likelihood<.5||y.likelihood<.5||z.likelihood<.5) return null;
    final v1x=x.x-y.x,v1y=x.y-y.y,v2x=z.x-y.x,v2y=z.y-y.y;
    final m1=math.sqrt(v1x*v1x+v1y*v1y),m2=math.sqrt(v2x*v2x+v2y*v2y);
    if(m1==0||m2==0) return null;
    return math.acos(((v1x*v2x+v1y*v2y)/(m1*m2)).clamp(-1.0,1.0))*180/math.pi;
  }

  double? _best(double? a,double? b) => a ?? b;

  Map<String,double> _measure(Pose p) {
    final values=<String,double>{};
    void put(String k,double? v){if(v!=null) values[k]=v;}
    put('Knee',_best(_angle(p,PoseLandmarkType.leftHip,PoseLandmarkType.leftKnee,PoseLandmarkType.leftAnkle),_angle(p,PoseLandmarkType.rightHip,PoseLandmarkType.rightKnee,PoseLandmarkType.rightAnkle)));
    put('Hip',_best(_angle(p,PoseLandmarkType.leftShoulder,PoseLandmarkType.leftHip,PoseLandmarkType.leftKnee),_angle(p,PoseLandmarkType.rightShoulder,PoseLandmarkType.rightHip,PoseLandmarkType.rightKnee)));
    put('Elbow',_best(_angle(p,PoseLandmarkType.leftShoulder,PoseLandmarkType.leftElbow,PoseLandmarkType.leftWrist),_angle(p,PoseLandmarkType.rightShoulder,PoseLandmarkType.rightElbow,PoseLandmarkType.rightWrist)));
    put('Shoulder',_best(_angle(p,PoseLandmarkType.leftElbow,PoseLandmarkType.leftShoulder,PoseLandmarkType.leftHip),_angle(p,PoseLandmarkType.rightElbow,PoseLandmarkType.rightShoulder,PoseLandmarkType.rightHip)));
    put('Ankle',_best(_angle(p,PoseLandmarkType.leftKnee,PoseLandmarkType.leftAnkle,PoseLandmarkType.leftFootIndex),_angle(p,PoseLandmarkType.rightKnee,PoseLandmarkType.rightAnkle,PoseLandmarkType.rightFootIndex)));
    return values;
  }

  JointQuality _grade(String name,double value) {
    // Broad coaching bands: red means clearly outside the expected movement envelope,
    // amber means approaching the edge, green means usable. These are coaching cues, not diagnosis.
    switch(_exercise){
      case 'squat':
      case 'lunge': if(name=='Knee') return value<65||value>178?JointQuality.bad:value<80||value>170?JointQuality.warning:JointQuality.good; break;
      case 'glute_bridge': if(name=='Hip') return value<110?JointQuality.bad:value<135?JointQuality.warning:JointQuality.good; break;
      case 'knee_extension': if(name=='Knee') return value<80?JointQuality.bad:value<110?JointQuality.warning:JointQuality.good; break;
      case 'calf_raise': if(name=='Ankle') return value<75||value>155?JointQuality.bad:value<90||value>145?JointQuality.warning:JointQuality.good; break;
      case 'shoulder_raise': if(name=='Shoulder') return value<20||value>175?JointQuality.bad:value<35||value>165?JointQuality.warning:JointQuality.good; break;
      case 'biceps_curl': if(name=='Elbow') return value<35||value>175?JointQuality.bad:value<45||value>165?JointQuality.warning:JointQuality.good; break;
    }
    return JointQuality.good;
  }

  Future<void> _process(CameraImage image) async {
    if(_busy) return;
    final input=_input(image); if(input==null) return;
    _busy=true;
    try{
      final poses=await _detector.processImage(input);
      if(!mounted) return;
      if(poses.isEmpty){setState((){_pose=null;_angles={};_quality={};_feedback='Move back until your full body is visible';});return;}
      final pose=poses.first, angles=_measure(pose);
      final quality=<String,JointQuality>{for(final e in angles.entries)e.key:_grade(e.key,e.value)};
      final primary=angles[rule.primary];
      var feedback='Good position — move slowly with control';
      if(primary==null){feedback='Keep your full body visible so I can measure ${rule.primary.toLowerCase()} angle';}
      else {
        if(primary<rule.downBelow){_phase=true;feedback='Movement phase detected — keep control';}
        else if(primary>rule.upAbove&&_phase){_reps++;_phase=false;feedback='Rep $_reps complete';}
        final bad=quality.entries.where((e)=>e.value==JointQuality.bad).map((e)=>e.key).toList();
        final warn=quality.entries.where((e)=>e.value==JointQuality.warning).map((e)=>e.key).toList();
        if(bad.isNotEmpty) feedback='Correct ${bad.join(', ')} angle — red means outside the coaching range';
        else if(warn.isNotEmpty) feedback='Adjust ${warn.join(', ')} slightly — amber means near the limit';
      }
      setState((){_pose=pose;_angles=angles;_quality=quality;_feedback=feedback;});
    } finally {_busy=false;}
  }

  void _select(String? id){
    if(id==null||id==_exercise) return;
    setState((){_exercise=id;_reps=0;_phase=false;_angles={};_quality={};_feedback='Ready for ${rule.name}';});
  }

  Color _color(JointQuality? q)=>q==JointQuality.bad?Colors.redAccent:q==JointQuality.warning?Colors.amber:Colors.greenAccent;

  @override
  void dispose(){_camera?.dispose();_detector.close();super.dispose();}

  @override
  Widget build(BuildContext context){
    final c=_camera;
    return Scaffold(
      appBar:AppBar(title:const Text('MOVENTRA Motion Coach')),
      body:SafeArea(child:Column(children:[
        Padding(padding:const EdgeInsets.fromLTRB(16,8,16,8),child:DropdownButtonFormField<String>(
          value:_exercise,decoration:const InputDecoration(labelText:'Exercise',border:OutlineInputBorder()),
          items:exerciseRules.map((e)=>DropdownMenuItem(value:e.id,child:Text(e.name))).toList(),onChanged:_select)),
        Expanded(child:c==null||!c.value.isInitialized
          ? Center(child:Column(mainAxisSize:MainAxisSize.min,children:[const CircularProgressIndicator(),const SizedBox(height:14),Text(_feedback,textAlign:TextAlign.center)]))
          : Padding(padding:const EdgeInsets.symmetric(horizontal:12),child:ClipRRect(borderRadius:BorderRadius.circular(24),child:Stack(fit:StackFit.expand,children:[
              CameraPreview(c),CustomPaint(painter:_PosePainter(_pose,c.value.previewSize,_quality)),
              Positioned(top:12,left:12,right:12,child:Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),decoration:BoxDecoration(color:Colors.black.withValues(alpha:.58),borderRadius:BorderRadius.circular(16)),child:const Text('Green = good   •   Amber = adjust   •   Red = correct',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontWeight:FontWeight.w700))))
            ])))),
        Padding(padding:const EdgeInsets.all(12),child:Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(children:[
          Row(children:[Expanded(child:_metric('REPS','$_reps',Colors.greenAccent)),..._angles.entries.take(3).map((e)=>Expanded(child:_metric(e.key.toUpperCase(),'${e.value.round()}°',_color(_quality[e.key]))))]),
          const SizedBox(height:12),Text(_feedback,textAlign:TextAlign.center,style:TextStyle(fontSize:17,fontWeight:FontWeight.w800,color:_quality.values.contains(JointQuality.bad)?Colors.redAccent:null)),
          const SizedBox(height:8),const Text('Movement coaching only. Camera analysis can be imperfect and does not diagnose injury or replace professional assessment.',textAlign:TextAlign.center,style:TextStyle(fontSize:11)),
        ]))))
      ])));
  }

  Widget _metric(String label,String value,Color color)=>Column(children:[Text(label,style:const TextStyle(fontSize:10,fontWeight:FontWeight.w700)),const SizedBox(height:2),Text(value,style:TextStyle(fontSize:24,fontWeight:FontWeight.w900,color:color))]);
}

class _PosePainter extends CustomPainter{
  _PosePainter(this.pose,this.previewSize,this.quality);
  final Pose? pose; final Size? previewSize; final Map<String,JointQuality> quality;
  Color q(String joint)=>quality[joint]==JointQuality.bad?Colors.redAccent:quality[joint]==JointQuality.warning?Colors.amber:Colors.greenAccent;
  @override void paint(Canvas canvas,Size size){
    final p=pose,ps=previewSize;if(p==null||ps==null)return;
    Offset? pt(PoseLandmarkType t){final l=p.landmarks[t];if(l==null||l.likelihood<.45)return null;return Offset(size.width-(l.x/ps.height)*size.width,(l.y/ps.width)*size.height);}
    void line(PoseLandmarkType a,PoseLandmarkType b,String joint){final x=pt(a),y=pt(b);if(x!=null&&y!=null)canvas.drawLine(x,y,Paint()..color=q(joint)..strokeWidth=5..strokeCap=StrokeCap.round);}
    line(PoseLandmarkType.leftShoulder,PoseLandmarkType.rightShoulder,'Shoulder');
    line(PoseLandmarkType.leftShoulder,PoseLandmarkType.leftElbow,'Shoulder');line(PoseLandmarkType.leftElbow,PoseLandmarkType.leftWrist,'Elbow');
    line(PoseLandmarkType.rightShoulder,PoseLandmarkType.rightElbow,'Shoulder');line(PoseLandmarkType.rightElbow,PoseLandmarkType.rightWrist,'Elbow');
    line(PoseLandmarkType.leftShoulder,PoseLandmarkType.leftHip,'Hip');line(PoseLandmarkType.rightShoulder,PoseLandmarkType.rightHip,'Hip');line(PoseLandmarkType.leftHip,PoseLandmarkType.rightHip,'Hip');
    line(PoseLandmarkType.leftHip,PoseLandmarkType.leftKnee,'Knee');line(PoseLandmarkType.leftKnee,PoseLandmarkType.leftAnkle,'Knee');line(PoseLandmarkType.leftAnkle,PoseLandmarkType.leftFootIndex,'Ankle');
    line(PoseLandmarkType.rightHip,PoseLandmarkType.rightKnee,'Knee');line(PoseLandmarkType.rightKnee,PoseLandmarkType.rightAnkle,'Knee');line(PoseLandmarkType.rightAnkle,PoseLandmarkType.rightFootIndex,'Ankle');
  }
  @override bool shouldRepaint(covariant _PosePainter old)=>old.pose!=pose||old.quality!=quality;
}
