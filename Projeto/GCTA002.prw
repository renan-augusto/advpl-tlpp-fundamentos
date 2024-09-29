#include 'totvs.ch'


/*/{Protheus.doc} U_GCTA002
    (long_description)
    @type  Function
    @author user
    @since 23/09/2024
/*/
Function U_GCTA002
    
    Private cTitulo     := 'Cadastro de contratos - prototipo modelo 3'
    Private aRotina[0]

    //montagem de array de itens do menu
    aadd(aRotina, {'Pesquisar'      ,'AxPesqui'     ,0,1})
    aadd(aRotina, {'Visualizar'     ,'U_GCTA002M'   ,0,2})
    aadd(aRotina, {'Incluir'        ,'U_GCTA002M'   ,0,3})
    aadd(aRotina, {'Alterar'        ,'U_GCTA002M'   ,0,4})
    aadd(aRotina, {'Excluir'        ,'U_GCTA002M'   ,0,5})

    //montagem da tela principal
    Z51->(dbSetOrder(1), mbrowse(,,,,alias()))

Return

Function U_GCTA002M(cAlias, nReg, nOpc)
    
    //nome utilizado para a construcao de interface (convencionado)
    local oDlg, oGet
    local aAdvSize      := msAdvSize()
    local aInfo         := {aAdvSize[1], aAdvSize[2], aAdvSize[3], aAdvSize[4], 3, 3}
    local aObj          := {{100, 120, .T., .F.}, {100, 100, .T., .T.}, {100, 010, .T., .F.}} //medidas dos componentes
    local aPObj         := msObjSize(aInfo, aObj) //recebe medidas gerais e as medidas que eu quero que o componente grafico tenha
    local nStyle        := GD_INSERT+GD_UPDATE+GD_DELETE //conjunto de constantes que o totvs.ch já inicia por padrão
    local nSalvar       := 0
    local bSalvar       := {|| if(obrigatorio(aGets, aTela), (nSalvar := 1, oDlg:end()), nil)} //funcao obrigatorio identifica os campos obrigatorios
                                //parametros da funcao obrigatorio aGets, aAtela precisam ser declarados como private 
    local bCancelar     := {|| (nSalvar := 0, oDlg:end())}
    local aButtons      := array(0)
    local aHeader       := fnGetHeader()
    local aCols         := fnGetCols(nOpc, aHeader)

    private aGets       := array(0)
    private aTela       := array(0)
    //tenho que usar o nome aGets e aTela pq a msmGet vai atualizar essas variaveis para identificar se os campos estão ou não preenchidos

    oDlg            := tDialog():new(0              ,; // coordenada inicial, linha inicial (Pixels)
                                     0              ,; // coordenada inicial, coluna inicial    
                                     aAdvSize[6]    ,; // coordenada final, coluna final
                                     aAdvSize[5]    ,; // coordenada final, linha final
                                     cTitulo        ,; // titulo da janela
                                     Nil            ,; // fixo
                                     Nil            ,; // fixo
                                     Nil            ,; // fixo
                                     Nil            ,; // fixo
                                     CLR_BLACK      ,; // Cor do texto
                                     CLR_WHITE      ,; // Cor de fundo da tela
                                     Nil            ,; // fixo
                                     Nil            ,; // fixo
                                     .T.            ) // indica que as coordenadas serao em pixel

    // -- Cabecalho 
    regToMemory(cAlias, if(nOpc == 3, .T., .F.), .T.) //outra forma de criar variavel de memoria
    msmGet():new(cAlias, nReg, nOpc,,,,,aPObj[1]) //realiza montagem do objeto
    // enchoice(cAlias, nReg, nOpc,,,,,aPObj[1]) //faz a mesma coisa que o msmGet faz porem é uma funcao
    enchoicebar(oDlg, bSalvar, bCancelar,,aButtons)

    // -- Area de Itens
    
    oGet    := msNewGetDados():new(aPObj[2,1]       ,; //coordenada inicial, linha inicial
                                   aPObj[2,2]       ,; //coordenada inicial, coluna inicial
                                   aPObj[2,3]       ,; //coordenada final, coluna final
                                   aPObj[2,4]       ,; //coordenada final, linha final
                                   nStyle           ,; // opcoes que podem ser executadas
                                   'allwaysTrue()'  ,; // validacao de mudanca de linha
                                   'allwaysTrue()'  ,; // validacao final
                                   '+Z52_ITEM'      ,; // definicao do campo incremental
                                   Nil              ,; // lista dos campos que podem ser alterados (passaria num vetor)
                                   0                ,; // fixo
                                   9999             ,; // total de linhas
                                   'allwaysTrue()'  ,; // funcao que validara cada campo preenchido
                                   nil              ,; // fixo
                                   'allwaysTrue()'  ,; // funcao que ira validar se a linha pode ser deletada
                                   oDlg             ,; // objeto proprietario
                                   aHeader          ,; // Vetor com as configuracoes dos campos
                                   aCols            )  // Vetor com os conteudos dos campos
                                   


    oDlg:activate()

