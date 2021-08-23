-module(serverClient).
-compile(export_all).


start() -> register(pid , spawn(fun() -> loop() end)),
io:format("Bem vindo.").


serverClient(Pid,What) -> rpc(Pid, What).

    
rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
	{Pid, Response} ->
	    Response
    end.
    
    
    
loop() ->
    receive
        {From, {criarDataBase}} ->
            From! {pid, baseDados:criarDataBase()},
            loop();
        {From, {mostrarTabelaLivro}} ->
            From! {pid, baseDados:mostrarTabelaLivro()},
            loop();
        {From, {mostrarTabelaRequisicao}} ->
            From! {pid, baseDados:mostrarTabelaRequisicao()},
            loop();
        {From, {mostrarTabelaPessoa}} ->
            From! {pid, baseDados:mostrarTabelaPessoa()},
            loop();
        {From, {listaLivros,Cc}} ->
            From! {pid, baseDados:listaLivros(Cc)},
            loop();
        {From, {listaEmprestimos,Titulo}} ->
            From! {pid, baseDados:listaEmprestimos(Titulo)},
            loop();
        {From, {requisitadoLivro,Cc}} ->
            From! {pid, baseDados:requisitadoLivro(Cc)},
            loop();
        {From, {listaCodigos,Titulo}} ->
            From! {pid, baseDados:listaCodigos(Titulo)},
            loop();
        {From, {listaLivrosRequisitados,Cc}} ->
            From! {pid, baseDados:listaLivrosRequisitados(Cc)},
            loop();
        {From, {removeRequisicao,Ccc ,Idl}} ->
            From! {pid, baseDados:removeRequisicao(Ccc ,Idl)},
            loop();
        {From, {removeCliente,Cc}} ->
            From! {pid, baseDados:removeCliente(Cc)},
            loop();
        {From, {novoCliente,Cc,Nome,Morada,Telefone}} ->
            From! {pid, baseDados:novoCliente(Cc,Nome,Morada,Telefone)},
            loop();
        {From, {novaRequisicao,Cc,Id}} ->
            From! {pid, baseDados:novaRequisicao(Cc,Id)},
            loop()
                end.
                


               

