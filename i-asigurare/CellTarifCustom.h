//
//  CellTarifCalatorie.h
//  i-asigurare
//
//  Created by Administrator on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellTarifCustom : UITableViewCell
{
    IBOutlet UIImageView *  imgLogo;
    IBOutlet UILabel *      lblPrima;
    
    UILabel * lblCol1;
    UILabel * lblCol2;
    UILabel * lblCol3;
    UILabel * lblCol4;
    
    IBOutlet UIImageView *      imgFransiza;
    IBOutlet UIImageView *      imgSABagaje;
    IBOutlet UIImageView *      imgSAEEI;
    IBOutlet UIImageView *      imgSport;
}

@property (nonatomic, retain) IBOutlet UIButton * btnComanda;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forCalatorie:(BOOL)k;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forLocuinta:(BOOL)k;

- (void) setLogo:(NSString *)p;
- (void) setPrima:(NSString *)p;
- (void) setCol1:(NSString *)value andLabel:(NSString *)label;
- (void) setCol2:(NSString *)value andLabel:(NSString *)label;
- (void) setCol3:(NSString *)value andLabel:(NSString *)label;
- (void) setCol4:(NSString *)value andLabel:(NSString *)label;

@end
