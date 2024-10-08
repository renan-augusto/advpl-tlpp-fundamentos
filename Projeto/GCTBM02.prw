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
    oBrowse:addLegend("Z51_TPINTE == 'V' ", "BR_AMARELO", "Vendas","1")
    oBrowse:addLegend("Z51_TPINTE == 'C' ", "BR_LARANJA", "Compras", "1")
    oBrowse:addLegend("Z51_TPINTE == 'S' ", "BR_CINZA", "Sem Integracao", "1")
    oBrowse:addLegend("Z51_STATUS == 'N' .or. empty(Z51_STATUS) ", "AMARELO", "N�o iniciado", "2")
    oBrowse:addLegend("Z51_STATUS == 'I' ", "VERDE", "Iniciado", "2")
    oBrowse:addLegend("Z51_STATUS == 'E' ", "VERMELHO", "Encerrado", "2")
    oBrowse:activate()

Return 


Static Function menudef
    
    local aRotina       := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'axPesqui'         OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.GCTBM02'  OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.GCTBM02'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.GCTBM02'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.GCTBM02'  OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'     ACTION 'VIEWDEF.GCTBM02'  OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'       ACTION 'VIEWDEF.GCTBM02'  OPERATION 9 ACCESS 0
    

Return aRotina

//interface grafica
Static Function viewdef

    local oView
    local oModel
    local oStructZ51
    local oStructZ52
    

    oStructZ51          := fwFormStruct(2, 'Z51')
    oStructZ52          := fwFormStruct(2, 'Z52', {|cCampo| .not. alltrim(cCampo) $ 'Z52_NUMERO'})
    oModel              := fwLoadModel('GCTBM02') //indico o nome do arquivo e ela faz a carga do oModel que est� naquele arquivo
    oView               := fwFormView():new()

    oView:setModel(oModel)
    oView:addField('Z51MASTER', oStructZ51, 'Z51MASTER')
    oView:addGrid('Z52DETAIL', oStructZ52, 'Z52DETAIL')
    oView:addIncrementView('Z52DETAIL', 'Z52_ITEM')
    oView:createHorizontalBox('BOXZ51', 50)
    oView:createHorizontalBox('BOXZ52', 50)
    oView:setOwnerView('Z51MASTER', 'BOXZ51')
    oView:setOwnerView('Z52DETAIL', 'BOXZ52')

Return oView


//regra de negocio
Static Function modeldef
    
    local oModel
    local oStructZ51
    local oStructZ52
    local bModelPre     := {|oModel| .T.}
    local bModelPos     := {|oModel| .T.}
    local bCommit       := {|oModel| fwFormCommit(oModel)} //retorna .T. ou .F. dependendo se ele conseguiu gravar ou nao
    local bCancel       := {|oModel| fCancel(oModel)}
    local bGridpre      := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,1)}
    local bLinePre      := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,2)}
    local bLinePos      := {|oGridModel, nLine| vGridPos(oGridModel, nLine, 1)}
    local bGridPos      := {|oGridModel, nLine| vGridPos(oGridModel, nLine, 2)}
    local bGridLoad     := {|oGridModel, lCopy| vGridLoad(oGridModel, lCopy)}

    oStructZ51  := fwFormStruct(1, 'Z51')
    oStructZ52  := fwFormStruct(1, 'Z52')

    //indicando quais campos poder�o ser editados
    bModelWhen  := {|| oModel:getOperation() == 3 .or. oModel:getOperation() == 9}
    bWhenEmiss  := {|| vWhenEmis(oModel)}
    bModelInit  := {|| getSxeNum("Z51", "Z51_NUMERO")}
    oStructZ51:setProperty('Z51_NUMERO'     ,MODEL_FIELD_INIT, bModelInit)
    oStructZ51:setProperty('Z51_TIPO'       ,MODEL_FIELD_WHEN, bModelWhen)
    oStructZ51:setProperty('Z51_NUMERO'     ,MODEL_FIELD_WHEN, bModelWhen)
    oStructZ51:setProperty('Z51_CLIENT'     ,MODEL_FIELD_WHEN, bModelWhen)
    oStructZ51:setProperty('Z51_LOJA'       ,MODEL_FIELD_WHEN, bModelWhen)
    oStructZ51:setProperty('Z51_NOMECLI'    ,MODEL_FIELD_WHEN, bModelWhen)
    oStructZ51:setProperty('Z51_VALOR'      ,MODEL_FIELD_WHEN, bModelWhen)
    oStructZ51:setProperty('Z51_QTDMED'     ,MODEL_FIELD_WHEN, bModelWhen)
    oStructZ51:setProperty('Z51_EMISSA'     ,MODEL_FIELD_WHEN, bWhenEmiss)

    oModel      := mpFormModel():new('MODEL_GCTBM02', bModelPre, bModelPos, bCommit, bCancel)
    oModel:setDescription('Contratos')
    oModel:addFields('Z51MASTER',,oStructZ51) //vinculado com o componente field (singular) da viewdef
    oModel:setPrimaryKey({'Z51_FILIAL', 'Z51_NUMERO'})
    //para grid, ele tem validacao na linha e validacao no grid todo
    oModel:addGrid('Z52DETAIL', 'Z51MASTER', oStructZ52, bLinePre, bLinePos, bGridpre, bGridPos, bGridLoad)
    oModel:getModel('Z52DETAIL'):setUniqueLine({'Z52_ITEM'})
    oModel:setOptional('Z52DETAIL', .T.) //indica se o componente de detalhe � opcional ou obrigatorio
    oModel:setRelation('Z52DETAIL', {{'Z52_FILIAL', 'xFilial("Z52")'}, {"Z52_NUMERO", "Z51_NUMERO"}, Z52->(indexKey(1))}) //indico componente relacionado com a principal

Return oModel

//pre validacao do objeto do submodelo grid
Static Function vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue, nOpc)

    local lValid
    
Return lValid

//pos validacao do objeto do submodelo grid
Static Function vGridPos(oGridModel, nLine, nOpc)

    local lValid
    
Return return_var


Static Function vGridLoad(oGridModel, lCopy)

    local aRetorno      := formLoadGrid(oGridModel, lCopy)

Return aRetorno

Static Function fCancel(oModel)
    
    Local lCancel   := fwFormCancel(oModel)

    if lCancel
        
        if __lSx8
            rollbackSX8()
        endif

    endif

Return lCancel

Static Function vWhenEmis(oModel)

    local lWhen := .T.

    if oModel:getOperation() == 4
        
        dDtAssinBd  := Z51->Z51_DTASSI
        dDtAssinMd  := oModel:getModel('Z51MASTER'):getValue('Z51_DTASSI')

        if .not. empty(dDtAssinBd)
            lWhen := .F.
        endif

    endif
    
Return lWhen
