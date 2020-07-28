import 'dart:async';

import 'package:film_app/const.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
class _HomePageState extends State<HomePage> {
  double _height = 0.0;
  double _width = 0.0;
  double _top = 0.0;
  List<Widget> _imageList = [];
  Timer timer;
  ScrollController _controller;
  bool _onTop = true;
 
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_)  {
      _loadSlider();
    });
  }

  _scrollListener(){
    print(_controller.position.userScrollDirection);
    if(_controller.position.pixels < 20){
      setState(() {
        _onTop = true;
      });
    }
    else if(_controller.position.pixels > 40 && _onTop && ScrollDirection.reverse == _controller.position.userScrollDirection ){
      _controller.animateTo(_height - 100,duration: Duration(milliseconds: 500), curve: Curves.linear);
      setState(() {
        _onTop = false;
      });
    }
    else if(_controller.position.pixels < _height -40 && !_onTop && ScrollDirection.forward == _controller.position.userScrollDirection ){
      _controller.animateTo(0,duration: Duration(milliseconds: 500), curve: Curves.linear);
      setState(() {
        _onTop = true;
      });
    }
  }

  _loadSlider(){
    List<Widget> _imageListTemp = [];
    for (var item in imgList) {
      _imageListTemp.add(
        Container(
          height: _height - 100,
          width: _width,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                height: _height - 100,
                width: _width,
                child: Image.network(
                  item,
                  fit: BoxFit.cover
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  width: _width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        ColorList.Black,
                        ColorList.Black.withOpacity(0.5), 
                        ColorList.Black.withOpacity(0.9), 
                      ]
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Film Name",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: Colors.white
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '7.7 / ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '10', 
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: Text(
                          "English - Action",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      );

      setState(() {
        _imageList = _imageListTemp;
      });
    }

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _changeButtonPosition());
  }

  _changeButtonPosition(){
    if(_top == _height-180){
      setState(() {
        _top = _height-150;
      });
    }else{
      setState(() {
        _top = _height-180;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    return Scaffold(
      body: Container(
        height:_height,
        width:_width,
        child: Stack(
          children: <Widget>[
            Container(
              height:_height,
              width:_width,
              color: ColorList.Black,
              child: Column(
                children: <Widget>[

                  //app bar
                  Container(
                    height: 100,
                    width: _width,
                    color: ColorList.Red,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom:10.0,left: 15),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              child: Icon(
                                Icons.menu,
                                color: ColorList.Black,
                                size: 28,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom:10.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: Text(
                                "Film App",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),

                  //page container
                  Container(
                    height: _height - 100,
                    width: _width,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: ListView(
                        controller: _controller,
                        children: <Widget>[
                          Container(
                            height: _height - 100,
                            width: _width,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 1.0,
                                enlargeCenterPage: true,
                                height: _height - 100,
                                viewportFraction:1
                              ),
                              items: _imageList,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            width: _width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:0.0),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right:8.0),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3)
                                        ),
                                        color: Colors.white
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "English",
                                            style:TextStyle(
                                              color: ColorList.Black,
                                              fontSize: 15
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right:8.0),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3)
                                        ),
                                        color: Colors.white
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Hindi",
                                            style:TextStyle(
                                              color: ColorList.Black,
                                              fontSize: 15
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right:8.0),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3)
                                        ),
                                        color: Colors.white
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Tamil",
                                            style:TextStyle(
                                              color: ColorList.Black,
                                              fontSize: 15
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right:8.0),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3)
                                        ),
                                        color: Colors.white
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Korean",
                                            style:TextStyle(
                                              color: ColorList.Black,
                                              fontSize: 15
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: _height,
                          )
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),

           _onTop? AnimatedPositioned(
              top:_top,
              right: 10,
              duration: Duration(seconds: 1),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: ColorList.Red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1.0,
                      spreadRadius: -2.0, 
                      offset: Offset(
                        1.0,
                        2.0,
                      ),
                    )
                  ],
                ),
                child: Icon(
                  Icons.arrow_downward
                ),
              ),
            ):Container()
          ],
        ),
      ),
    );
  }
}

class ColoList {
}