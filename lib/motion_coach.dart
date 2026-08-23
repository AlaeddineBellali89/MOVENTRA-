import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class MotionCoachPage extends StatefulWidget {
  const MotionCoachPage({super.key});

  @override
  State<MotionCoachPage> createState() => _MotionCoachPageState();
}

class _MotionCoachPageState extends State<MotionCoachPage> {
  CameraController? _camera;
  late final PoseDetector _detector;
  Pose? _pose;
  bool _busy = false;
  int _reps = 0;
  bool _down = false;
  double? _kneeAngle;
  String _feedback = 'Stand where your full body is visible';

  @override
  void initState() {
    super.initState();
    _detector = PoseDetector(options: PoseDetectorOptions(mode: PoseDetectionMode.stream));
    _start();
  }

  Future<void> _start() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    final front = cameras.where((c) => c.lensDirection == CameraLensDirection.front);
    final selected = front.isNotEmpty ? front.first : cameras.first;
    final controller = CameraController(
      selected,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    await controller.initialize();
    if (!mounted) return;
    setState(() => _camera = controller);
    await controller.startImageStream(_process);
  }

  InputImage? _input(CameraImage image) {
    final c = _camera;
    if (c == null) return null;
    final rotation = InputImageRotationValue.fromRawValue(c.description.sensorOrientation);
    if (rotation == null) return null;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null || image.planes.length != 1) return null;
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

  Future<void> _process(CameraImage image) async {
    if (_busy) return;
    final input = _input(image);
    if (input == null) return;
    _busy = true;
    try {
      final poses = await _detector.processImage(input);
      if (!mounted) return;
      if (poses.isEmpty) {
        setState(() {
          _pose = null;
          _kneeAngle = null;
          _feedback = 'Move back until your full body is visible';
        });
        return;
      }
      final pose = poses.first;
      final angle = _bestKneeAngle(pose);
      String feedback = 'Good position';
      if (angle != null) {
        if (angle < 105) {
          feedback = 'Bottom position detected — keep control';
          _down = true;
        } else if (angle > 155 && _down) {
          _reps++;
          _down = false;
          feedback = 'Rep $_reps complete';
        } else if (angle > 165) {
          feedback = 'Start the squat when ready';
        } else {
          feedback = 'Control the movement';
        }
      }
      setState(() {
        _pose = pose;
        _kneeAngle = angle;
        _feedback = feedback;
      });
    } finally {
      _busy = false;
    }
  }

  double? _bestKneeAngle(Pose pose) {
    double? side(PoseLandmarkType hip, PoseLandmarkType knee, PoseLandmarkType ankle) {
      final a = pose.landmarks[hip];
      final b = pose.landmarks[knee];
      final c = pose.landmarks[ankle];
      if (a == null || b == null || c == null) return null;
      if (a.likelihood < .5 || b.likelihood < .5 || c.likelihood < .5) return null;
      final v1x = a.x - b.x, v1y = a.y - b.y;
      final v2x = c.x - b.x, v2y = c.y - b.y;
      final dot = v1x * v2x + v1y * v2y;
      final m1 = math.sqrt(v1x*v1x + v1y*v1y);
      final m2 = math.sqrt(v2x*v2x + v2y*v2y);
      if (m1 == 0 || m2 == 0) return null;
      return math.acos((dot/(m1*m2)).clamp(-1.0,1.0)) * 180 / math.pi;
    }
    return side(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle) ??
        side(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
  }

  @override
  void dispose() {
    _camera?.dispose();
    _detector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _camera;
    return Scaffold(
      appBar: AppBar(title: const Text('MOVENTRA Motion Coach')),
      body: c == null || !c.value.isInitialized
          ? const Center(child:CircularProgressIndicator())
          : SafeArea(
              child:Column(children:[
                Expanded(
                  child:ClipRRect(
                    borderRadius:BorderRadius.circular(24),
                    child:Stack(fit:StackFit.expand,children:[
                      CameraPreview(c),
                      CustomPaint(painter:_PosePainter(_pose,c.value.previewSize)),
                    ]),
                  ),
                ),
                Padding(
                  padding:const EdgeInsets.all(16),
                  child:Card(child:Padding(
                    padding:const EdgeInsets.all(16),
                    child:Column(children:[
                      Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:[
                        _metric('REPS','$_reps'),
                        _metric('KNEE',_kneeAngle==null?'—':'${_kneeAngle!.round()}°'),
                      ]),
                      const SizedBox(height:12),
                      Text(_feedback,textAlign:TextAlign.center,
                        style:const TextStyle(fontSize:18,fontWeight:FontWeight.w700)),
                      const SizedBox(height:8),
                      const Text(
                        'Movement coaching only. It does not diagnose injury or replace professional assessment.',
                        textAlign:TextAlign.center,
                        style:TextStyle(fontSize:12),
                      ),
                    ]),
                  )),
                ),
              ]),
            ),
    );
  }

  Widget _metric(String label,String value)=>Column(children:[
    Text(label,style:const TextStyle(fontSize:11,fontWeight:FontWeight.w700)),
    Text(value,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900)),
  ]);
}

class _PosePainter extends CustomPainter {
  _PosePainter(this.pose,this.previewSize);
  final Pose? pose;
  final Size? previewSize;

  @override
  void paint(Canvas canvas,Size size) {
    final p=pose, ps=previewSize;
    if(p==null || ps==null) return;
    final paint=Paint()..color=Colors.greenAccent..strokeWidth=4..strokeCap=StrokeCap.round;
    Offset? pt(PoseLandmarkType t){
      final l=p.landmarks[t];
      if(l==null || l.likelihood<.45) return null;
      return Offset(size.width-(l.x/ps.height)*size.width,(l.y/ps.width)*size.height);
    }
    void line(PoseLandmarkType a,PoseLandmarkType b){
      final x=pt(a),y=pt(b); if(x!=null&&y!=null) canvas.drawLine(x,y,paint);
    }
    const pairs=[
      [PoseLandmarkType.leftShoulder,PoseLandmarkType.rightShoulder],
      [PoseLandmarkType.leftShoulder,PoseLandmarkType.leftElbow],
      [PoseLandmarkType.leftElbow,PoseLandmarkType.leftWrist],
      [PoseLandmarkType.rightShoulder,PoseLandmarkType.rightElbow],
      [PoseLandmarkType.rightElbow,PoseLandmarkType.rightWrist],
      [PoseLandmarkType.leftShoulder,PoseLandmarkType.leftHip],
      [PoseLandmarkType.rightShoulder,PoseLandmarkType.rightHip],
      [PoseLandmarkType.leftHip,PoseLandmarkType.rightHip],
      [PoseLandmarkType.leftHip,PoseLandmarkType.leftKnee],
      [PoseLandmarkType.leftKnee,PoseLandmarkType.leftAnkle],
      [PoseLandmarkType.rightHip,PoseLandmarkType.rightKnee],
      [PoseLandmarkType.rightKnee,PoseLandmarkType.rightAnkle],
    ];
    for(final x in pairs) line(x[0],x[1]);
  }

  @override
  bool shouldRepaint(covariant _PosePainter old)=>old.pose!=pose;
}
