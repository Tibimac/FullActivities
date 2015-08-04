//
//  FATaskEditionViewController.m
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "FAAppDelegate.h"
#import "FATableViewController.h"
#import "FATaskEditionViewController.h"
#import "FATaskEditionView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FATaskEditionViewController ()

@end

@implementation FATaskEditionViewController

/* ************************************************** */
/* ----------------- Initialisation ----------------- */
/* ************************************************** */
#pragma mark - Initialisation

#pragma mark |--> Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        //  Récupération du l'objet delegate
        appDelegate = (FAAppDelegate*)[[UIApplication sharedApplication] delegate];
        //  On indique au delegate de l'application que nous sommes le controlleur de la vue d'édition
        //  Nécessaire lorsque le delegate de l'app nous appellera lors des changements de la statusBarFrame
        [appDelegate setTaskEditionViewController:self];
        
        //  Création de la vue d'édition
        _taskEditionView = [[FATaskEditionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_taskEditionView setTaskEditionViewController:self];
        [[_taskEditionView taskNameField] setDelegate:self];
        [[self view] addSubview:_taskEditionView];
        [_taskEditionView release];
        
        
        /* -------------------- Appui Long ------------------ */
        longTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongTouch:)];
        [[_taskEditionView taskImageView] addGestureRecognizer:longTouch];
        [longTouch release];
        
        return self;
    }
    else
    {
        return nil;
    }
}


#pragma mark |--> Création bouton "Camera" et OK
- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    UIBarButtonItem *addPhotoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(choosePhotoSource)];
    
    [[self navigationItem] setRightBarButtonItem:addPhotoButton animated:YES];
}





/* ************************************************** */
/* ------------------ Chargement Tâche ----------------- */
/* ************************************************** */
#pragma mark - Chargement Tâche

#pragma mark |--> Mise à jour indexPath tâche en cours d'édition
- (void)updateIndexPathTaskInEditionWithSection:(NSUInteger)section andRow:(NSUInteger)row
{
    [self setIndexPathTaskInEdition:nil];
    
    // Tableau avec les nouvelles valeurs
    NSUInteger indexes[] = {section,row};
    
    // Création d'un nouvel indexPath correspondant à la nouvelle position suite au changement de type
    [self setIndexPathTaskInEdition:[[[NSIndexPath alloc] initWithIndexes:indexes length:2] autorelease]];
}


#pragma mark |--> Création/Récupération tâche à modifier/Chargement dans la vue
- (void)loadTaskToEdit
{
    //  On accède au TableViewController pour récupérer sa tableView.
    tableView = [[[appDelegate tableViewController] tableView] retain];
    tableViewDataSource = [[tableView dataSource] retain];
    
    // Si l'index est à nil, aucune tâche sélectionnée = ajout
    if (_indexPathTaskInEdition == nil)
    {
        //  Création d'une nouvelle tâche que l'on ajoute au tableau de la source de données
        //  -1 = non définie. Le UISegmentedControl n'aura donc aucun segment de sélectionné par défaut
        taskInEdition = [[FATask alloc] initWithName:nil andPriority:-1 andType:0];
        [[[tableViewDataSource tasks] objectAtIndex:0] insertObject:taskInEdition atIndex:0];
        //  Mise à jour de l'index de la tâche courant avec les valeurs correspondant à l'index d'insertion
        //      de la nouvelle tâche
        [self updateIndexPathTaskInEditionWithSection:0 andRow:0];
        
        // Nouvelle tâche = nom vide = on sélectionne direct le champ nom pour saisir un nom
        [[_taskEditionView taskNameField] becomeFirstResponder];
    }
    else // Sinon on récupère la tâche correspondante à l'index sélectionné
    {
        //  On récupère la tâche sélectionnée
        taskInEdition = [[[[tableViewDataSource tasks] objectAtIndex:_indexPathTaskInEdition.section] objectAtIndex:_indexPathTaskInEdition.row] retain];
    }
    
    [tableView release];
    [tableViewDataSource release];
    
    //  On met à jour l'interface en fonction des valeur de la tâche
    [[_taskEditionView taskNameField] setText:[taskInEdition name]];
    [[_taskEditionView taskPrioritySegments] setSelectedSegmentIndex:[taskInEdition priority]];
    [[_taskEditionView taskTypeSegments] setSelectedSegmentIndex:[taskInEdition type]];
    [[_taskEditionView taskImageView] setImage:[taskInEdition image]];

    /// !!! Ne pas faire de release sur taskInEdition puisqu'il stocke l'objet FATask durant l'édition !!! ///
}





