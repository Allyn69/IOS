//
//  Setari.m
//  i-Asigurare
//
//  Created by Administrator on 1/31/11.
//  Copyright 2011 i-Tom Solutions. All rights reserved.
//

#import "Setari.h"

@implementation Setari

@synthesize ClientId, Nume, CodUnic, Telefon, Email, Strada, Judet, JudetId, Localitate, Error;
@synthesize Casatorit, CopiiMinori, Pensionar, NrBugetari;
@synthesize CategorieId, SubcategorieId, Subcategorie, Marca, MarcaId, Model, NrInmatriculare, SerieSasiu, SerieCI, AutoNou, Cm3, kW, Combustibil;
@synthesize RcaId, CascoId;
@synthesize ExpirareRca, ExpirareItp, ExpirareRovigneta;
@synthesize isDirty, alerteConfigurate, inregistrat, intrebatInregistrare;
@synthesize DataPermis, NrLocuri, MasaMaxima, AnFabricatie, DestinatieAuto, TipPersoana, CUI, DenumirePJ, CodCaen, NrDauneUltimAn, AniFaraDaune, DurataAsigurare, DataInceputRCA;
@synthesize isDirty1, isDirty2, isDirty3;
@synthesize isValid1, isValid2, isValid3;
@synthesize idOferta, adresaLivrare;

-(void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:ClientId forKey:@"ClientId"];
	
	[encoder encodeObject:Nume forKey:@"Nume"];
	[encoder encodeObject:CodUnic forKey:@"CodUnic"];
	[encoder encodeObject:Telefon forKey:@"Telefon"];
	[encoder encodeObject:Email forKey:@"Email"];
	[encoder encodeObject:Judet forKey:@"Judet"];
	[encoder encodeInt:JudetId forKey:@"JudetId"];
	[encoder encodeObject:Localitate forKey:@"Localitate"];
	[encoder encodeObject:Strada forKey:@"Strada"];
	[encoder encodeObject:DataPermis forKey:@"DataPermis"];
	
	[encoder encodeBool:Casatorit forKey:@"Casatorit"];
	[encoder encodeBool:CopiiMinori forKey:@"CopiiMinori"];
	[encoder encodeBool:Pensionar forKey:@"Pensionar"];
    [encoder encodeInt:NrBugetari forKey:@"NrBugetari"];
    
	[encoder encodeInt:CategorieId forKey:@"CategorieId"];
	[encoder encodeInt:SubcategorieId forKey:@"SubcategorieId"];    
	[encoder encodeObject:Subcategorie forKey:@"Subcategorie"];
    [encoder encodeObject:Marca forKey:@"Marca"];
	[encoder encodeInt:MarcaId forKey:@"MarcaId"];
	[encoder encodeObject:Model forKey:@"Model"];
	[encoder encodeObject:NrInmatriculare forKey:@"NrInmatriculare"];
	[encoder encodeObject:SerieSasiu forKey:@"SerieSasiu"];
    [encoder encodeObject:SerieCI forKey:@"SerieCI"];
	[encoder encodeInt:AutoNou forKey:@"AutoNou"];
	[encoder encodeObject:Cm3 forKey:@"Cm3"];
	[encoder encodeObject:kW forKey:@"kW"];
	[encoder encodeObject:Combustibil forKey:@"Combustibil"];
	[encoder encodeInt:NrLocuri forKey:@"NrLocuri"];
	[encoder encodeInt:MasaMaxima forKey:@"MasaMaxima"];
	[encoder encodeInt:AnFabricatie forKey:@"AnFabricatie"];
	[encoder encodeObject:DestinatieAuto forKey:@"DestinatieAuto"];
	[encoder encodeObject:TipPersoana forKey:@"TipPersoana"];
	[encoder encodeObject:CUI forKey:@"CUI"];
	[encoder encodeObject:DenumirePJ forKey:@"DenumirePJ"];
    [encoder encodeObject:CodCaen forKey:@"CodCaen"];
	
	[encoder encodeInt:NrDauneUltimAn forKey:@"NrDauneUltimAn"];
	[encoder encodeInt:NrDauneUltimAn forKey:@"AniFaraDaune"];
	[encoder encodeInt:DurataAsigurare forKey:@"DurataAsigurare"];
	[encoder encodeObject:DataInceputRCA forKey:@"DataInceputRCA"];
	
	[encoder encodeInt:RcaId forKey:@"RcaId"];
	[encoder encodeInt:CascoId forKey:@"CascoId"];
	[encoder encodeBool:isDirty forKey:@"isDirty"];
	
	[encoder encodeBool:isDirty1 forKey:@"isDirty1"];
	[encoder encodeBool:isDirty2 forKey:@"isDirty2"];
	[encoder encodeBool:isDirty3 forKey:@"isDirty3"];
	
	[encoder encodeBool:isValid1 forKey:@"isValid1"];
	[encoder encodeBool:isValid2 forKey:@"isValid2"];
	[encoder encodeBool:isValid3 forKey:@"isValid3"];
	
	[encoder encodeObject:ExpirareRca forKey:@"ExpirareRca"];
	[encoder encodeObject:ExpirareItp forKey:@"ExpirareItp"];
	[encoder encodeObject:ExpirareRovigneta forKey:@"ExpirareRovigneta"];
	
	[encoder encodeBool:alerteConfigurate forKey:@"alerteConfigurate"];
	[encoder encodeBool:inregistrat forKey:@"inregistrat"];
	[encoder encodeBool:intrebatInregistrare forKey:@"intrebatInregistrare"];
	[encoder encodeObject:idOferta forKey:@"idOferta"];
	[encoder encodeObject:adresaLivrare forKey:@"adresaLivrare"];
	
	[encoder encodeObject:Error forKey:@"Error"];
}

