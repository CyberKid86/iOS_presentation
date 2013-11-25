//
//  VE_DownloadManager.h
//  ios_presentation
//
//  Created by Vasiliy Erema on 11/24/13.
//  Copyright (c) 2013 Vasil Erema. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DownloadComplitionBlock)(NSData *downloadedData);

@interface VE_DownloadManager : NSObject

+ (id)sharedInstance;

- (void)downloadDataWithURLString:(NSString *)dataUrlString
                       usingCache:(BOOL)usingCache
               andComplitionBlock:(DownloadComplitionBlock)block;

- (void)clearCache;

@end
