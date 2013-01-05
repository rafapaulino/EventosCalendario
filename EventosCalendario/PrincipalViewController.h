//
//  PrincipalViewController.h
//  EventosCalendario
//
//  Created by Rafael Brigagão Paulino on 13/09/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface PrincipalViewController : UIViewController <EKEventEditViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *status;
@property (nonatomic, weak) IBOutlet UILabel *lblDataInicial;
@property (nonatomic, weak) IBOutlet UILabel *lblDataFinal;
@property (nonatomic, weak) IBOutlet UIDatePicker *meuDatePicker;
@property (nonatomic, weak) IBOutlet UITableView *tabela;


-(IBAction)adicionarNovoEvento:(id)sender;
-(IBAction)selecionarDataInicial:(id)sender;
-(IBAction)selecionarDataFinal:(id)sender;
-(IBAction)buscarEventos:(id)sender;

@end