-(id) initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		ClientId = [[decoder decodeObjectForKey:@"ClientId"] retain];
		
		Nume = [[decoder decodeObjectForKey:@"Nume"] retain];
		CodUnic = [[decoder decodeObjectForKey:@"CodUnic"] retain];
		Telefon = [[decoder decodeObjectForKey:@"Telefon"] retain];
		Email = [[decoder decodeObjectForKey:@"Email"] retain];
		Judet = [[decoder decodeObjectForKey:@"Judet"] retain];
		JudetId = [decoder decodeIntForKey:@"JudetId"];
		Localitate = [[decoder decodeObjectForKey:@"Localitate"] retain];
		Strada = [[decoder decodeObjectForKey:@"Strada"] retain];
		DataPermis = [[decoder decodeObjectForKey:@"DataPermis"] retain];
		
        Casatorit = [decoder decodeBoolForKey:@"Casatorit"];
        CopiiMinori = [decoder decodeBoolForKey:@"CopiiMinori"];
        Pensionar = [decoder decodeBoolForKey:@"Pensionar"];
        NrBugetari = [decoder decodeIntForKey:@"NrBugetari"];
        
		CategorieId = [decoder decodeIntegerForKey:@"CategorieId"];
		SubcategorieId = [decoder decodeIntegerForKey:@"SubcategorieId"];        
		Subcategorie = [[decoder decodeObjectForKey:@"Subcategorie"] retain];
        Marca = [[decoder decodeObjectForKey:@"Marca"] retain];
		MarcaId = [decoder decodeIntegerForKey:@"MarcaId"];
		Model = [[decoder decodeObjectForKey:@"Model"] retain];
		NrInmatriculare = [[decoder decodeObjectForKey:@"NrInmatriculare"] retain];
		SerieSasiu = [[decoder decodeObjectForKey:@"SerieSasiu"] retain];
        SerieCI = [[decoder decodeObjectForKey:@"SerieCI"] retain];
		AutoNou = [decoder decodeIntegerForKey:@"AutoNou"];
		Cm3 = [[decoder decodeObjectForKey:@"Cm3"] retain];
		kW = [[decoder decodeObjectForKey:@"kW"] retain];
		Combustibil = [[decoder decodeObjectForKey:@"Combustibil"] retain];
		NrLocuri = [decoder decodeIntegerForKey:@"NrLocuri"];
		MasaMaxima = [decoder decodeIntegerForKey:@"MasaMaxima"];
		AnFabricatie = [decoder decodeIntegerForKey:@"AnFabricatie"];
		DestinatieAuto = [[decoder decodeObjectForKey:@"DestinatieAuto"] retain];
		TipPersoana = [[decoder decodeObjectForKey:@"TipPersoana"] retain];
		CUI = [[decoder decodeObjectForKey:@"CUI"] retain];
		DenumirePJ = [[decoder decodeObjectForKey:@"DenumirePJ"] retain];
		CodCaen = [[decoder decodeObjectForKey:@"CodCaen"] retain];
        
		NrDauneUltimAn = [decoder decodeIntegerForKey:@"NrDauneUltimAn"];
		AniFaraDaune = [decoder decodeIntegerForKey:@"AniFaraDaune"];
		DurataAsigurare = [decoder decodeIntegerForKey:@"DurataAsigurare"];
		DataInceputRCA = [[decoder decodeObjectForKey:@"DataInceputRCA"] retain];
		
		RcaId = [decoder decodeIntegerForKey:@"RcaId"];
		CascoId = [decoder decodeIntegerForKey:@"CascoId"];
		isDirty = [decoder decodeBoolForKey:@"isDirty"];

		isDirty1 = [decoder decodeBoolForKey:@"isDirty1"];
		isDirty2 = [decoder decodeBoolForKey:@"isDirty2"];
		isDirty3 = [decoder decodeBoolForKey:@"isDirty3"];
		
		isValid1 = [decoder decodeBoolForKey:@"isValid1"];
		isValid2 = [decoder decodeBoolForKey:@"isValid2"];
		isValid3 = [decoder decodeBoolForKey:@"isValid3"];
		
		ExpirareRca = [[decoder decodeObjectForKey:@"ExpirareRca"] retain];
		ExpirareItp = [[decoder decodeObjectForKey:@"ExpirareItp"] retain];
		ExpirareRovigneta = [[decoder decodeObjectForKey:@"ExpirareRovigneta"] retain];
		
		alerteConfigurate = [decoder decodeBoolForKey:@"alerteConfigurate"];
		inregistrat = [decoder decodeBoolForKey:@"inregistrat"];
		intrebatInregistrare = [decoder decodeBoolForKey:@"intrebatInregistrare"];
		idOferta = [[decoder decodeObjectForKey:@"idOferta"] retain];
		
		adresaLivrare = [[decoder decodeObjectForKey:@"adresaLivrare"] retain];
		
		Error = [[decoder decodeObjectForKey:@"Error"] retain];
	}
	return self;
}

@end
