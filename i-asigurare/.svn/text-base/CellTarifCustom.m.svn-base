//
//  CellTarifCalatorie.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 8/1/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "CellTarifCustom.h"
#import "YTOUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation CellTarifCustom

@synthesize btnComanda;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forCalatorie:(BOOL)k
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        lblNumeProdus = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 20)];
        lblNumeProdus.textColor = [UIColor whiteColor];
        lblNumeProdus.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        lblNumeProdus.backgroundColor = [UIColor clearColor];        
        // Create header view and add label as a subview
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        //    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
        gradient.colors = [NSArray arrayWithObjects:(id)[[YTOUtils colorFromHexString:ColorOrangeInchis] CGColor], (id)[[YTOUtils colorFromHexString:ColorOrange] CGColor], nil];
        [view.layer insertSublayer:gradient atIndex:0];
        //view.backgroundColor = [YTOUtils colorFromHexString:@"#e0e1e2"];
        [view addSubview:lblNumeProdus];
        [self.contentView  addSubview:view];
        
        imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22, 90, 49)];
        
        lblPrima = [[UILabel alloc] initWithFrame:CGRectMake(96, 25, 164, 42)];
        lblPrima.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblPrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
        
        lblCol1 = [[UILabel alloc] initWithFrame:CGRectMake(7, 74, 52, 21)];
        lblCol1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol1.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol1.text = @"Fransiza";
        
        imgFransiza = [[UILabel alloc] initWithFrame:CGRectMake(1, 94, 70, 14)];
        
        lblCol2 = [[UILabel alloc] initWithFrame:CGRectMake(67, 74, 65, 21)];
        lblCol2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol2.font = [UIFont fontWithName:@"Arial" size:12];        
        lblCol2.text = @"SA Bagaje";
        
        imgSABagaje = [[UIImageView alloc] initWithFrame:CGRectMake(89, 97, 12, 12)];
        
        lblCol3 = [[UILabel alloc] initWithFrame:CGRectMake(133, 74, 89, 21)];
        lblCol3.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol3.font = [UIFont fontWithName:@"Arial" size:12];        
        lblCol3.text = @"SA Electronice";

        imgSAEEI = [[UIImageView alloc] initWithFrame:CGRectMake(162, 97, 12, 12)];
        
        lblCol4 = [[UILabel alloc] initWithFrame:CGRectMake(229, 74, 91, 21)];
        lblCol4.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol4.font = [UIFont fontWithName:@"Arial" size:12];        
        lblCol4.text = @"Acoperire Sport";
        
        imgSport = [[UIImageView alloc] initWithFrame:CGRectMake(261, 97, 12, 12)];
        
        UILabel * lblDunga = [[UILabel alloc] initWithFrame:CGRectMake(0, 91, 320, 1)];
        lblDunga.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        UILabel * lblDunga2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 1)];
        lblDunga2.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        btnComanda = [UIButton buttonWithType:UIButtonTypeCustom];
        btnComanda.frame = CGRectMake(215, 27, 104, 40);
        [btnComanda setImage:[UIImage imageNamed:@"adauga-in-cos.png"] forState:UIControlStateNormal];
        
        UILabel * lblAlegePrima = [[UILabel alloc] initWithFrame:CGRectMake(250, 27, 65, 34)];
        lblAlegePrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12];
        [lblAlegePrima setText:@"Adauga in cos"];
        [lblAlegePrima setNumberOfLines:2];
        [lblAlegePrima setTextAlignment:UITextAlignmentCenter];
        [lblAlegePrima setBackgroundColor:[UIColor clearColor]];
        [lblAlegePrima setTextColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:lblNumeProdus];
        [self.contentView addSubview:imgLogo];
        [self.contentView addSubview:lblPrima];
        [self.contentView addSubview:lblCol1];
        [self.contentView addSubview:imgFransiza];
        [self.contentView addSubview:lblCol2];
        [self.contentView addSubview:imgSABagaje];
        [self.contentView addSubview:lblCol3];
        [self.contentView addSubview:imgSAEEI];
        [self.contentView addSubview:lblCol4];
        [self.contentView addSubview:imgSport];
        [self.contentView addSubview:lblDunga];
        [self.contentView addSubview:lblDunga2];
        [self.contentView addSubview:btnComanda];
        [self.contentView addSubview:lblAlegePrima];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forLocuinta:(BOOL)k
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        lblNumeProdus = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 20)];
        lblNumeProdus.textColor = [UIColor whiteColor];
        lblNumeProdus.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        lblNumeProdus.backgroundColor = [UIColor clearColor];
        // Create header view and add label as a subview
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        //    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
        gradient.colors = [NSArray arrayWithObjects:(id)[[YTOUtils colorFromHexString:ColorAlbastruInchis] CGColor], (id)[[YTOUtils colorFromHexString:ColorAlbastru] CGColor], nil];
        [view.layer insertSublayer:gradient atIndex:0];
        //view.backgroundColor = [YTOUtils colorFromHexString:@"#e0e1e2"];
        [view addSubview:lblNumeProdus];
        [self.contentView  addSubview:view];
        
        imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22, 90, 49)];
        
        lblPrima = [[UILabel alloc] initWithFrame:CGRectMake(96, 25, 164, 42)];
        lblPrima.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblPrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
        
        lblCol1 = [[UILabel alloc] initWithFrame:CGRectMake(7, 74, 52, 21)];
        lblCol1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol1.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol1.text = @"Fransiza";
        
        imgFransiza = [[UILabel alloc] initWithFrame:CGRectMake(1, 94, 70, 14)];
        
        lblCol2 = [[UILabel alloc] initWithFrame:CGRectMake(67, 74, 120, 21)];
        lblCol2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol2.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol2.text = @"Acop. apa conducta";
        
        imgSABagaje = [[UIImageView alloc] initWithFrame:CGRectMake(110, 97, 12, 12)];
        
        lblCol3 = [[UILabel alloc] initWithFrame:CGRectMake(188, 74, 70, 21)];
        lblCol3.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol3.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol3.text = @"Acop. furt";
        
        imgSAEEI = [[UIImageView alloc] initWithFrame:CGRectMake(215, 97, 12, 12)];
        
        lblCol4 = [[UILabel alloc] initWithFrame:CGRectMake(250, 74, 91, 21)];
        lblCol4.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol4.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol4.text = @"Raspundere civila";
        
        imgSport = [[UIImageView alloc] initWithFrame:CGRectMake(275, 97, 12, 12)];
        
        UILabel * lblDunga2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 1)];
        lblDunga2.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        UILabel * lblDunga = [[UILabel alloc] initWithFrame:CGRectMake(0, 91, 320, 1)];
        lblDunga.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        btnComanda = [UIButton buttonWithType:UIButtonTypeCustom];
        btnComanda.frame = CGRectMake(215, 27, 104, 40);
        [btnComanda setImage:[UIImage imageNamed:@"adauga-in-cos.png"] forState:UIControlStateNormal];
        
        UILabel * lblAlegePrima = [[UILabel alloc] initWithFrame:CGRectMake(250, 27, 65, 34)];
        lblAlegePrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12];
        [lblAlegePrima setText:@"Adauga in cos"];
        [lblAlegePrima setNumberOfLines:2];
        [lblAlegePrima setTextAlignment:UITextAlignmentCenter];
        [lblAlegePrima setBackgroundColor:[UIColor clearColor]];
        [lblAlegePrima setTextColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:lblNumeProdus];
        [self.contentView addSubview:imgLogo];
        [self.contentView addSubview:lblPrima];
        [self.contentView addSubview:lblCol1];
        [self.contentView addSubview:imgFransiza];
        [self.contentView addSubview:lblCol2];
        [self.contentView addSubview:imgSABagaje];
        [self.contentView addSubview:lblCol3];
        [self.contentView addSubview:imgSAEEI];
        [self.contentView addSubview:lblCol4];
        [self.contentView addSubview:imgSport];
        [self.contentView addSubview:lblDunga];
        [self.contentView addSubview:lblDunga2];
        [self.contentView addSubview:btnComanda];
        [self.contentView addSubview:lblAlegePrima];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setNumeProdus:(NSString *)v
{
    lblNumeProdus.text = v;
}

