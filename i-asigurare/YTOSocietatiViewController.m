//
//  YTOSocietatiViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/21/12.
//
//

#import "YTOSocietatiViewController.h"

@interface YTOSocietatiViewController ()

@end

@implementation YTOSocietatiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Companii asigurare", @"Companii asigurare");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
