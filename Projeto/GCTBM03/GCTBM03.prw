#include 'totvs.ch'
#include 'fwmvcdef.ch'
/*/{Protheus.doc} GCTBM03
    Apontamentos de medicao em MVC
/*/
Function U_GCTBM03
    
    Private aRotina         := fwLoadMenuDef('GCTBM03MENUDEF') //a estrutura de menu do outro arquivo será retornado no aRotina
    Private oBrowse         := fwMBrowse():new()

    oBrowse:setAlias('Z53')
    oBrowse:setDescription('Apontamento de medições')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("LEFT(Z53_TIPO,1) == 'V' ", "BR_AMARELO", "Vendas","1")
    oBrowse:addLegend("LEFT(Z53_TIPO,1) == 'C' ", "BR_LARANJA", "Compras", "1")
    oBrowse:addLegend("LEFT(Z53_TIPO,1) == 'S' ", "BR_CINZA", "Sem Integracao", "1")
    oBrowse:addLegend("Z53_STATUS == 'A' ", "VERDE", "Aberta", "2")
    oBrowse:addLegend("Z53_STATUS == 'E' ", "VERMELHO", "Encerrada", "2")
    oBrowse:activate()

Return 
