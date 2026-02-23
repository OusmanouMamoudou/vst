import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vst/components/appbar_title.dart'; // Import du composant AppBarTitle
import 'package:vst/components/article_card.dart'; // Import du composant ArticleCard
import 'package:vst/components/article_selection.dart'; // Import du composant ArticleSelection
import 'package:vst/components/video_card.dart'; // Import du composant TutoCard
import 'package:vst/components/video_selection.dart'; // Import du composant TutoSelection
import 'package:vst/services/datas.dart'; // Import du service Datas

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          body: Column(
            children: [
              const TutoSelection(), // Affichage de la sélection de tutoriels
              SizedBox(
                height: height * 0.27,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: datas.videos.isNotEmpty
                      ? datas.videos.length
                      : datas.videosViews.length,
                  itemBuilder: (context, i) {
                    final isNotEmpty = datas.videos.isNotEmpty;

                    final videoId = isNotEmpty
                        ? datas.videos[i].videoId
                        : datas.videosViews[i].videoId;

                    return VideoCard(videoId: videoId.toString(), index: i);
                  },
                ),
              ),
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
          ),
        );
      },
    );
  }
}
