#include 'totvs.ch'

/*/{Protheus.doc} U_GCTA001
    Cadastro de tipos de contratos (modelo 1).
    @author Renan Augusto
    @since 28/08/2024
    @version 1.0
    @see (links_or_references)
    /*/
Function U_GCTA001

    Local nOpcPad       := 4
    Local aLegenda      := {}

    aadd(aLegenda, {"Z50_TIPO == 'V'", "BR_AMARELO"})
    aadd(aLegenda, {"Z50_TIPO == 'C'", "BR_LARANJA"})
    aadd(aLegenda, {"Z50_TIPO == 'S'", "BR_CINZA"})

    Private cCadastro   := 'Cadastro de tipos de contratos'
    Private aRotina     := {}  //monta a estrutra de menus que a tela terá     
    
    aadd(aRotina, {"Pesquisar"  ,"axPesqui",  0, 1})
    aadd(aRotina, {"Visualizar" ,"axVisual",  0, 2})
    aadd(aRotina, {"Incluir"    ,"axInclui",  0, 3})
    aadd(aRotina, {"Alterar"    ,"axAltera",  0, 3})
    aadd(aRotina, {"Excluir"    ,"U_GCTA001D",  0, 5})
    aadd(aRotina, {"Legendas"   ,"U_GCTA001L", 0, 6})

    dbSelectArea("Z50")
    dbSetOrder(1)

    mBrowse(,,,,alias(),,,,,nOpcPad, aLegenda) //funcao que monta o tipo de interface padrão visto em cadastros.

Return


/*/{Protheus.doc} U_GCTA001D
    Programa auxiliar para exclusao de item
    @type  Function
    @author Renan Augusto

    /*/
Function U_GCTA001D(cAlias, nReg, nOpc)
    
    Local cAliasSQL     := ''
    Local lExist        := .F.

    cAliasSQL           := getNextAlias() //utilizada para obter um alias aleatorio

    BeginSQL alias cAliasSQL

        SELECT * FROM %table:Z51% Z51
        WHERE Z51.%notdel%
        AND Z51_FILIAL = %exp:xFilial('Z51')%
        AND Z51_TIPO = %exp:Z50->Z50_CODIGO%
        LIMIT 1

    EndSQL

    (cAliasSQL)->(dbEval({|| lExist := .T.}), dbCloseArea())

    if lExist
        
        fwAlertWarning('Tipo de contrato ja utilizado!', 'Atenção')
        return .F.

    endif

    
Return axDeleta(cAlias, nReg, nOpc)


/*/{Protheus.doc} U_GCTA001L
    Funcao auxiliar para descricao das legendas
    @type  Function
    @author Renan Augusto
    @since 03/09/2024
/*/
Function U_GCTA001L
    
    Local aLegenda := array(0)

    aadd(aLegenda, {"BR_AMARELO", "Contrato de vendas"})
    aadd(aLegenda, {"BR_LARANJA", "Contrato de compras"})
    aadd(aLegenda, {"BR_CINZA"  , "Sem integração"})

Return brwLegenda("Tipos de contratos", "Legenda", aLegenda)
