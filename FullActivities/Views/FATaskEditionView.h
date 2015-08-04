//
//  FATaskEditionView.h
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FATaskEditionViewController;

@interface FATaskEditionView : UIView
{
    UILabel *taskPriorityLabel;
    UILabel *taskTypeLabel;
}


////////// Propriétés //////////

//  Contient une référence vers le controlleur de la vue
//  La référence est défini par le controlleur de la vue une fois la vue initialisée
@property (retain)   FATaskEditionViewController *taskEditionViewController;

//  Permet au controlleur de savoir si on est sur un iPhone ou non
//  Utile pour la gestion de l'affichage des ActionSheet et du UIImagePickerController
@property (readonly) BOOL isiPhone;

//  Permet au controleur de la vue d'accéder aux valeur des objets
//      et de définir leur propriétés
@property (readonly) UITextField *taskNameField;
@property (readonly) UISegmentedControl *taskPrioritySegments;
@property (readonly) UISegmentedControl *taskTypeSegments;
@property (readonly) UIImageView *taskImageView;


////////// Méthodes //////////

//  Méthode pour dessiner la vue selon une orientation et en gérant la frame de la statusBar
//  Cette méthode est également appellée par FAAppDelegate lors d'un changement de frame de la statusBar
- (void)setViewForOrientation:(UIInterfaceOrientation)orientation withStatusBarFrame:(CGRect)statusBarFrame;

@end
