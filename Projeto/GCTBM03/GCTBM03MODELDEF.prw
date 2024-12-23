#include 'totvs.ch'
#include 'fwmvcdef.ch'

Static Function modeldef
    
    local oModel
    local oStrZ53CAB
    local oStrZ53DET
    local bModelPre     := {|oModel| .T.}
    local bModelPos     := {|oModel| fModelPos(oModel)}
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

    oStrZ53CAB:setProperty('Z53_NUMERO', MODEL_FIELD_VALID, {|| fnValid()})
    oStrZ53CAB:setProperty('Z53_NUMMED', MODEL_FIELD_INIT, {|| getSxeNum('Z53', 'Z53_NUMMED')})
    oStrZ53CAB:setProperty('Z53_EMISSA', MODEL_FIELD_INIT, {|| dDataBase})
    oStrZ53CAB:setProperty('Z53_EMISSA', MODEL_FIELD_WHEN, {|| fnWhen(1)})
    oStrZ53DET:setProperty('*'         , MODEL_FIELD_WHEN, {|| fnWhen(2)})

    oModel      := mpFormModel():new('MODEL_GCTBM03', bModelPre, bModelPos, bCommit, bCancel)
    oModel:setDescription('Apontamento de medi��es')
    oModel:addFields('Z53MASTER',,oStrZ53CAB) //vinculado com o componente field (singular) da viewdef
    oModel:setPrimaryKey({'Z53_FILIAL', 'Z53_NUMERO'})
    //para grid, ele tem validacao na linha e validacao no grid todo
    oModel:addGrid('Z53DETAIL', 'Z53MASTER', oStrZ53DET, bLinePre, bLinePos, bGridpre, bGridPos, bGridLoad)
    oModel:getModel('Z53DETAIL'):setUniqueLine({'Z53_ITEM'})
    oModel:setRelation('Z53DETAIL', {{'Z53_FILIAL', 'xFilial("Z53")'}, {"Z53_NUMERO", "Z53_NUMERO"}, Z53->(indexKey(1))}) //indico componente relacionado com a principal

Return oModel

/*/{Protheus.doc} fnWhen/*/
Static Function fnWhen(nOpcao)
    
    local oModel := fwModelActive()
    local lWhen := .T.
    local lInclui := oModel:getOperation() == 3 .or. oModel:getOperation() == 9

    Do Case
        Case nOpcao == 1 // when no campo de emissao
            return lInclui
        Case nOpcao == 2 //validacao de todos os campos da estrutura de detalhe
            if fwFldGet('Z53_STATUS') == 'E' //esta encerrado entao tenho que retornar F n�o permitindo edicao do usuario
                return .F.
            endif
    EndCase

Return lWhen

/*/{Protheus.doc} fCommit(oModel)/*/
Static Function fCommit(oModel)
    //parametro preenchido ser� executado dentro da transacao
    local lCommit := fwFormCommit(oModel,,,,{|| U_ATUALIZA_INDICADORES_DO_CONTRATO()})

Return lCommit

/*/{Protheus.doc} fCancel/*/
Static Function fCancel(oModel)

    lCancel := fwFormCancel(oModel)

    if lCancel
        //verificando se a variavel lsx8, caso ela tiver sido acionada significa que a getSxenum foi acionada
        //quando o getSxenum for acionado a __lSX8 � preenchida com true
        if __lSX8
            rollbacksx8()
        endif
    endif
    
Return lCancel

