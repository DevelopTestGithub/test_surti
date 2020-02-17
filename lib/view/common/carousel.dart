import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

final Widget placeholder = Container(color: Colors.green);

class CarouselData{

  final String imageUrl;
  final Function imageAction;

  CarouselData({
    this.imageUrl,
    this.imageAction,
  });

}

class Carousel extends StatefulWidget {

  final Widget visualIndication;
  final List<CarouselData> data2Show;
  Carousel({
    @required this.data2Show,
    @required this.visualIndication,
  });

  @override
  _CarouselState createState() => _CarouselState(data2Show, visualIndication);

}

class _CarouselState extends State<Carousel> {

  _CarouselState(this.data2Show, this.visualIndication);

  final Widget visualIndication;
  List<CarouselData> data2Show;
  int _current = 0;
  List child;

  List<T> map<T>(List list, Function handler) {

    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  void initState() {
    _initChild();
    super.initState();

  }

  _initChild(){

    child = map<Widget>(
      data2Show,
          (index, i) {
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(children: <Widget>[
                visualIndication,
                FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: i.imageUrl,
                  fit: BoxFit.cover,
                  width: 1000.0,
                ),
                //Image.network(i, fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Container(),
                  ),
                ),
              ]),
            ),
          ),

          onTap: (){
            print('Promoción ${index +1}');
            i.imageAction();
          },

        );
      },
    ).toList();

  }


  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: child,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          data2Show,
              (index, url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4)),
            );
          },
        ),
      ),
    ]);
  }
}