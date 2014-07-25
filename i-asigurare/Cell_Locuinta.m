//
//  Cell_Locuinta.m
//  i-asigurare
//
//  Created by Stern Edi on 30/04/14.
//
//

#import "Cell_Locuinta.h"
#import "YTOUtils.h"

@implementation Cell_Locuinta

@synthesize btnEdit,btnSelect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconFoto = [[UIImageView alloc] initWithFrame:CGRectMake(16, 4, 50, 50)];
        iconFoto.image = [UIImage imageNamed:@"icon-foto-casa.png"];
        
        lblTop = [[UILabel alloc] initWithFrame:CGRectMake(78, 4, 222, 21)];
        lblTop.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
        lblTop.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        
        lblBottom = [[UILabel alloc] initWithFrame:CGRectMake(78, 28, 222, 21)];
        lblBottom.font = [UIFont fontWithName:@"Arial" size:14];
        lblBottom.textColor = [UIColor lightGrayColor];
        
        btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 58, 159, 23)];
        lblEdit = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, 160, 23)];
        lblEdit.textColor = [YTOUtils colorFromHexString:@"#5a7ca1"];
        lblEdit.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        lblEdit.text = @"Editeaza";
        lblEdit.textAlignment = NSTextAlignmentCenter;
        
        btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(161, 58, 160, 23)];
        lblSelect = [[UILabel alloc] initWithFrame:CGRectMake(160, 56, 160, 23)];
        lblSelect.textColor = [YTOUtils colorFromHexString:@"#1987ff"];
        lblSelect.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        lblSelect.text = @"Selecteaza";
        lblSelect.textAlignment = NSTextAlignmentCenter;
        
        lblVertical = [[UILabel alloc] initWithFrame:CGRectMake(159, 57, 1, 23)];
        lblVertical.backgroundColor = [YTOUtils colorFromHexString:@"#E1E1E1"];
        lblOrizontal = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, 320, 1)];
        lblOrizontal.backgroundColor = [YTOUtils colorFromHexString:@"#E1E1E1"];
        lblOrizontal2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, 320, 1)];
        lblOrizontal2.backgroundColor = [YTOUtils colorFromHexString:@"#E1E1E1"];
        
        
        [self.contentView addSubview:iconFoto];
        [self.contentView addSubview:lblTop];
        [self.contentView addSubview:lblBottom];
        [self.contentView addSubview:btnEdit];
        [self.contentView addSubview:lblEdit];
        [self.contentView addSubview:btnSelect];
        [self.contentView addSubview:lblSelect];
        [self.contentView addSubview:lblVertical];
        [self.contentView addSubview:lblOrizontal];
        [self.contentView addSubview:lblOrizontal2];
      
        
    }
    
    return self;
}


- (void) setImageIcon:(NSString *)v
{
    iconFoto.image = [UIImage imageNamed:v];
}
- (void) setLabelTop:(NSString *)v
{
    lblTop.text = v;
}
- (void) setLabelBottom:(NSString *)v
{
    lblBottom.text = v;
}


@end
