import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class Destaques extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        CarouselSlider(
          height: 180.0,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 0.8,
          items: [
            ItemDestaque(
                'gs://comilao-8b6e4.appspot.com/Destaques/destaque1.jpg'),
            ItemDestaque(
                'gs://comilao-8b6e4.appspot.com/Destaques/destaque2.jpg'),
            ItemDestaque(
                'gs://comilao-8b6e4.appspot.com/Destaques/destaque3.jpg')
          ],
        )
      ],
    );
  }
}

class ItemDestaque extends StatelessWidget {
  final String imagem;
  ItemDestaque(this.imagem);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: FirebaseImage(imagem),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