- (void) setLogo:(NSString *)p
{
    imgLogo.image = [UIImage imageNamed:p];
}

- (void) setPrima:(NSString *)p
{
    lblPrima.text = p;
}

- (void) setCol1:(NSString *)value andLabel:(NSString *)label
{
    imgFransiza.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:10];
    imgFransiza.textAlignment = NSTextAlignmentCenter;
    if ([value isEqualToString:@"nu"] || [value isEqualToString:@"fara"])
    {
        imgFransiza.textColor = [YTOUtils colorFromHexString:@"#52a03f"];
        //imgFransiza.image = [UIImage imageNamed:@"icon-nu.png"];
    }
    else
    {
        imgFransiza.textColor = [YTOUtils colorFromHexString:@"#cf2929"];        
        //imgFransiza.image = [UIImage imageNamed:@"icon-da.png"];
    }
    imgFransiza.text = value;
    lblCol1.text = label;
}
- (void) setCol2:(NSString *)value andLabel:(NSString *)label
{
    if ([value isEqualToString:@"nu"] || [value isEqualToString:@"fara"])
        imgSABagaje.image = [UIImage imageNamed:@"icon-x.png"];
    else
        imgSABagaje.image = [UIImage imageNamed:@"icon-check.png"];
    lblCol2.text = label;
}
- (void) setCol3:(NSString *)value andLabel:(NSString *)label
{
    if ([value isEqualToString:@"nu"] || [value isEqualToString:@"fara"])
        imgSAEEI.image = [UIImage imageNamed:@"icon-x.png"];
    else
        imgSAEEI.image = [UIImage imageNamed:@"icon-check.png"];
    lblCol3.text = label;
}
- (void) setCol4:(NSString *)value andLabel:(NSString *)label
{
    if ([value isEqualToString:@"nu"] || [value isEqualToString:@"fara"] || [value isEqualToString:@"0"])
        imgSport.image = [UIImage imageNamed:@"icon-x.png"];
    else
        imgSport.image = [UIImage imageNamed:@"icon-check.png"];
    lblCol4.text = label;
}

@end
