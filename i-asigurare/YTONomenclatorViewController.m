//
//  YTONomenclatorViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTONomenclatorViewController.h"
#import "Database.h"
#import "QuartzCore/QuartzCore.h"

@interface YTONomenclatorViewController ()

@end

@implementation YTONomenclatorViewController
@synthesize listOfItems;
@synthesize delegate, nomenclator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // NSMutableArray * listJudete = [Database Judete];
    int rows = 0;
    int cols =0;
    for (int i=0; i<listOfItems.count; i++) {
        if (i != 0 && i%3==0)
        {
            rows++;
            cols = 0;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self 
                   action:@selector(btn_selected:)
         forControlEvents:UIControlEventTouchDown];
        KeyValueItem * categorie = (KeyValueItem *)[listOfItems objectAtIndex:i];
        [button setTitle:categorie.value forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 0;
        button.frame = CGRectMake(cols*105, rows * 80, 106, 80);
        button.tag = i;
        cols++;
        [scrollView addSubview:button];
    }
    
    [scrollView  setContentSize:CGSizeMake(320, [listOfItems count]/3 * 81)];
}

- (void)btn_selected:(id)sender
{
    int index = ((UIButton *)sender).tag;
    KeyValueItem * kv = [listOfItems objectAtIndex:index];
    
//    [self.delegate chosenIndexAfterSearch:selectedValue rowIndex:_indexPath forView:self];
    [self.delegate nomenclatorChosen:kv rowIndex:nil forView:self];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