/*/{Protheus.doc} vGridPre /*/
Static Function vGridPre(oGridModel, nLine, cAction, cField, xValue, xCurrentValue, nOpcao)
    
    local lValid := .T.
    local oModel := fwModelActive()

    if nOpcao == 2
        If cAction == 'DELETE'
            
            if fwFldGet('Z53_STATUS') == 'E'
                oModel:setErrorMessage(,,,,'ERRO DELETE', 'MEDICAO ENCERRADA NAO PODE SER DELETADA')
                return .F.    
            endif

        Elseif cAction == 'SETVALUE'
            if cField == 'Z53_CODPRD'
                lValid := .T.
                cAliasSql := getNextAlias()
                BeginSql alias cAliasSql
                    SELECT * FROM %table:Z52% Z52
                    WHERE Z52.%notdel%
                    AND Z52_FILIAL = %exp:xFilial('Z52')%
                    AND Z52_NUMERO = %exp:fwFldGet('Z52_NUMERO')%
                    AND Z52_CODPRD = %exp:xValue%
                EndSql
                
                nRecZ52 := 0
                (cAliasSql)->(dbEval({|| nRecZ52 := R_E_C_N_O_}), dbCloseArea())

                if nRecZ52 == 0
                    oModel:setErrorMessage(,,,,'ERRO PRODUTO', 'PRODUTO DIGITADO NAO ENCONTRADO NO CONTRATO')
                    return .F.
                endif

                Z52->(dbSetOrder(1), dbGoTo(nRecZ52))
                //atualiza��o de campos numa tela mvc - fwFldPut()
                
                fwFldPut('Z53_DESPRD', Z52->Z52_DESPRD)
                fwFldPut('Z53_LOCEST', Z52->Z52_LOCEST)
                fwFldPut('Z53_VALOR', fwFldGet('Z53_QTD') * Z52->Z52_VLRUNI)

            elseif cField == 'Z53_QTD'

                cAliasSql := getNextAlias()
                BeginSql alias cAliasSql
                    SELECT * FROM %table:Z52% Z52
                    WHERE Z52.%notdel%
                    AND Z52_FILIAL = %exp:xFilial('Z52')%
                    AND Z52_NUMERO = %exp:fwFldGet('Z53_NUMERO')%
                    AND Z52_CODPRD = %exp:fwFldGet('Z53_CODPRD')%
                EndSql
                
                nRecZ52 := 0
                (cAliasSql)->(dbEval({|| nRecZ52 := R_E_C_N_O_}), dbCloseArea())

                Z52->(dbSetOrder(1), dbGoTo(nRecZ52))
                fwFldPut('Z53_VALOR', xValue * Z52->Z52_VLRUNI)
            
            endif
        endif
    endif

Return lValid


/*/{Protheus.doc} vGridPos/*/
Static Function vGridPos(oGridModel, nLine, nOpcao)
    
    local lValid := .t.

Return lValid

/*/{Protheus.doc} vGridLoad/*/
Static Function vGridLoad(oGridModel, lCopy)

    local aLoad := formLoadGrid(oGridModel, lCopy)
    
Return aLoad


/*/{Protheus.doc} fnValid/*/
Static Function fnValid
    
    local lValid := .T.
    local cCampo := strtran(readVar(), "M->", "")
    local oModel := fwModelActive()

    Do Case
    Case cCampo == "Z53_NUMERO" 
        lValid := existCpo('Z51', M->Z53_NUMERO, 1)
        Z51->(dbSetOrder(1), dbSeek(xFilial(alias())+M->Z53_NUMERO))
        lValid := Z51->(found())

        if lValid

            oModel:getModel('Z53MASTER'):setValue('Z53_TIPO', Z51->Z51_TIPO)
            return lValid
        endif
        
    EndCase


Return lValid

Static Function fModelPos(oModel)
    
    local lValid := .T.
    local oModGrid := oModel:getModel('Z53DETAIL')
    local x

    if  oModel:getOperation() == 5
        
        for x := 1 to oModGrid:length()
            oModGrid:goLine(x)
            if oModGrid:getValue('Z53_STATUS') == 'E'
                oModel:setErrorMessage(,,,,'ERRO', 'ESSA MEDICAO POSSUI ITENS ENCERRADOS. NAO PODE SER EXCLUIDA')
                return .F.
            endif
        next

    endif



Return lValid
