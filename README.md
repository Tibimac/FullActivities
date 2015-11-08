# FullActivities
Exercice "FullActivities" de la semaine 7 du MOOC "Programmation iPhone et iPad".</br>
Réalisation : 18 juin 2014

[![FullActivities](http://www.tibimac.com/uploads_forums/github/FullActivities-List.png)](https://youtu.be/nRWQNgkr79U "FullActivities")
[![FullActivities](http://www.tibimac.com/uploads_forums/github/FullActivities-Task.png)](https://youtu.be/nRWQNgkr79U "FullActivities")

Vidéo de démo : https://youtu.be/nRWQNgkr79U

- ARC désactivé.
- Structure MVC.
- Pas de storyboard.
- Des boutons "checkbox" (créés manuellement) dans chaque cellule permettent d'indiquer si une tâche est réalisée ou non. Ce bouton a une couleur qui est en fonction de la priorité de la tâche (sachant qu'à l'ajout, aucune priorité n'est définie (-1) la checkbox est noire). Une fois "checkée" une tâche se "grise" pour être moins visible.
- Ajout / Suppression / Déplacement des cellules.
- Lors de l'ajout -> affichage de la fenêtre d'édition avec clavier affiché pour directement saisir le nom de la tâche.
- Possibilité d'ajout de photos : Si plusieurs sources dispo une ActionSheet propose le choix à l'utilisateur. Sur iPad suivi les guidelines Apple, ainsi si l'utilisateur choisi Appareil Photo -> affichage en plein écran, s'il choisi Bibliothèque d'images - > affichage dans un popover.
- Possibilité de supprimer l'image via un appui long sur l'image, une action sheet demande alors une validation. Sur iPad cette ActionSheet se positionne pile à l'endroit où l'utilisateur a touché l'image. (l'ActionSheet n'apparait pas s'il n'y a pas d'image).
- Gestion de la rotation (un peu basique), gestion iPad/iPhone-iPod.
- Ne fonctionne que sur iOS7.
- Une pastille indique le nombre de tâche qui ne sont pas finies (pastille mise à jour lorsqu'on sort de l'appli donc dans le AppDelegate).
