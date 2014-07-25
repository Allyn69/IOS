//
//  CellTarifCalatorie.m
//  i-asigurare
//
//  Created by Stern Edi on 6/12/13.
//
//

#import "CellTarifCalatorie.h"
#import "YTOUtils.h"
#import "YTOUserDefaults.h"
#import <QuartzCore/QuartzCore.h>

@interface CellTarifCalatorie ()

@end

@implementation CellTarifCalatorie
@synthesize btnComanda;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forAbonatVodafone:(BOOL)k
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        lblNumeProdus = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
        lblNumeProdus.textColor = [UIColor whiteColor];
        lblNumeProdus.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        lblNumeProdus.backgroundColor = [UIColor clearColor];
        lblSumaAsigurata = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 150, 20)] ;
        lblSumaAsigurata.textColor = [UIColor whiteColor];
        lblSumaAsigurata.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        lblSumaAsigurata.backgroundColor = [UIColor clearColor];
        // Create header view and add label as a subview
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[YTOUtils colorFromHexString:ColorOrangeInchis] CGColor], (id)[[YTOUtils colorFromHexString:ColorOrange] CGColor], nil];
        [view.layer insertSublayer:gradient atIndex:0];
        [view addSubview:lblNumeProdus];
        [self.contentView  addSubview:view];
        
        imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(14, 27, 90, 49)];
        
        vodafoneLogo =[[UIImageView alloc] initWithFrame:CGRectMake(238, 57, 58, 11)];
        
        lblPretIntreg = [[UILabel alloc] initWithFrame:CGRectMake(140, 31, 57, 33)];
        lblPretIntreg.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblPretIntreg.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        [lblPretIntreg setNumberOfLines:2];
        lblPretIntreg.textAlignment = UITextAlignmentCenter;
        lblPretIntreg.text = @"Pret intreg";
        
        lblPretClient = [[UILabel alloc] initWithFrame:CGRectMake(229, 29, 77, 40)];
        lblPretClient.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblPretClient.numberOfLines = 2;
        lblPretClient.textAlignment = NSTextAlignmentCenter;
        lblPretClient.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        lblPretClient.text = @"Pret client\nVodafone";
        
        imgChenarIntreg = [[UIImageView alloc] initWithFrame:CGRectMake(119, 20, 100, 106)];
        imgChenarVdf = [[UIImageView alloc] initWithFrame:CGRectMake(220, 20, 100, 106)];
        UIImage *img = [UIImage imageNamed:@"chenar-rosu.png"];
        imgChenarIntreg.image = img;
        imgChenarVdf.image = img;
        
        lblPrima = [[UILabel alloc] initWithFrame:CGRectMake(124, 87, 89, 30)];
        lblPrima.textColor = [YTOUtils colorFromHexString:@"#00A300"];
        lblPrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:18];
        
        lblPrimaReducere = [[UILabel alloc] initWithFrame:CGRectMake(223, 87, 89, 30)];
        lblPrimaReducere.textColor = [YTOUtils colorFromHexString:@"#00A300"];
        lblPrimaReducere.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:18];
        lblPrimaReducere.textAlignment = UITextAlignmentCenter;
        
        lblCol1 = [[UILabel alloc] initWithFrame:CGRectMake(7, 129, 57, 21)];
        lblCol1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol1.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol1.text = @"Fransiza";
        
        imgFransiza = [[UILabel alloc] initWithFrame:CGRectMake(1, 152, 70, 14)];
        //imgFransiza = [[UILabel alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        lblCol2 = [[UILabel alloc] initWithFrame:CGRectMake(67, 129, 65, 21)];
        lblCol2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol2.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol2.text = @"SA Bagaje";
        
        imgSABagaje = [[UIImageView alloc] initWithFrame:CGRectMake(89, 152, 12, 12)];
        
        lblCol3 = [[UILabel alloc] initWithFrame:CGRectMake(133, 129, 89, 21)];
        lblCol3.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol3.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol3.text = @"SA Electronice";
        
        imgSAEEI = [[UIImageView alloc] initWithFrame:CGRectMake(162, 152, 12, 12)];
        
        lblCol4 = [[UILabel alloc] initWithFrame:CGRectMake(229, 129, 91, 21)];
        lblCol4.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblCol4.font = [UIFont fontWithName:@"Arial" size:12];
        lblCol4.text = @"Acoperire Sport";
        
        if (k)
        {
            lblPretIntreg.textColor =[YTOUtils colorFromHexString:@"#a2a2a2"];
            lblPrima.textColor = [YTOUtils colorFromHexString:@"#a2a2a2"];
        }else{
            lblPretClient.textColor = [YTOUtils colorFromHexString:@"#a2a2a2"];
            lblPrimaReducere.textColor = [YTOUtils colorFromHexString:@"#a2a2a2"];
        }
        
        imgSport = [[UIImageView alloc] initWithFrame:CGRectMake(261, 152, 12, 12)];
        
        UILabel * lblDunga = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 320, 1)];
        lblDunga.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        UILabel * lblDunga2 = [[UILabel alloc] initWithFrame:CGRectMake(117, 20, 1, 106)];
        lblDunga2.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        UILabel * lblDunga3 = [[UILabel alloc] initWithFrame:CGRectMake(220, 20,1, 106)];
        lblDunga3.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        UILabel * lblDunga4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 1)];
        lblDunga4.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        UILabel * lblDunga5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 149, 320, 1)];
        lblDunga5.backgroundColor = [YTOUtils colorFromHexString:@"#dcdcdc"];
        
        btnComanda = [UIButton buttonWithType:UIButtonTypeCustom];
        btnComanda.frame = CGRectMake(7, 79, 104, 40);
        [btnComanda setImage:[UIImage imageNamed:@"adauga-in-cos.png"] forState:UIControlStateNormal];
        
        UILabel * lblAlegePrima = [[UILabel alloc] initWithFrame:CGRectMake(46, 79, 65, 34)];
        lblAlegePrima.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12];
        [lblAlegePrima setText:NSLocalizedStringFromTable(@"i581", [YTOUserDefaults getLanguage],@"Adauga in cos")];
        [lblAlegePrima setNumberOfLines:2];
        [lblAlegePrima setTextAlignment:NSTextAlignmentCenter];
        [lblAlegePrima setBackgroundColor:[UIColor clearColor]];
        [lblAlegePrima setTextColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:lblNumeProdus];
        [self.contentView addSubview:lblPretClient];
        [self.contentView addSubview:lblPretIntreg];
        [self.contentView addSubview:lblPrimaReducere];
        [self.contentView addSubview:lblDunga3];
        [self.contentView addSubview:lblDunga4];
        [self.contentView addSubview:lblSumaAsigurata];
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
        [self.contentView addSubview:lblDunga5];
        [self.contentView addSubview:btnComanda];
        [self.contentView addSubview:lblAlegePrima];
        [self.contentView addSubview:vodafoneLogo];
        
        if (k)
        {
            [self.contentView addSubview:imgChenarVdf];
        }else{
            [self.contentView addSubview:imgChenarIntreg];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setSumaAsigurata : (NSString *) v
{
    lblSumaAsigurata.text = v;
}

- (void) setNumeProdus:(NSString *)v
{
    lblNumeProdus.text = v;
}

- (void) setPrimaReducere:(NSString *)p
{
    lblPrimaReducere.text = p;
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
    if ([value isEqualToString:@"nu"] || [value isEqualToString:@"fara"] || [value isEqualToString:@"0"])
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
- (void) setCol4:(NSString *)value andLabel:(NSString *)label andVineDin:(NSString *)val
{
    lblRaspCivila.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:10];
    lblRaspCivila.backgroundColor = [UIColor clearColor];
    lblRaspCivila.text = @"";
    if ([val isEqualToString:@"Calatorie"]) {
        
        if ([value isEqualToString:@"nu"] || [value isEqualToString:@"fara"] || [value isEqualToString:@"0"])
            imgSport.image = [UIImage imageNamed:@"icon-x.png"];
        else
            imgSport.image = [UIImage imageNamed:@"icon-check.png"];
    }
    else {
        if ([value isEqualToString:@"nu"] || [value isEqualToString:@"fara"] || [value isEqualToString:@"0"]) {
            
            //lblRaspCivila.textColor = [YTOUtils colorFromHexString:@"#cf2929"];
            imgSport.image = [UIImage imageNamed:@"icon-x.png"];
            [imgSport setHidden:NO];
        }
        else {
            [imgSport setHidden:YES];
            lblRaspCivila.textColor = [YTOUtils colorFromHexString:@"#52a03f"];
            lblRaspCivila.text = [NSString stringWithFormat:@"%@ EUR",value];
        }
    }
    lblCol4.text = label;
}

@end
