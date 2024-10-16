#include 'totvs.ch'
#include 'tbiconn.ch'


/*/{Protheus.doc} U_GCTA003
    Exemplo de programa prototipo modelo 2 advpl tradicional
/*/
Function U_GCTA003
    
    Private cTitulo     := 'Registro de medi��es de contratos - modelo 2 - ADVPL Tradicional'
    Private aRotina[0]

    //montagem de array de itens do menu
    aadd(aRotina, {'Pesquisar'      ,'AxPesqui'     ,0,1})
    aadd(aRotina, {'Visualizar'     ,'U_GCTA003M'   ,0,2})
    aadd(aRotina, {'Incluir'        ,'U_GCTA003M'   ,0,3})
    aadd(aRotina, {'Alterar'        ,'U_GCTA003M'   ,0,4})
    aadd(aRotina, {'Excluir'        ,'U_GCTA003M'   ,0,5})

    //montagem da tela principal
    Z53->(dbSetOrder(1), mbrowse(,,,,alias()))

Return

Function U_GCTA003M(cAlias, nReg, nOpc)
    
    //nome utilizado para a construcao de interface (convencionado)
    local oDlg
    local aAdvSize      := msAdvSize()
    local aInfo         := {aAdvSize[1], aAdvSize[2], aAdvSize[3], aAdvSize[4], 3, 3}
    local aObj          := {{100, 060, .T., .F.}, {100, 100, .T., .T.}, {100, 010, .T., .F.}} //medidas dos componentes
    local aPObj         := msObjSize(aInfo, aObj) //recebe medidas gerais e as medidas que eu quero que o componente grafico tenha
    local nStyle        := GD_INSERT+GD_UPDATE+GD_DELETE //conjunto de constantes que o totvs.ch j� inicia por padr�o
    local nSalvar       := 0
    local bSalvar       := {|| if(obrigatorio(aGets, aTela), (nSalvar := 1, oDlg:end()), nil)} //funcao obrigatorio identifica os campos obrigatorios
                                //parametros da funcao obrigatorio aGets, aAtela precisam ser declarados como private 
    local bCancelar     := {|| (nSalvar := 0, oDlg:end())}
    local aButtons      := array(0)
    local aHeader       := fnGetHeader()
    local aCols         := fnGetCols(nOpc, aHeader)

    private oGet
    private aGets       := array(0)
    private aTela       := array(0)
    //tenho que usar o nome aGets e aTela pq a msmGet vai atualizar essas variaveis para identificar se os campos est�o ou n�o preenchidos

    //instancia a fonte que vai ser utilizada. Fonte disponivel e aquela do SO 
    private oFonte      := tFont():new('Courier New',,20,,.T.)  

    //tambem funciona se eu acessar a propriedade e fazer o preenchimento
    // oFonte:lItalic := .T. 


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
    // -- Construcao do cabecalho - modelo 2 #
    enchoicebar(oDlg, bSalvar, bCancelar,,aButtons)

    // -- Area de Itens
    
    oGet    := msNewGetDados():new(aPObj[2,1]       ,; //coordenada inicial, linha inicial
                                   aPObj[2,2]       ,; //coordenada inicial, coluna inicial
                                   aPObj[2,3]       ,; //coordenada final, coluna final
                                   aPObj[2,4]       ,; //coordenada final, linha final
                                   nStyle           ,; // opcoes que podem ser executadas
                                   'U_GCTA003V(1)'  ,; // validacao de mudanca de linha
                                   'U_GCTA003V(2)'  ,; // validacao final
                                   '+Z53_ITEM'      ,; // definicao do campo incremental
                                   Nil              ,; // lista dos campos que podem ser alterados (passaria num vetor)
                                   0                ,; // fixo
                                   9999             ,; // total de linhas
                                   'U_GCTA003V(3)'  ,; // funcao que validara cada campo preenchido
                                   nil              ,; // fixo
                                   'U_GCTA003V(4)'  ,; // funcao que ira validar se a linha pode ser deletada
                                   oDlg             ,; // objeto proprietario
                                   aHeader          ,; // Vetor com as configuracoes dos campos
                                   aCols            )  // Vetor com os conteudos dos campos
                                   


    oDlg:activate()

    if nSalvar == 1
        //funcao de gravacao dos dados
        fnGravar(nOpc, aHeader, oGet:aCols)
        //preciso verificar se depois da gravacao se o getsxenum foi acionado
        if  __lSX8
            confirmsx8() //vai confirmar e avan�ar para o pr�ximo n�mero 
        endif
    else  //caso usuario clique em cancelar
        if __lSX8 //nesse if eu libero aquele numero novamente para uso. 
            rollbackSX8() 
        endif
    endif

