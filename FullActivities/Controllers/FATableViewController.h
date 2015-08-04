//
//  FATableViewController.h
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FADataSource.h"
#import "FATaskEditionView.h"
#import "FATaskEditionViewController.h"

@interface FATableViewController : UITableViewController <UITableViewDelegate>
{
    //  Permet au TableViewController de lancer le alloc/init
    //      du TaskEditionViewController
    //  Puis de setter sa propriété indexPathTaskToEdit lorsqu'une
    //      tâche est sélectionnée ou lors de l'ajout d'une tâche
    FATaskEditionViewController *taskEditionViewController;
    
    // Source de données de la TableView
    FADataSource *dataSource;
}


////////// Méthodes //////////

- (void)checkboxDidClicked:(id)sender;

@end