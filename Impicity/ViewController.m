
// Copyright © Tony Smith, 2014
// Your attention is drawn to the LICENSE file which accompanies this document


#import "ViewController.h"

@interface ViewController ()


// Define Constants

#define imp_url_string @"https://agent.electricimp.com/"
#define imp_command_get_mode @"?getmode="
#define imp_command_set_mode @"?setmode="
#define imp_command_set_bright @"?bright="
#define imp_command_set_message @"?message="
#define imp_command_set_inverse @"&inv=1"
#define imp_command_unset_inverse @"&inv=0"


@end


@implementation ViewController


#pragma mark Application Life Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialise object properties
    
	receivedData = [NSMutableData dataWithCapacity: 0];
    statusLabel.text = @" ";
    
    keypadFlag = NO;
    sendFlag = NO;
    invFlag = NO;
    qryFlag = NO;
    messageType = 0;
    
    // Access singleton imp storage
    
    myImps = [ImpList sharedImps];
    
    // Load in default imp list if the file has already been saved
    
    NSArray *docsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [docsDir objectAtIndex:0];
    docsPath = [docsPath stringByAppendingPathComponent :@"imps"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:docsPath])
    {
        // If imps file is present, load it in
        
        ImpList *impz =[NSKeyedUnarchiver unarchiveObjectWithFile:docsPath];
        [myImps.listOfImps removeAllObjects];
        [myImps.listOfImps addObjectsFromArray:impz.listOfImps];
        myImps.currentImpIndex = impz.currentImpIndex;
    }
    
    // Register the VC as an observer of app closure event notifications
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(saveImps:)
               name:UIApplicationDidEnterBackgroundNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(saveImps:)
               name:UIApplicationWillTerminateNotification
             object:nil];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // If we have imps listed, and one selected, get clock mode data from it
    
    qryFlag = NO;
    if (myImps.currentImpIndex != -1) [self getMode];
    
    // Name the current imp in the UI
    
    if (myImps.currentImpIndex != -1)
    {
        Imp *imp = [myImps.listOfImps objectAtIndex:myImps.currentImpIndex];
        currentImpLabel.text = imp.impName;
    }
    else
    {
        currentImpLabel.text = @"Select an imp to use";
    }
    
    // Clear message readout
    
    statusLabel.text = @" ";
}



- (void)saveImps:(NSNotification *)note
{
    // The app is going into the background or closing, so save the list of imps
    
    NSArray *docsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [docsDir objectAtIndex:0];
    docsPath = [docsPath stringByAppendingPathComponent :@"imps"];
    
    bool success = [NSKeyedArchiver archiveRootObject:myImps toFile:docsPath];
    if (!success) NSLog(@"Imp list save failed");
}



#pragma mark Digital Clock Methods


- (void)getMode
{
    qryFlag = YES;
    Imp *imp = [myImps.listOfImps objectAtIndex:myImps.currentImpIndex];
    NSString *urlString = [[imp_url_string stringByAppendingString:imp.impCode] stringByAppendingString:imp_command_get_mode];
    [self makeConnection:urlString];
}



- (IBAction)modeSwitcher:(id)sender

{
    bool modeFlag = modeSwitch.on;
    NSString *modeString;
    
    if (modeFlag)
    {
        modeLabel.text = @"24HR";
        modeString = @"24";
    }
    else
    {
        modeLabel.text = @"AM/PM";
        modeString = @"12";
    }
    
    Imp *imp = [myImps.listOfImps objectAtIndex:myImps.currentImpIndex];
    NSString *urlString = [[imp_url_string stringByAppendingString:imp.impCode] stringByAppendingString:imp_command_set_mode];
    urlString = [urlString stringByAppendingString:modeString];
    [self makeConnection:urlString];
}



- (IBAction)setBrightness:(id)sender

{
    NSInteger i = (NSInteger)round(brightSlider.value);
    [brightSlider setValue:(float)i animated:NO];
    
    Imp *imp = [myImps.listOfImps objectAtIndex:myImps.currentImpIndex];
    NSString *urlString = [[imp_url_string stringByAppendingString:imp.impCode] stringByAppendingString:imp_command_set_bright];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)i]];
    [self makeConnection:urlString];
}



#pragma mark Messaging Methods


- (IBAction)inverseSwitcher:(id)sender
{
    invFlag = invSwitch.on;
}



- (IBAction)sendMessage:(id)sender
{
    if ([messageField.text length] == 0) return;
    messageType = 255;
    Imp *imp = [myImps.listOfImps objectAtIndex:myImps.currentImpIndex];
    NSString *urlString = [[imp_url_string stringByAppendingString:imp.impCode] stringByAppendingString:imp_command_set_message];
    NSString *string = [[messageField.text copy] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    urlString = [urlString stringByAppendingString:string];
    
    if (invFlag)
    {
        urlString = [urlString stringByAppendingString:imp_command_set_inverse];
    }
    else
    {
        urlString = [urlString stringByAppendingString:imp_command_unset_inverse];
    }
    
    [self makeConnection:urlString];
}



#pragma mark Connection Methods


- (void)makeConnection:(NSString *)urlString
{
    [self setConnection:[NSURL URLWithString:urlString]];
}



- (void)setConnection:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:60.0];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!conn)
    {
        // Zero connection objects
        
        receivedData = nil;
        conn = nil;
        
        // Inform the user that the connection failed.
        
        statusLabel.text = @"Couldn't connect to the Agent";
    }
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (!receivedData) receivedData = [NSMutableData dataWithCapacity:0];
    [receivedData setLength:0];
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Received %lu bytes of data", (unsigned long)[receivedData length]);
    
    if (receivedData)
    {
        if (qryFlag)
        {
            qryFlag = NO;
            NSInteger value = [[[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding] integerValue];
            if (value == 24)
            {
                [modeSwitch setOn:YES animated:NO];
                modeLabel.text = @"24HR";
            }
            else
            {
                [modeSwitch setOn:NO animated:NO];
                modeLabel.text = @"AM/PM";
            }
        }
        else
        {
            statusLabel.text = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
        }
    }
    else
    {
        statusLabel.text = @" ";
    }
    
    // End connection
    
    [conn cancel];
    receivedData = nil;
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Inform the user of the failure
    
    statusLabel.text = [NSString stringWithFormat:@"Connection failed! Error: %@", [error localizedDescription]];
}



#pragma mark Segue Methods


- (IBAction)returned:(UIStoryboardSegue *)segue
{
    // NOP
}



#pragma mark Keyboard Methods


- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event
{
    // keypadFlag is set when the keypad appears to ensure other controls
    // are temporarily de-activated - by ignoring them if this flag is YES
	
    sendFlag = NO;
    keypadFlag = NO;
    
    // Resign first responder status to remove the keypad
    
    for (UIView* view in self.view.subviews)
    {
		if ([view isKindOfClass:[UITextField class]]) [view resignFirstResponder];
    }
}



# pragma mark TextField Delegate Methods


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // keypadFlag is set when the keypad appears to ensure other controls
    // are temporarily de-activated - by ignoring them
    
    keypadFlag = YES;
    sendFlag = NO;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    sendFlag = YES;
    [textField resignFirstResponder];
    return sendFlag;
}



- (void)textFieldDidEndEditing:(UITextField *)textField

{
    if (sendFlag == YES) [self sendMessage:sendButton];
    keypadFlag = NO;
    sendFlag = NO;
}


@end