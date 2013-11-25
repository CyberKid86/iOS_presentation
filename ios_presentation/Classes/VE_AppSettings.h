//
//  VE_AppSettings.h
//  ios_presentation
//
//  Created by Vasiliy Erema on 11/24/13.
//  Copyright (c) 2013 Vasil Erema. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VE_AppSettings : NSObject <NSCoding>

+ (VE_AppSettings *)sharedSettings;

@property (nonatomic, strong) UIColor   *appColor;
@end
