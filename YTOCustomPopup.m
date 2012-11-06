//
//  YTOCustomPopup.m
//  i-asigurare
//
//  Created by Administrator on 10/2/12.
//
//

#import "YTOCustomPopup.h"

@implementation YTOCustomPopup

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) showAlert:(NSString *)title withMessage:(NSString *)message andImage:(UIImage *)image delegate:(UIViewController *)parentView;
{
    imgPopup.image = image;
    lblTitle.text = title;
    lblDescription.text = message;

    btnCustomAlertOK.tag = 1;
    btnCustomAlertOK = [[UIButton alloc] initWithFrame:CGRectMake(124, 239, 73, 42)];
    
    lblCustomAlertOK.frame = CGRectMake(150, 249, 42, 21);
    [lblCustomAlertOK setText:@"OK"];
    [btnCustomAlertNO setHidden:YES];
    [lblCustomAlertNO setHidden:YES];
    
    [parentView presentModalViewController:self animated:NO];
}

- (IBAction) buttonClicked:(id)sender
{
    UIButton * button = (UIButton *)sender;
    
    [self.delegate chosenButton:button];
}

@end
