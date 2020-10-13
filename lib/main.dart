import 'package:film_app/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Film App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "Acme"
      ),
      home: Scaffold(
        body: Splash()
      ),
    );
  }
}


// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';

// void main() => runApp(VideoApp());

// class VideoApp extends StatefulWidget {
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }

// class _VideoAppState extends State<VideoApp> {
//   VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//         'https://drive.google.com/file/d/1F2ZYX-2BlN2yDLIKK_jBcDby8-cJi3kb/view?usp=sharing')
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Demo',
//       home: Scaffold(
//         body: Center(
//           child: _controller.value.initialized
//               ? AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )
//               : Container(child:Text("not init")),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _controller.value.isPlaying
//                   ? _controller.pause()
//                   : _controller.play();
//             });
//           },
//           child: Icon(
//             _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }