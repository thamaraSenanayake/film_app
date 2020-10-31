import 'package:film_app/model/episode.dart';
import 'package:flutter/material.dart';

class EpisodeView extends StatefulWidget {
  final List<Episode> episodeLit;
  final EpisodeViewController controller;
  EpisodeView({Key key,@required this.episodeLit,@required this.controller}) : super(key: key);

  @override
  _EpisodeViewState createState() => _EpisodeViewState();
}

class _EpisodeViewState extends State<EpisodeView> {
  List<Widget> episodeListWidget = [];
  @override
  void initState() {
    super.initState();
    _loadEpisode();
  }
  bool _view  = false;

  _loadEpisode(){
    for (var item in widget.episodeLit) {
      episodeListWidget.add(
        GestureDetector(
          onTap: (){
            widget.controller.episodeClick(item,"episode "+(widget.episodeLit.indexOf(item)+1).toString());
          },
          child: Container(
            height: 50,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:30.0),
                  child: Container(
                    child:Text(
                      "episode "+(widget.episodeLit.indexOf(item)+1).toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size:20
                  ),
                )
              ],
            ),
          ),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Container(
                  child:Text(
                    widget.episodeLit[0].seasonName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    _view = !_view;
                  }); 
                },
                child: Container(
                  child: Icon(
                    _view ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size:30
                  ),
                ),
              )
            ],
          ),
        ),
        _view?Column(
          children: episodeListWidget,
        ):Container()
      ],
    );
  }
}

abstract class EpisodeViewController{
  episodeClick(Episode episode,String epiName);
}