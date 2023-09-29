import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class TweetImages extends StatefulWidget {
  final List<String> imageLinks;
  const TweetImages({super.key, required this.imageLinks});

  @override
  State<TweetImages> createState() => _TweetImagesState();
}

class _TweetImagesState extends State<TweetImages> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageLinks.map(
                (link) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(10),
                    child: Image.network(
                      link,
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                height: 256,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            widget.imageLinks.length > 1
                ? Row(
                    children: widget.imageLinks.asMap().entries.map((e) {
                      return Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(
                              _current == e.key ? 0.9 : 0.4,
                            )),
                      );
                    }).toList(),
                  )
                : const SizedBox()
          ],
        ),
      ],
    );
  }
}
