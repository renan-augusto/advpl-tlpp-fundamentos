#include 'totvs.ch'

Function u_app001
    
    Local oCliente   :=  cliente():new('renan augusto', 'renan')
    Local cCGC      :=  oCliente:getCgc()

    oCliente:email       := "renan@renan.com"
    oCliente:cpf_cnpj    := "99999999999"

    cCGC    := oCliente:getCgc()    

Return oCliente
