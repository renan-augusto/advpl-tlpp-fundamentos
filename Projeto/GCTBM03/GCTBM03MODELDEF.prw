#include 'totvs.ch'
#include 'fwmvcdef.ch'

Static Function modeldef
    
    local oModel
    local oStrZ53CAB
    local oStrZ53DET
    local bModelPre     := {|oModel| .T.}
    local bModelPos     := {|oModel| .T.}
    local bCommit       := {|oModel| fCommit(oModel)} //retorna .T. ou .F. dependendo se ele conseguiu gravar ou nao
    local bCancel       := {|oModel| fCancel(oModel)}
    local bGridpre      := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,1)}
    local bLinePre      := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,2)}
    local bLinePos      := {|oGridModel, nLine| vGridPos(oGridModel, nLine, 1)}
    local bGridPos      := {|oGridModel, nLine| vGridPos(oGridModel, nLine, 2)}
    local bGridLoad     := {|oGridModel, lCopy| vGridLoad(oGridModel, lCopy)}
    // local bValid        := {|| vValid()}

    oStrZ53CAB  := fwFormStruct(1, 'Z53',  {|cCampo| alltrim(cCampo) $ 'Z53_NUMERO | Z53_NUMMED | Z53_EMISSA | Z53_TIPO'})
    oStrZ53DET  := fwFormStruct(1, 'Z53',  {|cCampo| .not. alltrim(cCampo) $ 'Z53_NUMERO | Z53_NUMMED | Z53_EMISSA | Z53_TIPO'})

    oModel      := mpFormModel():new('MODEL_GCTBM03', bModelPre, bModelPos, bCommit, bCancel)
    oModel:setDescription('Apontamento de medições')
    oModel:addFields('Z53MASTER',,oStrZ53CAB) //vinculado com o componente field (singular) da viewdef
    oModel:setPrimaryKey({'Z53_FILIAL', 'Z53_NUMERO'})
    //para grid, ele tem validacao na linha e validacao no grid todo
    oModel:addGrid('Z53DETAIL', 'Z53MASTER', oStrZ53DET, bLinePre, bLinePos, bGridpre, bGridPos, bGridLoad)
    oModel:getModel('Z53DETAIL'):setUniqueLine({'Z53_ITEM'})
    oModel:setRelation('Z53DETAIL', {{'Z53_FILIAL', 'xFilial("Z53")'}, {"Z53_NUMERO", "Z53_NUMERO"}, Z53->(indexKey(1))}) //indico componente relacionado com a principal

Return oModel

/*/{Protheus.doc} fCommit(oModel)/*/
Static Function fCommit(oModel)
    
    local lCommit := fwFormCommit(oModel)

Return lCommit

/*/{Protheus.doc} fCancel/*/
Static Function fCancel(oModel)

    lCancel := fwFormCancel(oModel)
    
Return lCancel

/*/{Protheus.doc} vGridPre /*/
Static Function vGridPre(oGridModel, nLine, cAction, cField, xValue, xCurrentValue, nOpcao)
    
    local lValid := .T.

Return lValid


/*/{Protheus.doc} vGridPos/*/
Static Function vGridPos(oGridModel, nLine, nOpcao)
    
    local lValid := .t.

Return lValid

/*/{Protheus.doc} vGridLoad/*/
Static Function vGridLoad(oGridModel, lCopy)

    local aLoad := formLoadGrid(oGridModel, lCopy)
    
Return aLoad
