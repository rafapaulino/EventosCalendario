//
//  PrincipalViewController.m
//  EventosCalendario
//
//  Created by Rafael Brigagão Paulino on 13/09/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import "PrincipalViewController.h"

@interface PrincipalViewController ()
{
    NSArray *listaEventosBuscados;
    
    BOOL dataInicialEscolhida;
    BOOL dataFinalEscolhida;
    
    //datas escolhidas pelo usuario dentro do pickerview
    NSDate *dataInicial;
    NSDate *dataFinal;
}

@end

@implementation PrincipalViewController


-(IBAction)adicionarNovoEvento:(id)sender
{
    //recuperar a lista de eventos do device
    //EKEventStore representa a base de dados do calendario do device
    EKEventStore *listaEventos = [[EKEventStore alloc] init];
    
    //controladora para edicao de eventos
    EKEventEditViewController *eventosVC = [[EKEventEditViewController alloc] init];
    eventosVC.editViewDelegate = self;
    //passando a base de dados recuperada para a controladora de edicao
    eventosVC.eventStore = listaEventos;
    
    [self presentModalViewController:eventosVC animated:YES];
    
}

//metodo chamado toda vez que a controladora de edicao de evento receber um clique no botao cancel ou done
-(void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    //precisamos saber qual foi a cao do usuario
    if (action == EKEventEditViewActionSaved)
    {
        _status.text = @"Evento salvo!";
    }
    else if (action == EKEventEditViewActionCanceled)
    {
        _status.text = @"Evento cancelado!"; 
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)selecionarDataInicial:(id)sender
{
    //formatador de datas
    //toda vez que precisarmos de alguma informacao dentro de NSDate, utilizamos um NSDateFormatter para extrair esta informacao no formato desejado
    NSDateFormatter *formatadorDatas = [[NSDateFormatter alloc] init];
    
    //neste ex queeremos dia/mes/ano
    //ajustar o formatador para extrair a informacao como queremos
    [formatadorDatas setDateFormat:@"dd/MM/yyyy"];
    
    UIButton *botaoSelecionado = (UIButton*)sender;
    
    if (dataInicialEscolhida == NO)
    {
        //iniciando o processo de escolha
        
        //exibir o picker view
        _meuDatePicker.hidden = NO;
        //ajustando para cair no else
        dataInicialEscolhida = YES;
        
        [botaoSelecionado setTitle:@"Confirmar" forState:UIControlStateNormal];
    }
    else
    {
      //finalzar a escolha
        dataInicial = _meuDatePicker.date;
        
        //recuperando uma NSString entregue pelo formatador, utlzando a mascara que definimos no comeco processo @"dd/MM/YY"
        _lblDataInicial.text = [formatadorDatas stringFromDate:dataInicial];
        
        dataInicialEscolhida = NO;
        _meuDatePicker.hidden = YES;
        [botaoSelecionado setTitle:@"Selecionar" forState:UIControlStateNormal];
        
    }
   
}
-(IBAction)selecionarDataFinal:(id)sender
{
    //formatador de datas
    //toda vez que precisarmos de alguma informacao dentro de NSDate, utilizamos um NSDateFormatter para extrair esta informacao no formato desejado
    NSDateFormatter *formatadorDatas = [[NSDateFormatter alloc] init];
    
    //neste ex queeremos dia/mes/ano
    //ajustar o formatador para extrair a informacao como queremos
    [formatadorDatas setDateFormat:@"dd/MM/yyyy"];
    
    UIButton *botaoSelecionado = (UIButton*)sender;
    
    if (dataFinalEscolhida == NO)
    {
        //iniciando o processo de escolha
        
        //exibir o picker view
        _meuDatePicker.hidden = NO;
        //ajustando para cair no else
        dataFinalEscolhida = YES;
        
        [botaoSelecionado setTitle:@"Confirmar" forState:UIControlStateNormal];
    }
    else
    {
        //finalzar a escolha
        dataFinal = _meuDatePicker.date;
        
        //recuperando uma NSString entregue pelo formatador, utlzando a mascara que definimos no comeco processo @"dd/MM/YY"
        _lblDataFinal.text = [formatadorDatas stringFromDate:dataFinal];
        
        dataFinalEscolhida = NO;
        _meuDatePicker.hidden = YES;
        [botaoSelecionado setTitle:@"Selecionar" forState:UIControlStateNormal];
        
    }
}
-(IBAction)buscarEventos:(id)sender
{
    if (dataInicial != nil && dataFinal != nil)
    {
        
        //recuperacao da base de dados de eventos
        EKEventStore * listaEventos = [[EKEventStore alloc] init];
        
        //predicate é uma condicao [restricao] para a busca a ser efetuada
        NSPredicate *condicaoBusca = [listaEventos predicateForEventsWithStartDate:dataInicial endDate:dataFinal calendars:nil];//passando nil ele busca em todos os calendarios
        //ou a data final como nil ele pega tudo
        //[NSDate date] = pega a data de hj
        
        //realizando uma busca de eventos que atendam o predicao criado acima
        listaEventosBuscados = [listaEventos eventsMatchingPredicate:condicaoBusca];
        
        //uma vez que o array mudou, a tabela esta com osdados exibidos invalidos. Pedimos, portanto, que ela seja remonetada com o novo datasouce (array)
        [_tabela reloadData];
        
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Erro" message:@"Selecione data final e inicial!" delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles: nil] show];
    }
}


//delegate/datasource da tabela
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idCelula = @"celulaEvento";
    
    UITableViewCell *celula = [tableView dequeueReusableCellWithIdentifier:idCelula];
    
    if (celula == nil) {
        celula = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idCelula];
    }
    
    //configurar o conteudo da celula
    
    //Extraindo um evento para uma determinada linha da tabela
    EKEvent *evento = [listaEventosBuscados objectAtIndex:indexPath.row];
    
    celula.textLabel.text = evento.title;
    
    NSDateFormatter *formatador = [[NSDateFormatter alloc] init];
    [formatador setDateFormat:@"HH:MM"];
    
    NSString *horaEvento = [formatador stringFromDate:evento.startDate];
    
    celula.detailTextLabel.text = horaEvento;
    
    return celula;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listaEventosBuscados.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
