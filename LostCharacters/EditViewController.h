//
//  EditViewController.h
//  LostCharacters
//
//  Created by Sherrie Jones on 4/6/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EditViewController : UIViewController
@property NSManagedObjectContext *moc;
@property NSManagedObject *selectedCharacter;
@end
