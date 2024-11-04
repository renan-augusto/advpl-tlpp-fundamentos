#include 'totvs.ch'
#include 'fwmvcdef.ch'
Static Function viewdef

    local oView
    local oModel
    local oStrZ53CAB
    local oStrZ53DET
    
    //montando o cabecalho com os campos que fazem parte da lista definida
    oStrZ53CAB          := fwFormStruct(2, 'Z53', {|cCampo| alltrim(cCampo) $ 'Z53_NUMERO | Z53_NUMMED | Z53_EMISSA | Z53_TIPO'})
    //nos itens eu quero mostrar todos os campos que nao fazem parte dos itens do cabecalho
    oStrZ53DET          := fwFormStruct(2, 'Z53', {|cCampo| .not. alltrim(cCampo) $ 'Z53_NUMERO | Z53_NUMMED | Z53_EMISSA | Z53_TIPO'})
    oModel              := fwLoadModel('GCTBM03MODELDEF') //indico o nome do arquivo e ela faz a carga do oModel que está naquele arquivo
    oView               := fwFormView():new()

    //campos somente leitura
    oStrZ53CAB:setProperty('Z53_TIPO', MVC_VIEW_CANCHANGE,  .F.)
    oStrZ53DET:setProperty('Z53_NUMMED', MVC_VIEW_CANCHANGE, .F.)
    oStrZ53DET:setProperty('Z53_VALOR', MVC_VIEW_CANCHANGE, .F.)
    oStrZ53DET:setProperty('Z52_STATUS', MVC_VIEW_CANCHANGE, .F.)
    oStrZ53DET:setProperty('Z52_PEDIDO', MVC_VIEW_CANCHANGE, .F.)
    oStrZ53DET:setProperty('Z52_ITEMPV', MVC_VIEW_CANCHANGE, .F.)

    oView:setModel(oModel)
    //componente z53master que vai ser responsavel pelos campso do cabecalho
    oView:addField('Z53MASTER', oStrZ53CAB, 'Z53MASTER')
    oView:addGrid('Z53DETAIL', oStrZ53DET, 'Z53DETAIL')
    oView:addIncrementView('Z53DETAIL', 'Z53_ITEM')
    //nome do box mais tamanho em porcentagem
    oView:createHorizontalBox('BOXZ53CAB', 20)
    oView:createHorizontalBox('BOXZ53DET', 80)
    oView:setOwnerView('Z53MASTER', 'BOXZ51')
    oView:setOwnerView('Z53DETAIL', 'BOXZ52')

Return oView
