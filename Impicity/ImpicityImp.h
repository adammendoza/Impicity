
// Copyright © Tony Smith, 2014
// Your attention is drawn to the LICENSE file which accompanies this document



#import <Foundation/Foundation.h>

@interface Imp : NSObject <NSCoding>

{
    NSString *impName;
    NSString *impCode;
}

@property (nonatomic, retain) NSString *impName;
@property (nonatomic, retain) NSString *impCode;

@end