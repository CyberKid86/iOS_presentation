//
//  VE_AppSettings.m
//  ios_presentation
//
//  Created by Vasiliy Erema on 11/24/13.
//  Copyright (c) 2013 Vasil Erema. All rights reserved.
//

#warning NSCoding+Singleton

#import "VE_AppSettings.h"
#import "VE_DataBase.h"

#define kVE_AppSettingsKey @"kVE_AppSettingsKey"

@implementation VE_AppSettings

+ (VE_AppSettings *)sharedSettings
{
    static VE_AppSettings *sharedSettings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedSettings = [[[VE_DataBase sharedDataBase] data] objectForKey:kVE_AppSettingsKey];
                      if (sharedSettings == nil)
                      {
                          sharedSettings = [[self alloc] _init];
                          [[[VE_DataBase sharedDataBase] data] setObject:sharedSettings forKey:kVE_AppSettingsKey];
                      }
                  });
    return sharedSettings;
}

#pragma mark - init

- (void)setStartingValues
{
    if (_appColor == nil)
        self.appColor = [UIColor colorWithRed:127.0/255 green:127.0/255 blue:160.0/255 alpha:1];
}

- (id)_init
{
    if (self = [super init])
    {
        [self setStartingValues];
    }
    return self;
}

#pragma mark <NSCoding>

#define kVE_SettingsKey_Color                @"kVE_SettingsKey_Color"

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_appColor
                   forKey:kVE_SettingsKey_Color];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])//init couse NSObject doesn't conforms NSCoding protacol
    {
        _appColor = [decoder decodeObjectForKey:kVE_SettingsKey_Color];
        [self setStartingValues];
    }
    return self;
}

#pragma mark -

@end
