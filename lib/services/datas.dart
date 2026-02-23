import 'package:flutter/material.dart';
import 'package:vst/const.dart'; // Importation des constantes
import 'package:vst/models/article.dart'; // Importation du modèle d'article
import 'package:vst/models/youtube.dart'; // Importation du modèle YouTube
import 'package:vst/services/network_helper.dart'; // Importation de l'aide réseau

class Datas extends ChangeNotifier {
  // Sélection des booléens pour filtrer les articles
  bool isMostViewed = true,
      isMostRecent = false,
      isMachineLearning = true,
      isGenerativeIa = false,
      isNlp = false,
      isComputerVision = false;

  // articleQuery pour pouvoir acceder à ça de partout
  String articleQuery = "machine%20learning";

  // Fonctions pour filtrer les articles par différentes catégories
  void forMostViewed() {
    isMostViewed = true;
    isMostRecent = false;
    fetchVideos(); // Appel à la fonction pour récupérer les vidéos YouTube
    notifyListeners(); // Notifier les auditeurs du changement
  }

  // Fonction pour filtrer les articles les plus récents
  void forMostRecent() {
    isMostViewed = false;
    isMostRecent = true;
    fetchVideos(); // Appel à la fonction pour récupérer les vidéos YouTube
    notifyListeners(); // Notifier les auditeurs du changement
  }

  // Fonction pour filtrer les articles sur le développement web
  void forGenerativeAI() {
    // Sélection du filtre et appel à la fonction pour récupérer les articles
    isGenerativeIa = true;
    isMachineLearning = false;
    isNlp = false;
    isComputerVision = false;
    fetchArticles();
    notifyListeners(); // Notifier les auditeurs du changement
  }

  // Fonction pour filtrer les articles sur JavaScript
  void forMachineLearning() {
    // Sélection du filtre et appel à la fonction pour récupérer les articles
    isMachineLearning = true;
    isGenerativeIa = false;
    isNlp = false;
    isComputerVision = false;
    fetchArticles();
    notifyListeners(); // Notifier les auditeurs du changement
  }

  // Fonction pour filtrer les articles sur Python
  void forNlp() {
    // Sélection du filtre et appel à la fonction pour récupérer les articles
    isMachineLearning = false;
    isGenerativeIa = false;
    isNlp = true;
    isComputerVision = false;
    fetchArticles();
    notifyListeners(); // Notifier les auditeurs du changement
  }

  // Fonction pour filtrer les articles sur React
  void forComputerVsion() {
    // Sélection du filtre et appel à la fonction pour récupérer les articles
    isMachineLearning = false;
    isGenerativeIa = false;
    isNlp = false;
    isComputerVision = true;
    fetchArticles();
    notifyListeners(); // Notifier les auditeurs du changement
  }

  // Fonction pour filtrer les articles sur Node.js
  void forNodeJs() {
    // Sélection du filtre et appel à la fonction pour récupérer les articles
    isMachineLearning = false;
    isGenerativeIa = false;
    isNlp = false;
    isComputerVision = true;
    fetchArticles();
    notifyListeners(); // Notifier les auditeurs du changement
  }

  // Fonction pour filtrer les articles sur Django
  void forDjango() {
    // Sélection du filtre et appel à la fonction pour récupérer les articles
    isMachineLearning = false;
    isGenerativeIa = false;
    isNlp = false;
    isComputerVision = false;
    fetchArticles();
    notifyListeners(); // Notifier les auditeurs du changement
  }

