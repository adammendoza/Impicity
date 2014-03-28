
// Copyright © Tony Smith, 2014
// Your attention is drawn to the LICENSE file which accompanies this document



#import "ImpicityImp.h"

@implementation Imp

@synthesize impCode;
@synthesize impName;



- (void)encodeWithCoder:(NSCoder *)encoder

{
    // Write object properties to a file archive
    
    [encoder encodeObject:self.impCode forKey:@"impicty.code"];
    [encoder encodeObject:self.impName forKey:@"impicty.name"];
}


- (id)initWithCoder:(NSCoder *)decoder

{
    self = [super init];
    if (self)
    {
        // Read in object properties from file archive
        
        impCode = [decoder decodeObjectForKey:@"impicty.code"];
        impName = [decoder decodeObjectForKey:@"impicty.name"];
    }
    
    return self;
}

@end