/* ************************************************** */
/* ----------- Modification Type/Priorité ----------- */
/* ************************************************** */
#pragma mark - Modification Type/Priorité (Action)

#pragma mark |--> Type changé
- (void)typeSegmentDidChange
{
    if ([taskInEdition type] != [[_taskEditionView taskTypeSegments] selectedSegmentIndex])
    {
        // On suprime l'objet de là où il été
        [[[tableViewDataSource tasks] objectAtIndex:_indexPathTaskInEdition.section] removeObjectAtIndex:_indexPathTaskInEdition.row];
        
        //  On enregistre le nouveau type de la tâche dans celle-ci
        [taskInEdition setType:[[_taskEditionView taskTypeSegments] selectedSegmentIndex]];
        
        [self updateIndexPathTaskInEditionWithSection:[taskInEdition type] andRow:[[[tableViewDataSource tasks] objectAtIndex:[taskInEdition type]] count]];
        
        // On ajoute l'objet dans le tableau correspondant à son nouveau type
        [[[tableViewDataSource tasks] objectAtIndex:_indexPathTaskInEdition.section] addObject:taskInEdition];
        
        [tableView reloadData];
    }
}


#pragma mark |--> Priorité changée
- (void)prioritySegmentDidChange
{
    [taskInEdition setPriority:[[_taskEditionView taskPrioritySegments] selectedSegmentIndex]];
    
    [tableView reloadData];
}





/* ************************************************** */
/* ---------------- Modification Nom ---------------- */
/* ************************************************** */
#pragma mark - Modification Nom (UITextFielDelegate)

#pragma mark |--> Début édition
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[_taskEditionView taskNameField] setTextColor:[UIColor orangeColor]];
    [[_taskEditionView taskNameField] setTextAlignment:NSTextAlignmentLeft];
    UIFont *fontNameField = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    [[_taskEditionView taskNameField] setFont:fontNameField];
}


//  Cette méthode est appellée lorsque l'édition du champ de saisi est terminée
//  Soit parceque-l'utilisateur a fait "Terminer" sur le clavier
//  Soit parce-que l'utilisateur quitte la vue d'édition
//      Le clavier disparaissant lorsqu'il quitte la vue d'édition (voir UINavigationControllerDelegate dans FAAppDelegate)
//      le texte est toujours enregistré tel que visible à l'écran lorsque l'utilisateur quitte la vue
#pragma mark |--> Fin édition
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[_taskEditionView taskNameField] setTextColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]];
    [[_taskEditionView taskNameField] setTextAlignment:NSTextAlignmentCenter];
    UIFont *fontNameField = [UIFont boldSystemFontOfSize:20];
    [[_taskEditionView taskNameField] setFont:fontNameField];
    //  Si l'utilisateur quitte la vue d'édition sans avoir validé via le clavier
    //  On enregistre quand même le texte du champ de saisi
    [[_taskEditionView taskNameField] resignFirstResponder];
    
    [taskInEdition setName:[[_taskEditionView taskNameField] text]];
    
    [self loadTaskToEdit];
    [tableView reloadData];
}


//  Cette méthode est appellée lorsque l'édition du champ de saisi est terminée
//      après que l'utilisateur est appuyé sur la touche "Terminer"
#pragma mark |--> Toucher retour validée, enregistrement nom
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[_taskEditionView taskNameField] resignFirstResponder];
    
    [taskInEdition setName:[[_taskEditionView taskNameField] text]];
    
    [self loadTaskToEdit];
    [tableView reloadData];
    
    return YES;
}





/* ************************************************** */
/* ------------- Ajout/Suppression Image ------------ */
/* ************************************************** */
#pragma mark - Ajout/Suppression Image

