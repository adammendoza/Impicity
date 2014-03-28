
// Copyright © Tony Smith, 2014
// Your attention is drawn to the LICENSE file which accompanies this document



#import "ImpIDViewController.h"

@interface ImpIDViewController ()

@end

@implementation ImpIDViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register interest in notification of imp details coming from ImpTableViewController
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(changeDetails:)
               name:@"impicity.imp.details.tochange"
             object:nil];
}



- (void)changeDetails:(NSNotification *)note
{
    // When a notification from ImpTableViewController arrives, update the UI with the imp's details
    
    NSDictionary *dict = note.userInfo;
    nameField.text = [dict objectForKey:@"imp.name"];
    codeField.text = [dict objectForKey:@"imp.code"];
}



#pragma mark Keyboard Methods


- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event

{
    for (UIView* view in self.view.subviews)
    {
		if ([view isKindOfClass:[UITextField class]]) [view resignFirstResponder];
    }
}



#pragma mark Text Field Delegate Methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - Navigation Methods


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Before unwinding the segue to go back to ImpTableViewController,
    //  send a 'details changed' notification with the new details
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:nameField.text, codeField.text, nil] forKeys:[NSArray arrayWithObjects:@"imp.name", @"imp.code", nil]];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"impicity.imp.details.changed" object:self userInfo:dict];
}


@end