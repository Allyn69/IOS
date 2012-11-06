//
//  CellTarifCalatorie.m
//  i-asigurare
//
//  Created by Administrator on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellTarifCustom.h"
#import "YTOUtils.h"

@implementation CellTarifCustom

@synthesize btnComanda;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forCalatorie:(BOOL)k
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 49)];
        
        lblPrima = [[UILabel alloc] initWithFrame:CGRectMake(96, 3, 164, 42)];
        lblPrima.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblPrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
        
        lblCol1 = [[UILabel alloc] initWithFrame:CGRectMake(7, 52, 52, 21)];
        lblCol1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol1.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol1.text = @"Fransiza";
        
        imgFransiza = [[UIImageView alloc] initWithFrame:CGRectMake(27, 75, 12, 12)];
        
        lblCol2 = [[UILabel alloc] initWithFrame:CGRectMake(67, 52, 65, 21)];
        lblCol2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol2.font = [UIFont fontWithName:@"Arial" size:12];        
        lblCol2.text = @"SA Bagaje";
        
        imgSABagaje = [[UIImageView alloc] initWithFrame:CGRectMake(89, 75, 12, 12)];
        
        lblCol3 = [[UILabel alloc] initWithFrame:CGRectMake(133, 52, 89, 21)];
        lblCol3.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol3.font = [UIFont fontWithName:@"Arial" size:12];        
        lblCol3.text = @"SA Electronice";

        imgSAEEI = [[UIImageView alloc] initWithFrame:CGRectMake(162, 75, 12, 12)];
        
        lblCol4 = [[UILabel alloc] initWithFrame:CGRectMake(229, 52, 91, 21)];
        lblCol4.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol4.font = [UIFont fontWithName:@"Arial" size:12];        
        lblCol4.text = @"Acoperire Sport";
        
        imgSport = [[UIImageView alloc] initWithFrame:CGRectMake(261, 75, 12, 12)];
        
        UILabel * lblDunga = [[UILabel alloc] initWithFrame:CGRectMake(0, 69, 320, 1)];
        lblDunga.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        btnComanda = [UIButton buttonWithType:UIButtonTypeCustom];
        btnComanda.frame = CGRectMake(215, 5, 104, 40);
        [btnComanda setImage:[UIImage imageNamed:@"adauga-in-cos.png"] forState:UIControlStateNormal];
        
        UILabel * lblAlegePrima = [[UILabel alloc] initWithFrame:CGRectMake(250, 5, 65, 34)];
        lblAlegePrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12];
        [lblAlegePrima setText:@"Adauga in cos"];
        [lblAlegePrima setNumberOfLines:2];
        [lblAlegePrima setTextAlignment:UITextAlignmentCenter];
        [lblAlegePrima setBackgroundColor:[UIColor clearColor]];
        [lblAlegePrima setTextColor:[UIColor whiteColor]];
        
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
        [self.contentView addSubview:btnComanda];
        [self.contentView addSubview:lblAlegePrima];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forLocuinta:(BOOL)k
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 49)];
        
        lblPrima = [[UILabel alloc] initWithFrame:CGRectMake(96, 3, 164, 42)];
        lblPrima.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblPrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
        
        lblCol1 = [[UILabel alloc] initWithFrame:CGRectMake(7, 52, 52, 21)];
        lblCol1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol1.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol1.text = @"Fransiza";
        
        imgFransiza = [[UIImageView alloc] initWithFrame:CGRectMake(27, 75, 12, 12)];
        
        lblCol2 = [[UILabel alloc] initWithFrame:CGRectMake(67, 52, 120, 21)];
        lblCol2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol2.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol2.text = @"Acop. apa conducta";
        
        imgSABagaje = [[UIImageView alloc] initWithFrame:CGRectMake(110, 75, 12, 12)];
        
        lblCol3 = [[UILabel alloc] initWithFrame:CGRectMake(188, 52, 70, 21)];
        lblCol3.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol3.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol3.text = @"Acop. furt";
        
        imgSAEEI = [[UIImageView alloc] initWithFrame:CGRectMake(215, 75, 12, 12)];
        
        lblCol4 = [[UILabel alloc] initWithFrame:CGRectMake(250, 52, 91, 21)];
        lblCol4.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol4.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol4.text = @"Raspundere civila";
        
        imgSport = [[UIImageView alloc] initWithFrame:CGRectMake(275, 75, 12, 12)];
        
        UILabel * lblDunga = [[UILabel alloc] initWithFrame:CGRectMake(0, 69, 320, 1)];
        lblDunga.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        UIButton *btnAlegePrima = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAlegePrima.frame = CGRectMake(215, 5, 104, 40);
        [btnAlegePrima setImage:[UIImage imageNamed:@"adauga-in-cos.png"] forState:UIControlStateNormal];
        
        UILabel * lblAlegePrima = [[UILabel alloc] initWithFrame:CGRectMake(250, 5, 65, 34)];
        lblAlegePrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12];
        [lblAlegePrima setText:@"Adauga in cos"];
        [lblAlegePrima setNumberOfLines:2];
        [lblAlegePrima setTextAlignment:UITextAlignmentCenter];
        [lblAlegePrima setBackgroundColor:[UIColor clearColor]];
        [lblAlegePrima setTextColor:[UIColor whiteColor]];
        
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
        [self.contentView addSubview:btnAlegePrima];
        [self.contentView addSubview:lblAlegePrima];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    if ([value isEqualToString:@"nu"] || [value isEqualToString:@"fara"])
        imgFransiza.image = [UIImage imageNamed:@"icon-x.png"];
    else
        imgFransiza.image = [UIImage imageNamed:@"icon-check.png"];
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
