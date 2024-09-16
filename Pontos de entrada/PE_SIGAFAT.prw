#include 'totvs.ch'

/*/{Protheus.doc} U_SIGAFAT
    Ponto de entrada acionado no modulo de faturamtno
    @type  Function
    @author Renan Augusto
    @since 12/08/2024
/*/
Function U_SIGAFAT
    
    fwMsgRun(, {|| U_COTACOES_MOEDAS_BC()}, "Baixando cotações de moedas...", "Aguarde")  //chamando minha user function de download de moedas no bc 

Return 
