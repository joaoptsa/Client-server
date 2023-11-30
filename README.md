#Client-server(Library Database) 

<h1> Primeiro trabalho prático de Programação Concorrente (2021)</h1>

Erlang é uma linguagem funcional e de uso geral, orientada para a construção de sistemas escaláveis e concorrentes com garantias de alta disponibilidade.
O principal aspeto que distingue Erlang de outras línguas é o seu modelo informático baseado em processos. 
Utiliza processos isolados e leves que comunicam uns com os outros através de mensagens. Estes processos podem receber mensagens e, em resposta a estas, cria novos processos, e envia mensagens para outros processos, ou modifica o seu estado. Os processos são isolados, rápidos de criar, e ocupam apenas uma pequena quantidade de memória.

A Erlang tem três vantagens significativas sobre outras linguagens de programação:

Concorrência: BEAM, a máquina virtual de Erlang, utiliza “lightweight threads of execution”. Estes são isolados, passam por todas as CPUs, e comunicam através de mensagens, o que torna menos difícil de escrever programas em simultâneos.

Escalabilidade: A Erlang é perfeitamente adequada à natureza distribuída da computação moderna e dos CPUs actuais. Os processos de Erlang permitem-nos escalar facilmente sistemas, tanto pela adição de mais máquinas como pela adição de mais núcleos às máquinas existentes.

Fiabilidade: Tolerância a falhas. Os processos leves podem ser rapidamente reiniciados pelo sistema supervisor, o que ajuda a construir sistemas “self-healing systems”.

<h2>Descrição da arquitectura do programa implementado.</h2>

A implementação da estrutura de dados/base de dados no servidor será com a Mnesia. A Mnesia é extremamente rápida, e pode armazenar qualquer tipo de estrutura de dados.
As tabelas da base de dados podem ser armazenadas em RAM ou em disco, e as tabelas podem ser replicadas em diferentes máquinas para fornecer um comportamento tolerante a falhas.
No ficheiro baseDados.erl encontrasse implementado a minha base de dados (Mnesia). Vamos usar três tabelas correspondentes a pessoa (cartão de cidadão, nome, morada e telefone), livro (IDlivro,titulo e autores) e requisição (cartão de cartão de cidadão e IDlivro). Nesse ficheiro encontram-se as funções que possibilitam a consulta das tabelas para posteriormente responder às questões do enunciado mais as respetivas funções de adicionar ou eliminar dados nas tabelas. Neste ficheiro encontra-se funções auxiliares que permitem a construção das tabelas e o funcionamento das consultas.
O ficheiro serverClient.erl é utilizado para a comunicação entre o cliente e o servidor. Tanto o cliente como o servidor podem funcionar na mesma máquina ou em duas máquinas diferentes. As palavras cliente e servidor referem-se aos papéis que estes dois processos têm. O cliente envia um pedido ao servidor e o servidor calcula uma resposta e envia-a ao cliente.

<h2>Execução do programa</h2>

Para usar Erlang no Linux, você pode seguir estes passos básicos de instalação:

<h4>Atualizar o Sistema</h4>

Antes de instalar qualquer coisa, é sempre uma boa prática garantir que o sistema está atualizado.

sudo apt update && sudo apt upgrade

Se você estiver usando um sistema diferente do Ubuntu, pode usar o gerenciador de pacotes apropriado.

<h4>Instalar o Erlang:</h4>

sudo apt install erlang

<h4>Executar</h4>

Vamos compilar primeiro os ficheiros baseDados.erl e serverClient.erl:
c(baseDados).
c(serverClient).

Logo depois é necessário fazer o seguinte comando: serverClient: start().
Se quisermos enviar uma mensagem a um processo, então precisamos de conhecer o seu PID, mas quando um processo é criado, apenas o processo pai conhece o PID. Isto é um inconveniente,uma vez que o PID tem de ser enviado para todos os processos do sistema que queiram comunicar com este processo.

