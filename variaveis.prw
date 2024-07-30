#include 'totvs.ch'

    Static cTexto3 := 'novo texto' //utilizado para variaveis que podem ser acessadas por qualquer funcao dentro 
                                   //do arquivo, podem inclusive ser declaradas fora de funcoes

/*/{Protheus.doc} variaveis
    (long_description)
    @type  Function
    @author Renan Augusto
    @since 13/07/2024
    @version 1.0
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Function U_VARIAVEIS
    //primeiro ajuste de uma funcao é declarar variaveis de escopo local

    Local cTexto := '' //escopo local indica que a variavel apenas podera ser manipulada dentro da funcao
    // Local oVar := tFont():new()

    Local aVar := array(0)

    AADD(aVar, '1')
    Private cTexto2 := 'TESTE' // variavel declara com esse escopo ficara disponivel no programa que foi declarada
                          // e por todas as funcoes acionadas a partir dele e enquanto ele existir

    Public dDtTeste := date() //variavel continua existindo dentro da thread na qual foi acionada
    //thread tarefa executada pelo sistema

    cTextoAux := '' //se aciono uma variavel para atribuir valor a ela e sem declaracao anterior ela automaticamente vai ser escopo private

    teste()

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author Renan Augusto
    @since 13/07/2024
/*/
Static Function TESTE()

    fwAlertInfo(cTexto2)

Return