#pragma mark |--> Config source UIImagePicker (Action)
//  Méthode appellée par le bouton "Camera"
//  Cette méthode vérifie si il y a un appareil photo sur l'appareil
//      Si oui une ActionSheet sera affichée à l'utilisateur pour qu'il
//      choisisse à partir d'où il veut sélectionner une image
- (void)choosePhotoSource
{
    //  Masque le clavier s'il est affiché.
    //  Évite un bug graphique dans le UITextField à cause de la présence du padding
    [[_taskEditionView taskNameField] resignFirstResponder];
    
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if (status == ALAuthorizationStatusDenied)
    {
        UIAlertView *deniedPhotosAccess = [[UIAlertView alloc] initWithTitle:@"Accès non autorisé"
                                                                     message:@"FullActivities n'as pas accès\nà vos photos.\nPour l'autoriser, rendez-vous dans Réglages > Confidentialité > Photos et autorisez FullActivities."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
        [deniedPhotosAccess show];
        [deniedPhotosAccess release];
    }
    else
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            // La caméra est disponible on crée donc une ActionSheet pour demander à l'utilisateur
            //  s'il veut prendre une photo de sa bibliothèque d'images ou depuis l'appareil photo
            
            if (choosePhotoSource == nil) // On ne crée l'ActionSheet que si elle ne l'est pas déjà
            {
                choosePhotoSource = [[UIActionSheet alloc] initWithTitle:@"Ajouter une image à partir d'où ?"
                                                                delegate:self
                                                       cancelButtonTitle:@"Annuler"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Appareil Photo", @"Bibliothèque d'images", nil];
            }
            
            if ([choosePhotoSource isVisible] == NO) // On affiche l'ActionSheet que si elle ne l'est pas déjà
            {
                //  Si on est sur un iPhone l'ActionSheet s'affiche d'en bas
                if ([_taskEditionView isiPhone])
                {
                    [choosePhotoSource showInView:_taskEditionView];
                }
                else // Si on est sur un iPad, l'ActionSheet s'affiche depuis le bouton "Camera"
                {
                    [choosePhotoSource showFromBarButtonItem:[[self navigationItem] rightBarButtonItem] animated:YES];
                }
            }
        }
        else
        {
            //  Si pas de caméra dispo on configure le picker pour qu'il prenne dans la bibliothèque d'images
            //  Et on affiche le picher
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            if ([_taskEditionView isiPhone]) // Plein écran sur iPhone
            {
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            else // Dans un popoverController sur iPad
            {
                popOverControllerForImagePicker = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
                [popOverControllerForImagePicker presentPopoverFromBarButtonItem:[[self navigationItem] rightBarButtonItem]
                                                        permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        }
    }
}


//-(void)cancelImagePicker:(id)sender
//{
//    if ([_taskEditionView isiPhone])
//    {
//        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
//    }
//    else
//    {
//        [popOverControllerForImagePicker dismissPopoverAnimated:YES];
//    }
//    
//    [imagePickerController release];
//    imagePickerController = nil;
//}



#pragma mark |--> Reconnaissance touché long sur l'image
//  Méthode appellée lorsqu'on fait un appui long sur l'image
//  Cette méthode demande un validation de suppression à l'utilisateur
- (void)didLongTouch:(UILongPressGestureRecognizer*)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        if ([taskInEdition hasImage])
        {
            UIImageView *imageView = [_taskEditionView taskImageView];
            CGPoint touchPoint = [gestureRecognizer locationInView:imageView];

            if (confirmDeleteImage == nil)
            {
                confirmDeleteImage = [[UIActionSheet alloc] initWithTitle:@"Supprimer l'image ?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Annuler"
                                               destructiveButtonTitle:@"Oui"
                                                    otherButtonTitles:nil];
            }
            
            if ([confirmDeleteImage isVisible] == NO) // On affiche l'ActionSheet que si elle ne l'est pas déjà
            {
                //  Si on est sur un iPhone l'ActionSheet s'affiche d'en bas
                if ([_taskEditionView isiPhone])
                {
                    [confirmDeleteImage showInView:_taskEditionView];
                }
                else // Si on est sur un iPad, l'ActionSheet s'affiche depuis l'endroit où l'on a appuyé
                {
                    [confirmDeleteImage showFromRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) inView:[_taskEditionView taskImageView] animated:YES];
                }
            }
            
        }
    }
}


