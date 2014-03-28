
// Copyright © Tony Smith, 2014
// Your attention is drawn to the LICENSE file which accompanies this document



#import <Foundation/Foundation.h>

@interface ImpList : NSObject <NSCoding>

{
    NSMutableArray *listOfImps;
    NSInteger currentImpIndex;
}

+ (ImpList *)sharedImps;

@property (nonatomic, retain) NSMutableArray *listOfImps;
@property (assign, readwrite) NSInteger currentImpIndex;

@end