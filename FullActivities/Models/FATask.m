 //
//  FATask.m
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "FATask.h"

@implementation FATask

/* ************************************************** */
/* ----------------- Initialisation ----------------- */
/* ************************************************** */
#pragma mark - Initialisation

- (instancetype)initWithName:(NSString *)name
                 andPriority:(NSUInteger)priority
                     andType:(TypeTache)type
{
    self = [super init];
    
    if (self)
    {
        // Utilisation du setter dédié pour que la copy soit faite (cf @property du .h)
        [self setName:name];
        // Types scalaires, assign de base
        _isFinish = NO;
        _priority = priority;
        _type = type;
        _hasImage = NO;
        // Assignation à nil, pas besoin de setter dédié
        _image = nil;
    }

    return  self;
}





/* ************************************************** */
/* ------------- Ajout/Suppression Image ------------ */
/* ************************************************** */
#pragma mark - Ajout/Suppression Image

//  Méthode appellée lors de l'affectation d'un objet UIImage à _image
//  Cette méthode affecte l'image à _image et met hasImage à YES
-(void)setImage:(UIImage *)newImage
{
    if (newImage != _image) // Si (UIImage *)newImage différent de (UIImage *)_image = nouvel objet UIImage
    {
        if (_image != nil) // S'il y avait une image on release l'objet UIImage lié à _image
        {
            [_image release];
        }
        
        if (newImage == nil) // Si nil = pas d'image = hasImage à NO
        {
            _image = nil;
            _hasImage = NO;
        }
        else // Il faut "attacher une laisse" à l'image qu'on nous envoi -> retain
        {
            _image = [newImage retain];
            _hasImage = YES;
        }
    }
    // Sinon on ne fait rien car UIImage *)newImage et (UIImage *)_image pointent sur le même objet (peut être nil)
}


//  Méthode appellée lors de la suppression de la photo
//  Cette méthode release l'objet UIImage retenu par _image,
//      repasse le pointeur à nil et met hasImage à NO
-(void)deleteImage
{
    if (_image == nil)
    {
        //  Si _image est déja à nil passe simplement hasImage à NO
        //      par prudence bien qu'elle soit déja à NO normalement
        _hasImage = NO;
    }
    else
    {
        //  Sinon on release l'objet retenu par _image
        //      on passe _image à nil et hasimage à NO
        [_image release];
        _image = nil;
        _hasImage = NO;
    }
}





/* ************************************************** */
/* ----------------- Gestion Mémoire ---------------- */
/* ************************************************** */
#pragma mark - Gestion Mémoire

-(void)dealloc
{
    [_name release];
    [self setName:nil];
    
    if (_hasImage)
    {
        [self deleteImage];
    }
    
    [super dealloc];
}
@end
