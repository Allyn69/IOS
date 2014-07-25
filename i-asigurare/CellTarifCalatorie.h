//
//  CellTarifCalatorie.h
//  i-asigurare
//
//  Created by Stern Edi on 6/12/13.
//
//

#import <UIKit/UIKit.h>

@interface CellTarifCalatorie : UITableViewCell
{
    IBOutlet UILabel     * lblNumeProdus;
    IBOutlet UILabel     * lblSumaAsigurata;
    IBOutlet UIImageView * imgLogo;
    IBOutlet UILabel     * lblPretIntreg;
    IBOutlet UILabel     * lblPretClient;
    IBOutlet UILabel     * lblPrima;
    IBOutlet UILabel     * lblPrimaReducere;
    IBOutlet UIImageView * vodafoneLogo;
    
    
    UILabel * lblCol1;
    UILabel * lblCol2;
    UILabel * lblCol3;
    UILabel * lblCol4;
    
    IBOutlet UILabel     *      imgFransiza;
    IBOutlet UIImageView *      imgSABagaje;
    IBOutlet UIImageView *      imgSAEEI;
    IBOutlet UIImageView *      imgSport;
    UILabel              *      lblRaspCivila;
    IBOutlet UIImageView *      imgChenarIntreg;
    IBOutlet UIImageView *      imgChenarVdf;
    
}

@property (nonatomic, retain) IBOutlet UIButton * btnComanda;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forAbonatVodafone:(BOOL)k;
- (void) setNumeProdus:(NSString *)v;
- (void) setSumaAsigurata:(NSString *)v;
- (void) setLogo:(NSString *)p;
- (void) setPrima:(NSString *)p;
- (void) setPrimaReducere :(NSString *) p;
- (void) setCol1:(NSString *)value andLabel:(NSString *)label;
- (void) setCol2:(NSString *)value andLabel:(NSString *)label;
- (void) setCol3:(NSString *)value andLabel:(NSString *)label;
- (void) setCol4:(NSString *)value andLabel:(NSString *)label andVineDin:(NSString *)val;

@end