Por isso a necessidade do start (start() -> register(pid , spawn(fun() -> loop() end) ).
Aqui está uma explicação mais detalhada de cada parte da função:

start() ->

Esta é a expressão que inicia a função. Ela retorna um valor, que é o PID do processo filho.

register(pid , spawn(fun() -> loop() end) )

Esta expressão registra o PID do processo filho usando a função register(). A função register() recebe um PID e um nome como argumentos. Ela registra o PID com o nome especificado para que você possa acessá-lo mais tarde.

spawn(fun() -> loop() end)

Esta expressão cria um processo filho usando a função spawn(). A função spawn() recebe uma função como argumento e retorna um PID do processo filho.

fun() -> loop() end

Esta é a função que é executada pelo processo filho. Ela fica em um loop infinito

Criamos e iniciamos as tabelas da base de dados:<br> 
serverClient: serverClient(pid,{criarDataBase})

Podemos visualizar as tabelas:<br>
serverClient: serverClient(pid,{mostrarTabelaPessoa}) <br>
serverClient: serverClient(pid,{mostrarTabelaRequisicao})<br>
serverClient: serverClient(pid,{mostrarTabelaLivros})<br>

As tabelas têm os seguintes dados:<br>
exemploTabelas()-> 
[{pessoa, 1234, "João Pedro", "Breiner", 921234867},
{pessoa, 1235, "João Paulo", "Breiner", 911234567},
{pessoa, 1672, "Zé Gomes", "Cedofeita", 911123456},
{pessoa, 1700, "Roberto Lima","Maia", 912456789},
{pessoa, 1701, "Roberta Pires","Maia", 912756889},
{livro, 1, "Amarelo é a cor do amor", "Gomes"},
{livro, 2, "Dark", "Luis"},
{livro, 3, "Sombra", "Pedro"},
{livro, 4, "Morte Linda", "João"},
{livro, 5, "Morte Linda", "João"},
{livro, 6, "Linda", "Jo"},
{requisicao, 1234, 3},
{requisicao, 1235, 1},
{requisicao, 1235, 2},
{requisicao, 1672, 5}].

<h4>Em seguimento a estes passos, podemos responder às questões:</h4>

- Livros: fornecendo um número de cartão de cidadão determina-se a lista de livros requisitada por essa pessoa (Retorna o título e o código do livro);

serverClient: serverClient(pid,{listaLivros,1234})<br>
[{"Sombra",3}]<br>
serverClient: serverClient(pid,{listaLivros,1235})<br>
[{"Amarelo é a cor do amor",1},{"Dark",2}]

- Empréstimos: fornecendo o título de um livro determina-se a lista de pessoas que requisitaram esse livro (Retorna o Nome e o número do cartão de cidadão);
  
serverClient: serverClient(pid,{listaEmprestimos,"Dark"})<br>
[{"João Paulo",1235}]<br>
serverClient: serverClient(pid,{listaEmprestimos,"Amarelo é a cor do amor"})<br>
[{"João Paulo",1235}]<br>

- Requisitado: fornecendo o código de um livro determina-se se o livro está requisitado (Retorna um booleano);<br>

serverClient: serverClient(pid,{requisitadoLivro,2})<br>
True<br>
serverClient: serverClient(pid,{requisitadoLivro,4})<br>
false<br>

- Códigos: fornecendo o título de um livro retorna a lista de códigos de livros com esse título<br>

serverClient: serverClient(pid,{listaCodigos,"Dark"})<br>
[2]<br>
serverClient: serverClient(pid,{listaCodigos,"Morte Linda"})<br>
[4,5]<br>

- Número de requisições: fornecendo um número de cartão de cidadão retorna o número de livros requisitados por essa pessoa<br>

serverClient: serverClient(pid,{listaLivrosRequisitados,1235})<br>
2<br>
serverClient: serverClient(pid,{listaLivrosRequisitados,1672})<br>
1<br>

- Requisição: fornecendo os dados de uma pessoa e o código de um livro acrescenta o par {pessoa,livro} à base de dados<br>
Adicionar na tabela pessoa<br>

serverClient: serverClient(pid,{novoCliente,1000,"Pauleta","rua do faz de conta",91221423})<br>
{atomic,ok}<br>
serverClient: serverClient(pid,{mostrarTabelaPessoa}).<br>
[{pessoa,1700,"Roberto Lima","Maia",912456789},<br>
{pessoa,1235,"João Paulo","Breiner",911234567},<br>
{pessoa,1234,"João Pedro","Breiner",921234867},<br>
{pessoa,1701,"Roberta Pires","Maia",912756889},<br>
{pessoa,1672,"Zé Gomes","Cedofeita",911123456},<br>
{pessoa,1000,"Pauleta","rua do faz de conta",91221423}]<br>

- Adicionar na tabela requisições<br>

serverClient: serverClient(pid,{novaRequisicao,1000,6})<br>
{atomic,ok}<br>
serverClient: serverClient(pid,{mostrarTabelaRequisicao})<br>
[{requisicao,1235,1},<br>
{requisicao,1235,2},<br>
{requisicao,1234,3},<br>
{requisicao,1672,5},<br>
{requisicao,1000,6}]<br>


- Retorno: fornecendo um número de cartão de cidadão e o código de um livro retira o respectivo par da base de dados<br>

serverClient:serverClient(pid,{removeRequisicao,1000,6})<br>
{atomic,ok}<br>
serverClient:serverClient(pid,{mostrarTabelaRequisicao})<br>
[{requisicao,1235,1},<br>
{requisicao,1235,2},<br>
{requisicao,1234,3},<br>
{requisicao,1672,5}]<br>













