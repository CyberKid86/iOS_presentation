//
//  VE_DataBase.h
//  ios_presentation
//
//  Created by Vasiliy Erema on 11/24/13.
//  Copyright (c) 2013 Vasil Erema. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VE_DataBase : NSObject

+ (VE_DataBase *)sharedDataBase;

@property (nonatomic, readonly) NSMutableDictionary *data;

- (void)saveData;

@end
