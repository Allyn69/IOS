//
//  CellTarifRCARedus.m
//  i-asigurare
//
//  Created by Stern Edi on 10/17/13.
//
//

#import "CellTarifRCARedus.h"
#import "YTOUtils.h"
#import "YTOUserDefaults.h"
#import <QuartzCore/QuartzCore.h>

@implementation CellTarifRCARedus



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withReducere:(BOOL)red 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 90, 49)];
        lblPrima = [[UILabel alloc] initWithFrame:CGRectMake(89, 8, 125, 22)];
        lblPrima.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblPrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
        lblPrima.textAlignment = NSTextAlignmentCenter;
        
        lblPrimaReducere = [[UILabel alloc] initWithFrame:CGRectMake(91, 37, 125, 22)];
        lblPrimaReducere.textColor = [YTOUtils colorFromHexString:rosuProfil];
        lblPrimaReducere.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:19];
        lblPrimaReducere.textAlignment = NSTextAlignmentCenter;
        
        lblStrike = [[UILabel alloc] initWithFrame:CGRectMake(115, 19, 76, 1)];
        lblStrike.textColor = [YTOUtils colorFromHexString:rosuProfil];
        lblStrike.backgroundColor =[YTOUtils colorFromHexString:rosuProfil];
        lblStrike.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:1];
        
        lblAlegePrima = [[UILabel alloc] initWithFrame:CGRectMake(250, 18, 65, 34)];
        lblAlegePrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12];
        [lblAlegePrima setText:NSLocalizedStringFromTable(@"i581", [YTOUserDefaults getLanguage],@"Adauga in cos")];
        [lblAlegePrima setNumberOfLines:2];
        [lblAlegePrima setTextAlignment:NSTextAlignmentCenter];
        [lblAlegePrima setBackgroundColor:[UIColor clearColor]];
        [lblAlegePrima setTextColor:[UIColor whiteColor]];

        lblClasaBM = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, 89, 20)];
        lblClasaBM.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblClasaBM.font = [UIFont fontWithName:@"Arial" size:12];
        lblClasaBM.textAlignment = NSTextAlignmentCenter;
        
        btnComanda = [[UIImageView alloc] initWithFrame:CGRectMake(216, 15, 104, 40)];
        btnComanda.image = [UIImage imageNamed:@"adauga-in-cos.png"];

        
        [self.contentView addSubview:imgLogo];
        [self.contentView addSubview:lblPrima];
        [self.contentView addSubview:lblClasaBM];
        [self.contentView addSubview:btnComanda];
        [self.contentView addSubview:lblAlegePrima];
        [self.contentView addSubview:lblPrimaReducere];
        [self.contentView addSubview:lblStrike];
    }
    return self;
}

- (void) setPrima:(NSString *)v
{
    lblPrima.text = v;
}

- (void) setPrimaReducere:(NSString *)v
{
    lblPrimaReducere.text = v;
}

- (void) setClasaBM:(NSString *)p
{
    lblClasaBM.text = [NSString stringWithFormat:@"Clasa B\\M: %@",p];
}

- (void) setLogo:(NSString *)p
{
    imgLogo.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",p]];
}

@end