Return 

/*/{Protheus.doc} fnGetHeader
    gera as configuracoes dos campos da msNewGetDados
    @type  Static Function
/*/
Static Function fnGetHeader
    
    local aHeader   := array(0)
    local aAux      := array(0)

    SX3->(dbSetOrder(1), dbSeek("Z52"))

    while .not. SX3->(eof() .and. SX3->X3_ARQUIVO == 'Z52')

        //evitando com que o numero do contrato e a filial aparecam na tela
        if alltrim(SX3->X3_CAMPO) $ 'Z52_FILIAL|Z52_NUMERO'
            SX3->(dbSkip())
            Loop
        endif

        aAux := {}
        aadd(aAux, SX3->X3_TITULO)
        aadd(aAux, SX3->X3_CAMPO)
        aadd(aAux, SX3->X3_PICTURE)
        aadd(aAux, SX3->X3_TAMANHO)
        aadd(aAux, SX3->X3_DECIMAL)
        aadd(aAux, SX3->X3_VALID)
        aadd(aAux, SX3->X3_USADO)
        aadd(aAux, SX3->X3_USADO)
        aadd(aAux, SX3->X3_TIPO)
        aadd(aAux, SX3->X3_F3)
        aadd(aAux, SX3->X3_CONTEXT)
        aadd(aAux, SX3->X3_CBOX)
        aadd(aAux, SX3->X3_RELACAO)
        aadd(aAux, SX3->X3_WHEN)
        aadd(aAux, SX3->X3_VISUAL)
        aadd(aAux, SX3->X3_VLDUSER)
        aadd(aAux, SX3->X3_PICTVAR)
        aadd(aAux, SX3->X3_OBRIGAT)

        aadd(aHeader, aAux)
        SX3->(dbSkip())
        
    enddo

Return aHeader

/*/{Protheus.doc} fnGetCols
    retorna o conteudo do vetor aCols
    @type  Static Function
/*/
Static Function fnGetCols(nOpc, aHeader)
    
    local aCols := array(0)
    local aAux  := array(0)

    if nOpc == 3 // operacao de inclusao
        //fuincao criavar cria um conteudo para o campo baseado na configuracao dele
        aEval(aHeader, {|x| aadd(aAux, criavar(x[2],.T.))}) //executa um laco de repeticao dentro de um vetor(tipo um map)
        aadd(aAux, .F.)
        aadd(aCols, aAux)
        return aCols
    endif

    // alteracao + visualizacao + exclusao
    Z52->(dbSetOrder(1), dbSeek(Z51->(Z51_FILIAL+Z51_NUMERO)))

    while .not. Z52->(eof()) .and. Z52->(Z52_FILIAL+Z52_NUMERO) == Z51->(Z51_FILIAL+Z51_NUMERO)
        aAux := {}
        aEval(aHeader,{|x| aadd(aAux, Z52->&(x[2]))})
        aadd(aAux, .F.)
        aadd(aCols, aAUx)
        Z52->(dbSkip())
    enddo

Return aCols
