#include 'totvs.ch'

/*/{Protheus.doc} U_GCTM04
    Exemplo de funcao markbrows
    Componente de marcacao utilizando advpl tradicional
    @see fwMarkBrowse
    /*/
Function U_GCTM04

    local aCamposTmp := array(0)

    private cAliasTmp := getNextAlias()
    private cALiasSQL := getNextAlias()
    private cMarca := getMark()
    private cCadastro := 'Encerramento de medições (MVC)'
    private aRotina := array(0)
    private oTempTable

    aadd(aRotina, {"Processar", "U_PROCESSA_ENCERRAMENTO_MEDICOES()", 0, 3})

    aadd(aCamposTmp, {"MARK", "C", 2, 0})
    aadd(aCamposTmp, {"Z53_NUMERO", "C", tamSx3("Z53_NUMERO")[1], tamSx3("Z53_NUMERO")[2]})
    aadd(aCamposTmp, {"Z53_TIPO", "C", tamSx3("Z53_TIPO")[1], tamSx3("Z53_TIPO")[2]})
    aadd(aCamposTmp, {"Z53_NUMMED", "C", tamSx3("Z53_NUMMED")[1], tamSx3("Z53_NUMMED")[2]})
    aadd(aCamposTmp, {"Z53_EMISSA", "C", tamSx3("Z53_EMISSA")[1], tamSx3("Z53_EMISSA")[2]})
    aadd(aCamposTmp, {"Z53_ITEM", "C", tamSx3("Z53_ITEM")[1], tamSx3("Z53_ITEM")[2]})
    aadd(aCamposTmp, {"Z53_CODPRD", "C", tamSx3("Z53_CODPRD")[1], tamSx3("Z53_CODPRD")[2]})
    aadd(aCamposTmp, {"Z53_DESPRD", "C", tamSx3("Z53_DESPRD")[1], tamSx3("Z53_DESPRD")[2]})
    aadd(aCamposTmp, {"Z53_QTD", "N", tamSx3("Z53_QTD")[1], tamSx3("Z53_QTD")[2]})
    aadd(aCamposTmp, {"Z53_VALOR", "N", tamSx3("Z53_VALOR")[1], tamSx3("Z53_VALOR")[2]})
    aadd(aCamposTmp, {"Z53_PEDIDO", "C", tamSx3("Z53_PEDIDO")[1], tamSx3("Z53_PEDIDO")[2]})
    aadd(aCamposTmp, {"Z53_STATUS", "C", tamSx3("Z53_STATUS")[1], tamSx3("Z53_STATUS")[2]})

    oTempTable := fwTemporaryTable():new(cAliasTmp, aCamposTmp)
    oTempTable:create()

    BeginSQL alias cALiasSQL
        COLUMN Z53_EMISSA AS DATE
        SELECT * FROM %table:Z53% Z53
        WHERE Z53.%notdel%
        AND Z53_FILIAL = %exp:xFilial("Z53")%
        AND Z53_STATUS <> 'E'
        ORDER BY Z53_FILIAL, Z53_NUMERO, Z53_NUMMED, Z53_ITEM
    EndSQL

    while .not. (cALiasSQL)->(eof())
        (cAliasTmp)->(dbAppend())
        
        // (cAliasTmp)->MARK           := cMarca
        (cAliasTmp)->Z53_NUMERO     := (cALiasSQL)->Z53_NUMERO
        (cAliasTmp)->Z53_TIPO       := (cALiasSQL)->Z53_TIPO
        (cAliasTmp)->Z53_NUMMED     := (cALiasSQL)->Z53_NUMMED
        (cAliasTmp)->Z53_EMISSA     := (cALiasSQL)->Z53_EMISSA
        (cAliasTmp)->Z53_ITEM       := (cALiasSQL)->Z53_ITEM
        (cAliasTmp)->Z53_CODPRD     := (cALiasSQL)->Z53_CODPRD
        (cAliasTmp)->Z53_DESPRD     := (cALiasSQL)->Z53_DESPRD
        (cAliasTmp)->Z53_QTD        := (cALiasSQL)->Z53_QTD
        (cAliasTmp)->Z53_VALOR      := (cALiasSQL)->Z53_VALOR
        (cAliasTmp)->Z53_PEDIDO     := (cALiasSQL)->Z53_PEDIDO
        (cAliasTmp)->Z53_STATUS     := (cALiasSQL)->Z53_STATUS

        (cAliasTmp)->(dbCommit())
        
        (cALiasSQL)->(dbSkip())
    enddo

    (cALiasSQL)->(dbCloseArea())
    (cAliasTmp)->(dbGoTop())

    aCampos := array(0)
    aadd(aCampos, {"Contrato"   , "Z53_NUMERO"  ,"C" ,tanSX3("Z53_NUMERO" )[1],tanSX3("Z53_NUMERO" )[2], getSx3Cache("Z53_NUMERO" , "X3_PICTURE")})
    aadd(aCampos, {"Tipo Ctr"   , "Z53_TIPO"    ,"C" ,tanSX3("Z53_TIPO"   )[1],tanSX3("Z53_TIPO"   )[2], getSx3Cache("Z53_TIPO"   , "X3_PICTURE")})
    aadd(aCampos, {"Medicao"    , "Z53_NUMMED"  ,"C" ,tanSX3("Z53_NUMMED" )[1],tanSX3("Z53_NUMMED" )[2], getSx3Cache("Z53_NUMMED" , "X3_PICTURE")})
    aadd(aCampos, {"Dt Emiss"   , "Z53_EMISSA"  ,"D" ,tanSX3("Z53_EMISSA" )[1],tanSX3("Z53_EMISSA" )[2], getSx3Cache("Z53_EMISSA" , "X3_PICTURE")})
    aadd(aCampos, {"Item"       , "Z53_ITEM"    ,"C" ,tanSX3("Z53_ITEM"   )[1],tanSX3("Z53_ITEM"   )[2], getSx3Cache("Z53_ITEM"   , "X3_PICTURE")})
    aadd(aCampos, {"Produto"    , "Z53_CODPRD"  ,"C" ,tanSX3("Z53_CODPRD" )[1],tanSX3("Z53_CODPRD" )[2], getSx3Cache("Z53_CODPRD" , "X3_PICTURE")})
    aadd(aCampos, {"Descricao"  , "Z53_DESPRD"  ,"C" ,tanSX3("Z53_DESPRD" )[1],tanSX3("Z53_DESPRD" )[2], getSx3Cache("Z53_DESPRD" , "X3_PICTURE")})
    aadd(aCampos, {"Quantidade" , "Z53_QTD"     ,"N" ,tanSX3("Z53_QTD"    )[1],tanSX3("Z53_QTD"    )[2], getSx3Cache("Z53_QTD"    , "X3_PICTURE")})
    aadd(aCampos, {"Valor"      , "Z53_VALOR"   ,"N" ,tanSX3("Z53_VALOR"  )[1],tanSX3("Z53_VALOR"  )[2], getSx3Cache("Z53_VALOR"  , "X3_PICTURE")})
    aadd(aCampos, {"Pedido"     , "Z53_PEDIDO"  ,"C" ,tanSX3("Z53_PEDIDO" )[1],tanSX3("Z53_PEDIDO" )[2], getSx3Cache("Z53_PEDIDO" , "X3_PICTURE")})
    aadd(aCampos, {"Status"     , "Z53_STATUS"  ,"C" ,tanSX3("Z53_STATUS" )[1],tanSX3("Z53_STATUS" )[2], getSx3Cache("Z53_STATUS" , "X3_PICTURE")})
    
    oBrowse := fwMarkBrowse():new()
    oBrowse:setAlias(cAliasTmp)
    oBrowse:setDescription(cCadastro)
    oBrowse:setTemporary(.T.)
    oBrowse:setFields(aCampos)
    oBrowse:setFieldMark('MARK')
    oBrowse:addLegend("Z53_STATUS == 'E' ", "BR_AMARELO", "Encerrado")
    oBrowse:addLegend("Z53_STATUS != 'E' ", "BR_VERDE  ", "Pendente" )
    oBrowse:activate()

    //e)[1]    //excluindo o arquivo temporario
    oTempTable:delete()
    
Return
