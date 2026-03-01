import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vst/components/selected_button.dart'; // Importe le widget SelectedButton
import 'package:vst/const.dart';
import 'package:vst/services/datas.dart'; // Importe la classe Datas qui contient les données

// Ce widget ArticleSelection affiche des boutons pour sélectionner différentes catégories d'articles.
//Il utilise le widget SelectedButton pour chaque bouton, et il met à jour l'état des sélections en appelant
//les méthodes appropriées de la classe Datas.

class ArticleSelection extends StatelessWidget {
  const ArticleSelection({
    super.key,
  }); // Constructeur de la classe ArticleSelection

  @override
  Widget build(BuildContext context) {
    return Consumer<Datas>(
      // Écouteur de changements sur la classe Datas
      builder: (context, datas, child) => Card(
        color: kBackgroundColor,
        // Crée une carte pour afficher les boutons de sélection
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SelectedButton(
                  // Bouton pour sélectionner la catégorie "Web Development"
                  onPressed: () {
                    datas
                        .forGenerativeAI(); // Appelle la méthode forWebdev de la classe Datas
                  },
                  text: "Generative AI",
                  isSelected: datas
                      .isGenerativeIa, // Vérifie si la catégorie est sélectionnée
                ),
                SelectedButton(
                  // Bouton pour sélectionner la catégorie "JavaScript"
                  onPressed: () {
                    datas
                        .forMachineLearning(); // Appelle la méthode forJavaS de la classe Datas
                  },
                  text: "Machine Learning",
                  isSelected: datas
                      .isMachineLearning, // Vérifie si la catégorie est sélectionnée
                ),
                SelectedButton(
                  // Bouton pour sélectionner la catégorie "Python"
                  onPressed: () {
                    datas
                        .forNlp(); // Appelle la méthode forPyton de la classe Datas
                  },
                  text: "NLP",
                  isSelected:
                      datas.isNlp, // Vérifie si la catégorie est sélectionnée
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SelectedButton(
                  // Bouton pour sélectionner la catégorie "React"
                  onPressed: () {
                    datas
                        .forComputerVsion(); // Appelle la méthode forReact de la classe Datas
                  },
                  text: "Computer Vision",
                  isSelected: datas
                      .isComputerVision, // Vérifie si la catégorie est sélectionnée
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
