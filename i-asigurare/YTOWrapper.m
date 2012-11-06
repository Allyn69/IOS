//
//  YTOWrapper.m
//  i-asigurare
//
//  Created by Administrator on 10/10/12.
//
//

#import "YTOWrapper.h"
#import "YTOUtils.h"

@implementation YTOWrapper

+ (void) savePersonFromSetari:(Setari *)setari
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    YTOPersoana * persoana = [[YTOPersoana alloc] initWithGuid:[YTOUtils GenerateUUID]];
    persoana.proprietar = @"da";
    
    if (setari.Nume != nil)
        persoana.nume = setari.Nume;
    
    if (setari.CodUnic != nil)
    {
        if (setari.CodUnic.length == 13)
            persoana.tipPersoana = @"fizica";
        else if (setari.CodUnic.length > 0 && setari.CodUnic.length > 10)
            persoana.tipPersoana = @"juridica";
    }
    
    if (setari.Telefon != nil)
        persoana.telefon = setari.Telefon;
    if (setari.Email != nil)
        persoana.email = setari.Email;
    if (setari.Judet != nil)
        persoana.judet = setari.Judet;
    if (setari.Localitate != nil)
        persoana.localitate = setari.Localitate;
    if (setari.Strada != nil)
        persoana.adresa = setari.Strada;
    if (setari.DataPermis != nil)
    {
        persoana.dataPermis = persoana.dataPermis;
    }
    
    [persoana addPersoana];
}

+ (void) saveAutoFromSetari:(Setari *)setari
{
    YTOAutovehicul * masina = [[YTOAutovehicul alloc] initWithGuid:[YTOUtils GenerateUUID]];
}

@end