#pragma mark |--> Récupération choix utilisateur sur ActionSheet (UIActionSheetDelegate)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == choosePhotoSource)
    {
        if (buttonIndex == 0) // Appareil photo
        {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            
            // Affichage en plein écran
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else if (buttonIndex == 1) // Bibliothèque d'images
        {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            // Si iPhone affiché direct en plein écran
            if ([_taskEditionView isiPhone])
            {
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            else // Si iPad, affichage dans un popover
            {
                popOverControllerForImagePicker = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
                [popOverControllerForImagePicker presentPopoverFromBarButtonItem:[[self navigationItem] rightBarButtonItem]
                                                        permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        }
    }
    else if (actionSheet == confirmDeleteImage)
    {
        if (buttonIndex == 0)
        {
            [taskInEdition deleteImage];
            [self loadTaskToEdit];
        }
    }
}


#pragma mark |--> Récupération Image (UIImagePickerControllerDelegate)
//  Méthode appellée lorsqu'une image a été sélectionnée dans le picker
//  Cette méthode récupère l'image et l'affecte à la tâche
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [taskInEdition setImage:image];
    [self loadTaskToEdit];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //  Si on est sur un iPad et que la source n'est pas l'appareil photo
    //      il y a le popOverController à faire disparaitre en plus.
    if ( ([_taskEditionView isiPhone] == NO) && ([imagePickerController sourceType] != UIImagePickerControllerSourceTypeCamera) )
    {
        [popOverControllerForImagePicker dismissPopoverAnimated:YES];
    }
}


#pragma mark |--> Picker annulé (UIImagePickerControllerDelegate)
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([_taskEditionView isiPhone])
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
        [popOverControllerForImagePicker dismissPopoverAnimated:YES];
    }
}





/* ************************************************** */
/* --------------- Gestion Orientation -------------- */
/* ************************************************** */
#pragma mark - Gestion Orientation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_taskEditionView setViewForOrientation:[[UIApplication sharedApplication] statusBarOrientation]
                         withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
}





/* ************************************************** */
/* ----------------- Gestion Mémoire ---------------- */
/* ************************************************** */
#pragma mark - Gestion Mémoire

#pragma mark |--> Si imagePickerController = nil -> Création du UIImagePicker
//  Méthode appellée avant apparition de la vue du contrôleur d'édition
- (void)viewWillAppear:(BOOL)animated
{
    //  Si appel vient de notre TaskEditionViewController (normalement le cas mais vérif par prudence)
    if ([self isKindOfClass:[FATaskEditionViewController class]])
    {
        //  On crée le UIImagePickerController s'il n'existe pas déjà
        if (imagePickerController == nil)
        {
            imagePickerController = [[UIImagePickerController alloc] init];
            [imagePickerController setDelegate:self];
        }
    }
}


#pragma mark |--> Disparition de la vue
//  Méthode appellée après disparition de la vue du contrôleur d'édition
- (void)viewDidDisappear:(BOOL)animated
{
    UINavigationController *navController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    //  Si appel vient de notre TaskEditionViewController (normalement le cas mais vérif par prudence)
    //      et que c'est la TableView qui est affichée
    if ( ([self isKindOfClass:[FATaskEditionViewController class]]) &&
         ([[navController visibleViewController] isKindOfClass:[FATableViewController class]]) )
    {
        //  On est passé de la vue d'édition à la liste des tâches
        //  On release les objets devenu inutiles
        if (taskInEdition != nil)
        {
            [taskInEdition release];
            taskInEdition = nil;
        }
        
        if (imagePickerController != nil)
        {
            [imagePickerController release];
            imagePickerController = nil;
        }
        
        if (choosePhotoSource != nil)
        {
            [choosePhotoSource release];
            choosePhotoSource = nil;
        }
        
        if (confirmDeleteImage != nil)
        {
            [confirmDeleteImage release];
            confirmDeleteImage = nil;
        }
    }
}


#pragma mark |--> Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
