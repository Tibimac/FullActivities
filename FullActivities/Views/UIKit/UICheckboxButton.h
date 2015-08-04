//
//  UICheckboxButton.h
//  FullActivities
//
//  Created by Thibault Le Cornec on 25/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICheckboxButton : UIButton

////////// Propriétés //////////

//  Référence l'objet UITableViewCell dans lequel est
//      contenue l'instance de UICheckboxButton
@property (retain) UITableViewCell *cellContainer;
//  Stocke l'indexPath de la cellule dans laquelle
//      est contenu l'instance de UICheckboxButton
@property (copy) NSIndexPath *indexPathCell;


////////// Méthodes //////////

//  Méthode appellée par tableView:cellForRowAtindexPath dans DataSource
//  Cette méthode configure un bouton checkbox avec les images appropriées
//      en fonction de la priorité de la tâche à laquelle il est liée
- (void)configureCheckboxButtonWithPriority:(NSUInteger)priority
                               forIndexPath:(NSIndexPath *)indexPath
                            inCellContainer:(UITableViewCell *)cellContainer;

@end
