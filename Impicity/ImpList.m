
// Copyright © Tony Smith, 2014
// Your attention is drawn to the LICENSE file which accompanies this document



#import "ImpList.h"

static ImpList *sharedImps = nil;

@implementation ImpList

@synthesize currentImpIndex;
@synthesize listOfImps;


#pragma mark Singleton Methods


- (id)init

{
    self = [super init];
    if (self)
    {
        // Initialise singleton properties
        
        listOfImps = [[NSMutableArray alloc] init];
        currentImpIndex = -1;
    }
    return self;
}



+ (ImpList *)sharedImps

{
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ if (sharedImps == nil) sharedImps = [[self alloc] init];});
    return sharedImps;
}



#pragma mark NSCoder Methods


- (void)encodeWithCoder:(NSCoder *)encoder

{
    // Write object properties to a file archive
    
    [encoder encodeInteger:self.currentImpIndex forKey:@"impicity.current.index"];
    [encoder encodeObject:self.listOfImps forKey:@"impicty.list"];
}



- (id)initWithCoder:(NSCoder *)decoder

{
    self = [super init];
    if (self)
    {
        // Read in object properties from archive file
        
        currentImpIndex = [decoder decodeIntegerForKey:@"impicity.current.index"];
        listOfImps = [decoder decodeObjectForKey:@"impicty.list"];
    }
    
    return self;
}


@end