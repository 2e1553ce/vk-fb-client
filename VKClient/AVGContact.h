//
//  AVGContact.h
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

@interface AVGContact : NSObject

@property(strong,nonatomic)NSString *firstName;
@property(strong,nonatomic)NSString *lastName;

+ (AVGContact *)contactWithName:(NSString *)firstName andSurname:(NSString *)lastName;

@end
