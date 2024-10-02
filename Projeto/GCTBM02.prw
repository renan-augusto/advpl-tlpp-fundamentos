/*/{Protheus.doc} GCTBM02
    Cadastro de contratos em MVC
    /*/
Function U_GCTBM02
    
    Private aRotina         := menudef()
    Private oBrowse         := fwMBrowse():new()

    oBrowse:setAlias('Z51')
    oBrowse:setDescription('Contratos')
    oBrowse:setExecuteDef(4)
    oBrowse:activate()

Return 


Static Function menudef
    
    local aRotina       := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'axPesqui'         OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.GCTBM02'  OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'VIEWDEF.GCTBM02'  OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'VIEWDEF.GCTBM02'  OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'VIEWDEF.GCTBM02'  OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'VIEWDEF.GCTBM02'  OPERATION 1 ACCESS 0
    

Return aRotina

//interface grafica
Static Function viewdef

    local oView
    
Return oView


//regra de negocio
Static Function modeldef
    
    local oModel

Return oModel
