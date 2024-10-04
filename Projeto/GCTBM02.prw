#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} GCTBM02
    Cadastro de contratos em MVC
    /*/
Function U_GCTBM02
    
    Private aRotina         := menudef()
    Private oBrowse         := fwMBrowse():new()

    oBrowse:setAlias('Z51')
    oBrowse:setDescription('Contratos')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("Z51_TIPO == 'V' ", "BR_AMARELO", "Vendas","1")
    oBrowse:addLegend("Z51_TIPO == 'C' ", "BR_LARANJA", "Compras", "1")
    oBrowse:addLegend("Z51_TIPO == 'S' ", "BR_CINZA", "Sem Integracao", "1")
    oBrowse:addLegend("Z51_STATUS == 'N' .or. empty(Z51_STATUS) ", "AMARELO", "Não iniciado", "2")
    oBrowse:addLegend("Z51_STATUS == 'I' ", "VERDE", "Iniciado", "2")
    oBrowse:addLegend("Z51_STATUS == 'E' ", "VERMELHO", "Encerrado", "2")
    oBrowse:activate()

Return 


Static Function menudef
    
    local aRotina       := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'axPesqui'         OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.GCTBM02'  OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'VIEWDEF.GCTBM02'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'VIEWDEF.GCTBM02'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'VIEWDEF.GCTBM02'  OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'VIEWDEF.GCTBM02'  OPERATION 6 ACCESS 0
    

Return aRotina

//interface grafica
Static Function viewdef

    local oView
    
Return oView


//regra de negocio
Static Function modeldef
    
    local oModel

Return oModel
