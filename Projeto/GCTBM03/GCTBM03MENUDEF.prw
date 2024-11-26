#include 'totvs.ch'
#include 'fwmvcdef.ch'

Static Function menudef
    
    local aRotina       := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar'    ACTION 'axPesqui'                OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.GCTBM03VIEWDEF'  OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.GCTBM03VIEWDEF'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.GCTBM03VIEWDEF'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.GCTBM03VIEWDEF'  OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'     ACTION 'VIEWDEF.GCTBM03VIEWDEF'  OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'       ACTION 'VIEWDEF.GCTBM03VIEWDEF'  OPERATION 9 ACCESS 0
    ADD OPTION aRotina TITLE 'Ver Pedido'   ACTION 'U_VER_PEDIDO()'          OPERATION 6 ACCESS 0
    

Return aRotina
