//
//  VE_DataBase.m
//  ios_presentation
//
//  Created by Vasiliy Erema on 11/24/13.
//  Copyright (c) 2013 Vasil Erema. All rights reserved.
//

#import "VE_DataBase.h"
#define kVE_DataKey        @"Data"
#define kVE_DataFile       @"data.plist"

@interface VE_DataBase ()
@property (nonatomic, strong) NSString *dataDirPath;
@property (nonatomic, strong) NSMutableDictionary *data;
@end

@implementation VE_DataBase

+ (VE_DataBase *)sharedDataBase
{
    static VE_DataBase *sharedDataBase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedDataBase = [[self alloc] init];
                      [sharedDataBase loadData];
                  });
    return sharedDataBase;
}

- (NSMutableDictionary *)data
{
    if (_data == nil)
        _data = [[NSMutableDictionary alloc] init];
    return _data;
}

- (NSString *)dataDirPath
{
    if (_dataDirPath == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _dataDirPath = [documentsDirectory stringByAppendingPathComponent:@"VVDataBase"];
    }
    return _dataDirPath;
}

- (NSMutableDictionary *)loadData
{
    NSString *dataPath = [self.dataDirPath stringByAppendingPathComponent:kVE_DataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    self.data = [unarchiver decodeObjectForKey:kVE_DataKey];
    [unarchiver finishDecoding];
    
    return _data;
}

- (void)saveData
{
    if (_data == nil) return;
    
    [self createDataPath];
    
    NSString *dataPath = [_dataDirPath stringByAppendingPathComponent:kVE_DataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_data forKey:kVE_DataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
}

- (void)createDataPath
{
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:_dataDirPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
}

@end
