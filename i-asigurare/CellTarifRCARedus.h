//
//  CellTarifRCARedus.h
//  i-asigurare
//
//  Created by Stern Edi on 10/17/13.
//
//

#import <UIKit/UIKit.h>

@interface CellTarifRCARedus : UITableViewCell
{
    IBOutlet UIImageView * imgLogo;
    IBOutlet UILabel     * lblPrima;
    IBOutlet UILabel     * lblPrimaReducere;
    IBOutlet UILabel     * lblClasaBM;
    IBOutlet UILabel     * lblAlegePrima;
    IBOutlet UILabel     * lblStrike;
    IBOutlet UIImageView * btnComanda;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withReducere :(BOOL) red;

- (void) setPrima:(NSString *)v;
- (void) setPrimaReducere:(NSString *)v;
- (void) setLogo:(NSString *)p;
- (void) setClasaBM: (NSString *) p;

@end
