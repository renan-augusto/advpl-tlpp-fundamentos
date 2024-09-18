#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} U_GCTMBM01
    (long_description)
    @type  Function
    @author Renan Augusto
    @since 05/09/2024
/*/
Function U_GCTMBM01
    
    Private aRotina     := menudef()
    Private oBrowse     := fwMBrowse():new() //seria a mbrowse do tradicional porém aqui usamos uma classe 

    oBrowse:setAlias('Z50')
    oBrowse:setDescription('Tipos de contrato')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("Z50_TIPO == 'V' ", "BR_AMARELO", "Vendas"              )
    oBrowse:addLegend("Z50_TIPO == 'C' ", "BR_LARANJA", "Compras"             )
    oBrowse:addLegend("Z50_TIPO == 'S' ", "BR_CINZA"  , "Sem Integracao"      )
    oBrowse:activate()

Return

/*/{Protheus.doc} menudef
    Uma das tres static functions fixas. Menu Def sera responsavel pela montagem de estrutura de menu
    @type  Static Function
    @author Renan Augusto
    @since 05/09/2024

/*/
Static Function menudef
    
    Local aRotina       := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'axPesqui'              OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.GCTBM01'       OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.GCTBM01'       OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.GCTBM01'       OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.GCTBM01'       OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'     ACTION 'VIEWDEF.GCTBM01'       OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'       ACTION 'VIEWDEF.GCTBM01'       OPERATION 9 ACCESS 0


Return aRotina

/*/{Protheus.doc} viewdef
    uma das statics de noome fixo
    sera a aplicacao responsavel pela construcao da interface grafica
    @type  Static Function
    @author Renan Augusto
    @since 05/09/2024
/*/
Static Function viewdef
    
    local oView
    local oModel //um componente viewdef tem que fazer referencia ao model
    local oStruct //estrutura de campos do dicionario de dados, indicarei qual a tabela que sera referenciada pela interface grafica

    oStruct                 := fwFormStruct(2, 'Z50') //funcao que retorna a estrutura de campos/tabela/indice. 
    //parametros da fwFormStruct, primeiro é um inteiro que identifica se ela esta sendo usada na viewdef ou para uma model def
    //o outro parametro é o alias da tabela de onde ela deve extrair a estrutura a ser utilizada

    oModel                  := fwLoadModel('GCTBM01') 
    //funcao faz a carga do model da aplicação. Tenho que passar para ela o nome do arquivo que tem esse model

    oView                   := fwFormView():new()

    //configurando o nosso view => lembrando que instanciei ele com um objeto
    oView:setModel(oModel)
    oView:addField('Z50MASTER', oStruct, 'Z50MASTER')
    oView:createHorizontalBox('BOXZ50', 100)
    oView:setOwnerView('Z50MASTER', 'BOXZ50')

    
Return oView

/*/{Protheus.doc} modeldef
     uma das statics de noome fixo
    sera a aplicacao responsavel pela construcao das regras de negocio 
    @type  Static Function
    @author Renan Augusto
    @since 05/09/2024
/*/
Static Function modeldef

    local oModel
    local oStruct
    local aTrigger
    local bModelPre := {|x| fnModPre(x)} //evento de pre-validacao de modelo
    local bModelPos := {|x| fnModPos(x)} //validacao tudook - identifica a ultima validacao executada na aplicacao.
    local bCommit   := {|x| fnCommit(x)} //funcao que fara a gravacao dos dados no banco, retorno verdadeiro ou falso para indicar a gravacao ou nao 
    local bCancel   := {|x| fnCancel(x)} //funcao executada quando o usuario clicar em cancelar

    oStruct         := fwFormStruct(1, 'Z50') //objeto gerado a partir da FWFormStruct
    oModel          := mpFormModel():new('MODEL_GCTBM001', bModelPre, bModelPos, bCommit, bCancel) 

    aTrigger        := fwStruTrigger('Z50_TIPO', 'Z50_CODIGO', 'U_GCTT001()',.F., Nil, Nil, Nil, Nil)
                        //funcao utilizada para a criacao do gatilho
    oStruct:addTrigger(aTrigger[1], aTrigger[2], aTrigger[3], aTrigger[4]) //metodo do struct que aciona o trigger. REceber as 4 primeiras posicoes que o fwstrutrigger retornar
    oStruct:setProperty('Z50_TIPO', MODEL_FIELD_WHEN, {|| inclui}) //inclui-> variavel publica que vai verificar se estou numa inclusao

    oModel:addFields('Z50MASTER',, oStruct) //cuidado, na modeldef é addFields no plural
    oModel:setDescription('Tipos de contratos')
    oModel:setPrimaryKey({'Z50_FILIAL', 'Z50_CODIGO'}) // método não obrigatório desde que isso esteja definido na sx2 (diciionario de dados)

Return oModel

/*/{Protheus.doc} fnModPre
    Funcao de pre-validacao do modelo de dados
    @type  Static Function
