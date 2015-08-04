//
//  FADataSource.h
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <stdlib.h>
#import <Foundation/Foundation.h>
#import "FATask.h"
#import "UICheckboxButton.h"
@class FATableViewController;

@interface FADataSource : NSObject <UITableViewDataSource>

////////// Propriétés //////////

//  Tableau contenant les taches.
//  Lorsque la persistance des données sera gérée,
//      le tableau sera rempli par la lecture d'un fichier.
@property (nonatomic, readonly) NSMutableArray *tasks;

@end