  // Fonction pour récupérer les articles depuis l'API de News
  List<Article> articles = [];
  Future<void> fetchArticles() async {
    // Définition de la requête en fonction du filtre sélectionné

    if (isGenerativeIa) {
      articleQuery = "generative%20artificial%20intelligence";
    } else if (isNlp) {
      articleQuery = "nlp";
    } else if (isComputerVision) {
      articleQuery = "computer%20vision";
    } else {
      articleQuery = "machine%20learning";
    }

    // Récupération des données depuis l'API de News
    final data = await NetworkHelper(
      'https://newsapi.org/v2/everything?q=$articleQuery&apiKey=$newsApiKey',
    ).getData();

    // Traitement des données récupérées
    if (data['status'] == 'ok') {
      articles.clear(); // Nettoyage de la liste d'articles
      for (var item in data['articles']) {
        articles.add(Article.fromJson(item)); // Ajout des articles à la liste
        notifyListeners(); // Notifier les auditeurs du changement
      }
      notifyListeners(); // Notifier les auditeurs du changement
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Fonction pour récupérer les vidéos YouTube depuis l'API YouTube
  List<Youtube> videos = [];
  Future<void> fetchVideos() async {
    int maxPages = 20; // Nombre maximal de pages à récupérer
    String? nextPageToken; // Jeton de page suivante

    String order = "viewCount"; // Ordre par défaut

    if (isMostViewed) {
      order = "viewCount"; // Si les vidéos les plus vues sont sélectionnées
    } else {
      order = "date"; // Sinon, les vidéos les plus récentes
    }

    // Boucle pour récupérer les vidéos à partir de plusieurs pages
    for (int page = 0; page < maxPages; page++) {
      final data = await NetworkHelper(
        // Requête pour récupérer les vidéos
        'https://youtube.googleapis.com/youtube/v3/search?part=snippet&order=$order&q=$articleQuery&key=$youtubeApiKey'
        '${nextPageToken != null ? '&pageToken=$nextPageToken' : ''}',
      ).getData();

      // Traitement des données récupérées
      if (data != null && data.containsKey('items')) {
        videos.clear(); // Nettoyage de la liste de vidéos
        final List<dynamic> items = data['items'];

        // Parcours des éléments récupérés
        for (var item in items) {
          final snippet = item['snippet'];
          final id = item['id'];

          final youtube = Youtube(
            title: snippet['title'],
            publishedAt: snippet['publishedAt'],
            desc: snippet['description'],
            channelName: snippet['channelTitle'],
            videoId: id['videoId'],
          );

          videos.add(youtube); // Ajout de la vidéo à la liste
        }

        notifyListeners(); // Notifier les auditeurs du changement
      }

      // Vérification de la présence d'une page suivante
      if (data != null && data.containsKey('nextPageToken')) {
        nextPageToken = data['nextPageToken'];
      } else {
        break; // Pas de page suivante disponible, sortir de la boucle
      }
    }
  }

  // Liste de vidéos YouTube préchargées (à des fins de démonstration)
  List<Youtube> videosViews = [];

  List<Youtube> machineLearningVidoes = [
    Youtube(
      title:
          "Et si l'intelligence n'avait pas évolué ? Elle était là depuis le début !",
      videoId: "M2iX6HQOoLg",
      desc:
          "Il aborde les expériences BFF (programmes autoréplicatifs émergeant spontanément "
          "d'un bruit aléatoire), le cadre mathématique reliant la dynamique des populations "
          "de Lotka-Volterra à la coagulation de Smoluchowski, l'analyse des valeurs propres "
          "des matrices de coopération et son argument central : la symbiogenèse, et non la mutation, "
          "est le principal moteur de l'innovation évolutive.",
      publishedAt: "2026-02-16",
      channelName: "Machine Learning Street Talk",
    ),

    Youtube(
      title: "All Machine Learning algorithms explained in 17 min",
      videoId: "E0Hmnixke2g ",
      desc:
          "In this video I will go through all machine learning algorithms in less than 17 "
          "minutes to get you an intuitive understanding of how they work and how they relate"
          " to each other as well as help you decide how to pick the right one for your problem."
          " Going all the way from Linear Regression to Neural Networks / Deep Learning and Unsupervised"
          " Learning.",
      publishedAt: "2025-02-20",
      channelName: "Infinite Codes",
    ),

    Youtube(
      title: "Essential Machine Learning and AI Concepts Animated",
      videoId: "PcbuKRNtCUc",
      desc:
          "Learn about all the most important concepts and terms related to machine learning and AI.",
      publishedAt: "2025-06-19",
      channelName: "Freecodecamp.org!",
    ),
    Youtube(
      title: "COMMENT FONCTIONNE LE MACHINE LEARNING ?",
      videoId: "sqs8DxGhwM8",
      desc:
          "Le Machine Learning est tout autour de vous. Les algorithmes"
          " d’apprentissage automatique et les réseaux de neurones font tourner YouTube,"
          " Google, Amazon, Facebook… la reconnaissance vocale, la voiture autonome, "
          "les hôpitaux, le système judiciaire. Le monde entier se tourne vers cette technologie."
          " Mais pourquoi donc ?",
      publishedAt: "2020-12-12",
      channelName: "Machine Lernia",
    ),
    Youtube(
      title: "Machine Learning VS Deep Learning : Quelles différences ?",
      videoId: "PLoYCgNOIyGAB_8_iq1cL8MVeun7cB6eNc",
      desc:
          "Aujourd’hui, l’analyse de données représente un facteur clé dans la prise de"
          " décision des entreprises. Ces données nécessitent d’être pré-traitées et analysées"
          " en utilisant l’intelligence artificielle grâce à des méthodes de #MachineLearning"
          " comme le #DeepLearning.",
      publishedAt: "2022-01-17",
      channelName: "Liora",
    ),
  ];
}
