//
//  Setari.m
//  InsuranceAssistance
//
//  Created by Administrator on 1/31/11.
//  Copyright 2011 i-Tom Solutions. All rights reserved.
//

#import "Setari.h"
#import	"YTOAppDelegate.h"

@implementation Setari

@synthesize ClientId, Nume, CodUnic, Telefon, Email, Strada, Judet, JudetId, Localitate, Error;
@synthesize CategorieId, Marca, MarcaId, Model, NrInmatriculare, SerieSasiu, AutoNou, Cm3, kW, Combustibil;
@synthesize RcaId, CascoId;
@synthesize ExpirareRca, ExpirareItp, ExpirareRovigneta;
@synthesize isDirty, alerteConfigurate, inregistrat, intrebatInregistrare;
@synthesize DataPermis, NrLocuri, MasaMaxima, AnFabricatie, DestinatieAuto, TipPersoana, CUI, DenumirePJ, NrDauneUltimAn, AniFaraDaune, DurataAsigurare, DataInceputRCA;
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
	
	[encoder encodeInt:CategorieId forKey:@"CategorieId"];
	[encoder encodeObject:Marca forKey:@"Marca"];
	[encoder encodeInt:MarcaId forKey:@"MarcaId"];
	[encoder encodeObject:Model forKey:@"Model"];
	[encoder encodeObject:NrInmatriculare forKey:@"NrInmatriculare"];
	[encoder encodeObject:SerieSasiu forKey:@"SerieSasiu"];
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
		ClientId = [decoder decodeObjectForKey:@"ClientId"];
		
		Nume = [decoder decodeObjectForKey:@"Nume"] ;
		CodUnic = [decoder decodeObjectForKey:@"CodUnic"] ;
		Telefon = [decoder decodeObjectForKey:@"Telefon"] ;
		Email = [decoder decodeObjectForKey:@"Email"] ;
		Judet = [decoder decodeObjectForKey:@"Judet"] ;
		JudetId = [decoder decodeIntForKey:@"JudetId"];
		Localitate = [decoder decodeObjectForKey:@"Localitate"] ;
		Strada = [decoder decodeObjectForKey:@"Strada"] ;
		DataPermis = [decoder decodeObjectForKey:@"DataPermis"] ;
		
		CategorieId = [decoder decodeIntegerForKey:@"CategorieId"];
		Marca = [decoder decodeObjectForKey:@"Marca"] ;
		MarcaId = [decoder decodeIntegerForKey:@"MarcaId"];
		Model = [decoder decodeObjectForKey:@"Model"] ;
		NrInmatriculare = [decoder decodeObjectForKey:@"NrInmatriculare"] ;
		SerieSasiu = [decoder decodeObjectForKey:@"SerieSasiu"] ;
		AutoNou = [decoder decodeIntegerForKey:@"AutoNou"];
		Cm3 = [decoder decodeObjectForKey:@"Cm3"] ;
		kW = [decoder decodeObjectForKey:@"kW"] ;
		Combustibil = [decoder decodeObjectForKey:@"Combustibil"] ;
		NrLocuri = [decoder decodeIntegerForKey:@"NrLocuri"];
		MasaMaxima = [decoder decodeIntegerForKey:@"MasaMaxima"];
		AnFabricatie = [decoder decodeIntegerForKey:@"AnFabricatie"];
		DestinatieAuto = [decoder decodeObjectForKey:@"DestinatieAuto"] ;
		TipPersoana = [decoder decodeObjectForKey:@"TipPersoana"] ;
		CUI = [decoder decodeObjectForKey:@"CUI"] ;
		DenumirePJ = [decoder decodeObjectForKey:@"DenumirePJ"] ;
		
		NrDauneUltimAn = [decoder decodeIntegerForKey:@"NrDauneUltimAn"];
		AniFaraDaune = [decoder decodeIntegerForKey:@"AniFaraDaune"];
		DurataAsigurare = [decoder decodeIntegerForKey:@"DurataAsigurare"];
		DataInceputRCA = [decoder decodeObjectForKey:@"DataInceputRCA"] ;
		
		RcaId = [decoder decodeIntegerForKey:@"RcaId"];
		CascoId = [decoder decodeIntegerForKey:@"CascoId"];
		isDirty = [decoder decodeBoolForKey:@"isDirty"];

		isDirty1 = [decoder decodeBoolForKey:@"isDirty1"];
		isDirty2 = [decoder decodeBoolForKey:@"isDirty2"];
		isDirty3 = [decoder decodeBoolForKey:@"isDirty3"];
		
		isValid1 = [decoder decodeBoolForKey:@"isValid1"];
		isValid2 = [decoder decodeBoolForKey:@"isValid2"];
		isValid3 = [decoder decodeBoolForKey:@"isValid3"];
		
		ExpirareRca = [decoder decodeObjectForKey:@"ExpirareRca"] ;
		ExpirareItp = [decoder decodeObjectForKey:@"ExpirareItp"] ;
		ExpirareRovigneta = [decoder decodeObjectForKey:@"ExpirareRovigneta"] ;
		
		alerteConfigurate = [decoder decodeBoolForKey:@"alerteConfigurate"];
		inregistrat = [decoder decodeBoolForKey:@"inregistrat"];
		intrebatInregistrare = [decoder decodeBoolForKey:@"intrebatInregistrare"];
		idOferta = [decoder decodeObjectForKey:@"idOferta"] ;
		
		adresaLivrare = [decoder decodeObjectForKey:@"adresaLivrare"] ;
		
		Error = [decoder decodeObjectForKey:@"Error"] ;
	}
	return self;
}

