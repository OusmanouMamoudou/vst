import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vst/components/appbar_title.dart'; // Import du composant AppBarTitle
import 'package:vst/components/article_card.dart'; // Import du composant ArticleCard
import 'package:vst/components/article_selection.dart'; // Import du composant ArticleSelection
import 'package:vst/components/video_card.dart'; // Import du composant TutoCard
import 'package:vst/components/video_selection.dart'; // Import du composant TutoSelection
import 'package:vst/const.dart';
import 'package:vst/services/datas.dart'; // Import du service Datas

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;

    return Consumer<Datas>(
      builder: (context, datas, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: AppBarTitle(
              height: height,
            ), // Utilisation du composant AppBarTitle pour afficher le titre de l'application
          ),
          body: page == 0
              ? Column(
                  children: [
                    const ArticleSelection(), // Affichage de la sélection d'articles
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: datas.articles.length,
                        itemBuilder: (context, i) {
                          return ArticleCard(index: i);
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const TutoSelection(), // Affichage de la sélection de tutoriels
                    SizedBox(
                      height: height * 0.7,
                      child: ListView.builder(
                        itemCount: datas.videos.isNotEmpty
                            ? datas.videos.length
                            : datas.videosViews.length,
                        itemBuilder: (context, i) {
                          final isNotEmpty = datas.videos.isNotEmpty;

                          final videoId = isNotEmpty
                              ? datas.videos[i].videoId
                              : datas.videosViews[i].videoId;

                          return Column(
                            children: [
                              VideoCard(videoId: videoId.toString(), index: i),
                              SizedBox(
                                height: 15,
                                child: Divider(
                                  color: kAppBarColor,
                                  endIndent: 15,
                                  indent: 15,
                                  thickness: 10,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),

          bottomNavigationBar: ConvexAppBar(
            activeColor: kAppBarColor,
            style: TabStyle.reactCircle,
            backgroundColor: kBackgroundColor,
            items: [
              TabItem(icon: Icons.article, title: 'Articles'),
              TabItem(icon: Icons.camera_outdoor_sharp, title: 'Videos'),
            ],
            initialActiveIndex: 0,
            onTap: (int i) => setState(() {
              page = i;
              print("oooooooooooooo $page");
            }),
          ),
        );
      },
    );
  }
}
