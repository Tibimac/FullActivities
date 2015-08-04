//
//  FATaskEditionViewController.h
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FADataSource.h"
@class FAAppDelegate;
@class FATableViewController;
@class FATaskEditionView;

@interface FATaskEditionViewController : UIViewController
  < UITextFieldDelegate,                // Gestion clavier lors de la saisie du nom de la tâche
    UIActionSheetDelegate,              // Gestion du choix utilisateur pour l'ajout d'une image
    UIImagePickerControllerDelegate,    // Gestion retour camera/selection image utilisateur
    UINavigationControllerDelegate >
{
    //  Référence l'objet AppDelegate de l'appli pour accéder
    //      au tableViewController et à sa tableView et à son dataSource
    FAAppDelegate *appDelegate;
    
    //  Stocke la référence vers la tableView principale pour faire les reloadData
    UITableView *tableView;
    //  Stocke la référence vers le tableau de données de la tableView pour mettre à jour les tâches lors de modifications
    FADataSource *tableViewDataSource;
    
    //  Propriété stockant l'objet FATask correspondant à la tâche en cours d'édition
    FATask *taskInEdition;
    
    //  Gestion ajout image
    UIActionSheet *choosePhotoSource;
    UIImagePickerController *imagePickerController;
    UIPopoverController *popOverControllerForImagePicker;

    //  Gestion suppression image
    UILongPressGestureRecognizer *longTouch;
    UIActionSheet *confirmDeleteImage;
}


////////// Propriétés //////////

//  Permet au TableViewController de donner l'indexPath de la tâche sélectionnée
@property (copy) NSIndexPath *indexPathTaskInEdition;

//  Accès nécessaire pour le AppDelegate
//  (voir application:willChangeStatusBarFrame: et navigationController:willShowViewController:)
@property (readonly, retain) FATaskEditionView *taskEditionView;


////////// Méthodes //////////

//  Accés pour la TaskEditionView lors de la définition des target
//      des objets UISegmentedControl
- (void)prioritySegmentDidChange;
- (void)typeSegmentDidChange;

//  Accès pour le TableViewController
- (void)loadTaskToEdit;
@end
