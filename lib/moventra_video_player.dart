import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MoventraVideoPlayer extends StatefulWidget {
  const MoventraVideoPlayer({super.key, required this.asset, required this.title});
  final String asset;
  final String title;

  @override
  State<MoventraVideoPlayer> createState()=>_MoventraVideoPlayerState();
}

class _MoventraVideoPlayerState extends State<MoventraVideoPlayer> {
  late final VideoPlayerController controller;
  Future<void>? init;

  @override
  void initState(){
    super.initState();
    controller=VideoPlayerController.asset(widget.asset);
    init=controller.initialize().then((_){ if(mounted)setState((){}); });
  }

  @override
  void dispose(){ controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context)=>Card(child:Padding(
    padding:const EdgeInsets.all(14),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(widget.title,style:const TextStyle(fontWeight:FontWeight.w800,fontSize:18)),
      const SizedBox(height:10),
      FutureBuilder(
        future:init,
        builder:(context,s)=>s.connectionState==ConnectionState.done
          ? AspectRatio(aspectRatio:controller.value.aspectRatio,child:VideoPlayer(controller))
          : const AspectRatio(aspectRatio:16/9,child:Center(child:CircularProgressIndicator())),
      ),
      IconButton(
        onPressed:()=>setState(()=>controller.value.isPlaying?controller.pause():controller.play()),
        icon:Icon(controller.value.isPlaying?Icons.pause_circle:Icons.play_circle,size:38),
      ),
    ]),
  ));
}