Return

/*/{Protheus.doc} nomeFunction
    Valida as linhas do grid
    /*/
Function U_GCTA003V(nOpcao)
    
    local lValid := .T.

    if nOpcao == 1 //validacao de mudanca de linha
        lValid  := oGet:chkObrigat(n) //funcao que verifica se todos os campos obrigatorios foram preenchidos
    
    elseif nOpcao == 2 // validacao final
    elseif nOpcao == 3 // Validacao dos campos 
    elseif nOpcao == 4 // Validacao de delecao da linha

    endif

Return lValid  //funcoes de validacao tem que retornar um logical

/*/{Protheus.doc} fnGravar(nOpc)
    funcao auxiliar para gravacao
    @type  Static Function
/*/
Static Function fnGravar(nOpc, aHeader, aCols)
    
    local x, y
    local nCampos
    local cCampo
    local xConteudo
    local aLinha[0]
    local lDelete
    local lFound
    local lInc

    BEGIN TRANSACTION // abertura do controle de transacoes
    
    Do Case
    
        Case nOpc == 3 // inclusao

            for x := 1 to Len(aCols)
                
                aLinha := aClone(aCols[x])
                lDelete := aLinha[len(aLinha)] 
                //o campo que determina se o registro esta deletado fica na ultima posicao
                //por isso foi utilizado o len(aLinha)

                if lDelete
                    Loop
                endif 

                Z53->(reclock(alias(), .T.))
                    for y := 1 to Len(aHeader)
                        cCampo := aHeader[y, 2] //segunda posicao vai ser o nome do nosso campo
                        xConteudo := aCols[x,y] //recuperando o conteudo do campo
                        Z53->&(cCampo) := xConteudo
                    next

                    //-- Gravacao dos dados do cabecalho #

                Z53->(msunlock())

            next
        Case nOpc == 4 // alteracao

            // gravacao dos itens
            for x := 1 to Len(aCols)

                //Z53->(dbSetOrder(1), dbSeek(xFilial(alias())+M->Z53_NUMERO+aCols[x,1])) 
                lFound := Z53->(found()) //se a linha estiver deletada verificar se ela existe no banco de dados
                aLinha := aClone(aCols[x])
                lDelete := aLinha[len(aLinha)] 
                //o campo que determina se o registro esta deletado fica na ultima posicao
                //por isso foi utilizado o len(aLinha)

                if lDelete
                    
                    if lFound
                        Z53->(reclock(alias(), .F.), dbDelete(), msunlock)
                    endif

                    Loop
                endif

                lInc := .not. lFound

                Z53->(reclock(alias(), lInc))
                    for y := 1 to Len(aHeader)
                        cCampo := aHeader[y, 2] //segunda posicao vai ser o nome do nosso campo
                        xConteudo := aCols[x,y] //recuperando o conteudo do campo
                        Z53->&(cCampo) := xConteudo
                    next

                    Z53->Z53_FILIAL := xFilial('Z53')
                    Z53->Z53_NUMERO := M->Z53_NUMERO

                Z53->(msunlock())

            next

        Case nopc == 5 // exclusao

        
    EndCase

    END TRANSACTION // encerramento do controle de transacoes
Return

/*/{Protheus.doc} fnGetHeader
    gera as configuracoes dos campos da msNewGetDados
    @type  Static Function
/*/
Static Function fnGetHeader
    
    local aHeader   := array(0)
    local aAux      := array(0)

    SX3->(dbSetOrder(1), dbSeek("Z53"))

    while .not. SX3->(eof() .and. SX3->X3_ARQUIVO == 'Z53')

        //evitando com que o numero do contrato e a filial aparecam na tela
        if alltrim(SX3->X3_CAMPO) $ 'Z53_FILIAL|Z53_NUMERO|Z53_NUMMED|Z53_EMISSAO|Z53_TIPO'
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
        aAux[1] := '001' //resolvendo inicializa��o do campo item
        aadd(aAux, .F.)
        aadd(aCols, aAux)
        return aCols
    endif

    // alteracao + visualizacao + exclusao
    cChaveZ53 :=  Z53->(Z53_FILIAL+Z53_NUMERO+Z53_NUMMED)
    Z53->(dbSetOrder(1), dbSeek(cChaveZ53))

    while .not. Z53->(eof()) .and. Z53->(Z53_FILIAL+Z53_NUMERO+Z53_NUMMED) == cChaveZ53
        aAux := {}
        aEval(aHeader,{|x| aadd(aAux, Z53->&(x[2]))})
        aadd(aAux, .F.)
        aadd(aCols, aAUx)
        Z53->(dbSkip())
    enddo

Return aCols