- (NSString *) getXML {
	//NSData * data = [@"testtetetete" dataUsingEncoding:NSUTF8StringEncoding];
	
	NSString * xml = [NSString stringWithFormat:
					  @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
					  "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
					  "<soap:Body>"
					  "<CalculRca xmlns=\"http://tempuri.org/\">"
					  "<user>vreaurca</user>"
					  "<password>123</password>"
					  "<nume>%@</nume>"
					  "<cnp>%@</cnp>"
					  "<telefon>%@</telefon>"
					  "<email>%@</email>"
					  "<strada>%@</strada>"
					  "<judet>%@</judet>"
					  "<marca>%@</marca>"
					  "<model>%@</model>"
					  "<nr_inmatriculare>%@</nr_inmatriculare>"
					  "<serie_sasiu>%@</serie_sasiu>"
					  "<casco>%d</casco>"
					  "<localitate>%@</localitate>"
					  "<data_permis>%@</data_permis>"
					  "<auto_nou>%d</auto_nou>"
					  "<marca_id>%d</marca_id>"
					  "<cm3>%@</cm3>"
					  "<kw>%@</kw>"
					  "<combustibil>%@</combustibil>"
					  "<nr_locuri>%d</nr_locuri>"
					  "<masa_maxima>%d</masa_maxima>"
					  "<an_fabricatie>%d</an_fabricatie>"
					  "<destinatie_auto>%@</destinatie_auto>"
					  "<tip_persoana>%@</tip_persoana>"
					  "<cui>%@</cui>"
					  "<denumire_pj>%@</denumire_pj>"
					  "<nr_daune_ultim_an>%d</nr_daune_ultim_an>"
					  "<ani_fara_daune>%d</ani_fara_daune>"
					  "<durata_asigurare>%d</durata_asigurare>"
					  "<data_inceput_rca>%@</data_inceput_rca>"
					  "<udid>%@</udid>"
					  "<platforma>%@</platforma>"
					  "<tip_inregistrare>inmatriculat</tip_inregistrare>"
					  "<caen>01</caen>"
					  "<subtip_activitate>altele</subtip_activitate>"
					  "<index_categorie_auto>%d</index_categorie_auto>"
					  "<subcategorie_auto>Autoturism</subcategorie_auto>"
					  "<in_leasing>nu</in_leasing>"
					  //"<img1>%@</img1>"
					  "</CalculRca>"
					  "</soap:Body>"
					  "</soap:Envelope>",
		self.Nume, self.CodUnic, 
		self.Telefon, self.Email, self.Strada, self.Judet,
		self.Marca, self.Model, self.NrInmatriculare, self.SerieSasiu,
		self.CascoId,
		self.Localitate, self.DataPermis, self.AutoNou, self.MarcaId, self.Cm3, self.kW, self.Combustibil,
		self.NrLocuri, self.MasaMaxima, self.AnFabricatie, self.DestinatieAuto,
		self.TipPersoana, self.CUI, self.DenumirePJ, self.NrDauneUltimAn, self.AniFaraDaune, self.DurataAsigurare, self.DataInceputRCA,
		[[UIDevice currentDevice] xUniqueDeviceIdentifier], [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
		self.CategorieId]; //,[QSStrings encodeBase64WithData:data]];
		
	NSLog(@"xml=%@",xml);
	return xml;
}

- (BOOL) rcaValid {
	if (CodUnic.length > 0 && JudetId > 0 && Localitate.length > 0 && DataPermis.length > 0 && NrInmatriculare.length > 0
		&& SerieSasiu.length > 0 && CategorieId > 0 && Marca.length > 0 && Model.length > 0 && Cm3.length > 0 
		&& kW.length > 0 && NrLocuri > 0 && MasaMaxima > 0 && AnFabricatie > 0 && DestinatieAuto.length > 0
		&& DurataAsigurare > 0 && DataInceputRCA.length > 0)
		return YES;
	return NO;
}


@end
