//
//  AVGContact.m
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGContact.h"

@implementation AVGContact

+ (AVGContact *)contactWithName:(NSString *)firstName andSurname:(NSString *)lastName {
    AVGContact *contact = [AVGContact new];
    if(contact){
        contact.firstName = firstName;
        contact.lastName = lastName;
    }
    return contact;
}

@end
