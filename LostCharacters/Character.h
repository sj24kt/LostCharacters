//
//  Character.h
//  LostCharacters
//
//  Created by Sherrie Jones on 4/6/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Character : NSManagedObject
@property NSString *name;
@property NSString *actorName;
@property NSString *gender;
@property NSString *seatNumber;
@property NSData *imageData;
@end