/*/
Static Function fnModPre(oModel)
    //por meio do objeto model vamos identificar qual tipo de operacao está sendo executada e qual o campo alterado
    local lValid        := .T.
    local nOperation    := oModel:getOperation()
    local cCampo        := strtran(readvar(), "M->", "") //retorna qual o campo que esta sendo editado

    if nOperation == 4  //representa qual o tipo de operacao
        if cCampo == 'Z50_DESCRI'
            //setErrorMessage retorna o texto para a mensagem padrao mvc
            oModel:setErrorMessage(,,,,'ERRO DE VALIDACAO', 'ESSE CAMPO NAO PODE SER EDITADO')
            lValid := .F. 
        endif
    endif

Return lValid

/*/{Protheus.doc} fnModPos
    Funcao de validacao final do modelo de dados
    @type  Static Function
/*/
Static Function fnModPos(oModel)

    local lValid := .T.
    
Return lValid

/*/{Protheus.doc} fnCommit
    Funcao executada para gravacao dos dados
    @type  Static Function
/*/
Static Function fnCommit(oModel)

    local lCommit := fwFormCommit(oModel) //funcao que faz a gravacao dos dados e retorna se foram gravados ou nao
    
Return lCommit

/*/{Protheus.doc} fnCancel
    Funcao executada para validacao do cancelamento dos dados
    @type  Static Function
/*/
Static Function fnCancel(oModel)
    
    local lCancel := fwFormCancel(oModel) //fwFormCancel desfaz "reservas" que precisam ser desfeitas (confirmsx8 por exemplo)


Return lCancel

/*/{Protheus.doc} U_GCTT001
    Funcao para execucao do gatilho de codigo
    @type  Function
/*/
Function U_GCTT001
    
    Local cNovoCod      := ''
    Local cAliasSQL     := ''
    Local oModel        := fwModelActive() //retorna o model que esta em execucao naquele momento
    Local nOperation    := 0

    nOperation          := oModel:getOperation()

    if .not. (nOperation == 3 .or. nOperation == 9)
        
        cNovoCod        := oModel:getModel('Z50MASTER'):getValue('Z50_CODIGO') //metodo de consulta grid

        return cNovoCod

    endif

    cAliasSQL           := getNextAlias() //funcao que gera alias aleatorio

    BeginSQL alias cAliasSQL
        
        SELECT COALESCE(MAX(Z50_CODIGO), '00') Z50_CODIGO
        FROM %table:Z50% Z50
        WHERE Z50.%notdel%
        AND Z50_FILIAL = %exp:xFilial('Z50')%
        AND Z50_TIPO   = %exp:M->Z50_TIPO%

    EndSQL

    //ffuncao getlastquery - posso pegar a ultima query no debugger

    (cAliasSQL)->(dbEval({|| cNovoCod := alltrim(Z50_CODIGO)}), dbCLoseArea())

    if cNovoCod = '00'
        
        cNovoCod    := M->Z50_TIPO + '01'
    
    else
        
        cNovoCod    := soma1(cNovoCod)

    endif


Return cNovoCod
