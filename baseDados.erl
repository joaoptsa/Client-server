-module(baseDados).
-import(lists, [foreach/2]).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").


%% record

-record(pessoa,{cc,nome,morada,telefone}).
-record(livro,{idLivro,titulo,autores}).
-record(requisicao,{cc,idLivro}).


%% criar e definir a tabela na  base de dados 

criarDataBase() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(pessoa, [{attributes,record_info(fields, pessoa)}]),
    mnesia:create_table(livro,[{attributes,record_info(fields, livro)}]),
    mnesia:create_table(requisicao,[{type,bag},{attributes,record_info(fields,requisicao)}]),
    mnesia:wait_for_tables([pessoa,livro,requisicao], 20000),
    resetTabelas().


resetTabelas() ->
    mnesia:clear_table(pessoa),
    mnesia:clear_table(livro),
    mnesia:clear_table(requisicao),
    F = fun() ->
		foreach(fun mnesia:write/1, exemploTabelas())
	end,
    mnesia:transaction(F).
    
    
%% tabela 

exemploTabelas()->
     [ 
     
     {pessoa, 1234, "João Pedro", "Breiner", 921234867},
     {pessoa, 1235, "João Paulo", "Breiner", 911234567},
     {pessoa, 1672, "Zé Gomes", "Cedofeita", 911123456},
     {pessoa, 1700, "Roberto Lima","Maia",  912456789},
     {pessoa, 1701, "Roberta Pires","Maia",  912756889},
     
     {livro, 1,  "Amarelo é a cor do amor", "Gomes"},
     {livro, 2,  "Dark",  "Luis"},
     {livro, 3,  "Sombra",  "Pedro"},
     {livro, 4,  "Morte Linda", "João"},
     {livro, 5,  "Morte Linda", "João"},
     {livro, 6,  "Linda", "Jo"},
     
     {requisicao, 1234, 3},
     {requisicao, 1235, 1},
     {requisicao, 1235, 2},
     {requisicao, 1672, 5}
    
    ]. 


%% executa a consulta e devolver o resultado.
    
fazer(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.    
    


%% ver o conteudo das tabelas 

mostrarTabelaLivro() ->
 fazer(qlc:q([X || X <- mnesia:table(livro)])).

mostrarTabelaRequisicao() ->
 fazer(qlc:q([X || X <- mnesia:table(requisicao)])).
 
mostrarTabelaPessoa() ->
 fazer(qlc:q([X || X <- mnesia:table(pessoa)])).    
    
 
 
  
%% Mensagens de lookup: 
 
%% livros: dado um número de cartão de cidadão determina a lista de livros requisitada por essa pessoa

listaLivros(Cc) ->
    fazer(qlc:q([{X#livro.titulo,X#livro.idLivro} || X <- mnesia:table(livro), Y <- mnesia:table(requisicao),
	X#livro.idLivro =:= Y#requisicao.idLivro, Y#requisicao.cc =:= Cc 
	])).


   
%% Empréstimos: dado o título de um livro determina a lista de pessoas que requisitaram esse livro

listaEmprestimos(Titulo) -> 
 fazer(qlc:q([{X#pessoa.nome, X#pessoa.cc} || X <- mnesia:table(pessoa),Y <- mnesia:table(livro), T <- mnesia:table(requisicao),
 Y#livro.idLivro =:= T#requisicao.idLivro, T#requisicao.cc =:= X#pessoa.cc, Y#livro.titulo =:= Titulo ])).


%% requisitado: dado o código de um livro determina se o livro está requisitado (retorna um booleano)

requisitadoLivro(CodLivro)->
verificarLista(fazer(qlc:q([X#livro.titulo || X <- mnesia:table(livro), Y <- mnesia:table(requisicao),
	X#livro.idLivro =:= Y#requisicao.idLivro, Y#requisicao.idLivro =:= CodLivro 
	]))).

%% verifica se lista está vazia ou não  

verificarLista(L)-> 
if 
    length(L) > 0  -> true;
 
    length(L) =:= 0 -> false
end.


%% códigos: dado o título de um livro retorna a lista de códigos de livros com esse título

listaCodigos(Titulo)->
fazer(qlc:q([X#livro.idLivro || X <- mnesia:table(livro), X#livro.titulo =:= Titulo ])). 

            
%% numRequisicões: dado um número de cartão de cidadão retorna o número de livros requisitados por essa pessoa;

listaLivrosRequisitados(Cc)->
length(fazer(qlc:q([X#requisicao.cc || X <- mnesia:table(requisicao), X#requisicao.cc =:= Cc ]))).      


%% Mensagens de update:


%% requisição: dados os dados de uma pessoa e o código de um livro acrescenta o par {pessoa, livro} 
%% à base de dados


novoCliente(Cc,Nome,Morada,Telefone) ->
    Row = #pessoa{cc=Cc,nome=Nome, morada=Morada, telefone=Telefone},
    F = fun() ->
		mnesia:write(Row)
	end,
    mnesia:transaction(F).

novaRequisicao(Cc,Idl) -> 
    
    Row = #requisicao{idLivro=Idl,cc=Cc},
    F = fun() ->
		mnesia:write(Row)
	end,
    mnesia:transaction(F).



%% retorno: dado um número de cartão de cidadão e o código de um livro retira o par respectivo da base de dados

removeRequisicao(Ccc ,Idl) ->
    Oid = #requisicao{cc=Ccc, idLivro=Idl },
    F = fun() ->
		mnesia:delete_object(Oid)
	end,
    mnesia:transaction(F).

removeCliente(Cc) ->
    Oid = #pessoa{cc=Cc},
    F = fun() ->
		mnesia:delete_object(Oid)
	end,
    mnesia:transaction(F).




				
				
