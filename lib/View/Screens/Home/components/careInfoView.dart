import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PhotoItem {
  final String image;
  final int type;
  PhotoItem(this.image, this.type);
}

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 1),
      maxNrOfCacheObjects: 10,
    ),
  );
}

final List<List<PhotoItem>> _items = [
  [
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/person-sick-in-your-household-what-to-do-es.png",
        0),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/person-sick-in-your-household-prepare-es.jpg",
        0),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/grocery-shopping-es.jpg",
        0),
  ],
  [
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/medical-mask-do-sp.jpg?sfvrsn=c67232f0_19",
        1),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/medical-mak-dont-spd846cb194a4943a4bcd929fc0fe945e0.jpg?sfvrsn=3bcd5aa0_13",
        1),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/who-clothing-masks-dos-infographic-es.jpg?sfvrsn=679fb6f1_28",
        1),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/who-clothing-masks-donts-infographic-es.jpg?sfvrsn=d7b0f88d_22",
        1),
  ],
  [
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/visiting-family.jpg",
        2),
    PhotoItem(
        "https://www.who.int/images/default-source/health-topics/coronavirus/dont-put-off-medical-appointments-es.jpg",
        2),
  ]
];

class careInfoView extends StatefulWidget {
  const careInfoView({Key? key}) : super(key: key);

  @override
  _careInfoViewState createState() => _careInfoViewState();
}

class _careInfoViewState extends State<careInfoView> {
  int typeOfPoster = 0;
  List<PhotoItem> currentList = _items[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid information and recomendation'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  highlightColor: Color(0xFFFF9000),
                  onPressed: () => {
                    setState(() {
                      typeOfPoster = 0;
                      currentList = _items[typeOfPoster];
                    })
                  },
                  focusColor: Color(0xFFFF9000),
                ),
                IconButton(
                  icon: Icon(Icons.school),
                  onPressed: () => {
                    setState(() {
                      typeOfPoster = 1;
                      currentList = _items[typeOfPoster];
                    })
                  },
                ),
                IconButton(
                  icon: Icon(Icons.local_hospital),
                  onPressed: () => {
                    setState(() {
                      typeOfPoster = 2;
                      currentList = _items[typeOfPoster];
                    })
                  },
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemCount: currentList.length,
                itemBuilder: (context, index) {
                  return new GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RouteTwo(
                              image: _items[typeOfPoster][index].image,
                            ),
                          ));
                    },
                    child: CachedNetworkImage(
                      cacheManager: CustomCacheManager.instance,
                      imageUrl: _items[typeOfPoster][index].image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RouteTwo extends StatelessWidget {
  final String image;

  RouteTwo({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: image,
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
