:- consult('csgo_fatos.pl').
:- consult('regras.pl').

menu_loop :-
    repeat,
    shell(clear),
    menu,
    read(Opcao),
    (Opcao =:= 0 -> ! ; opcao_menu(Opcao), fail).

menu :-
    writeln(""),
    writeln("=== MENU PRINCIPAL ==="),
    writeln("1 - Jogadores"),
    writeln("2 - Times"),
    writeln("3 - Campeonatos"),
    writeln("4 - Países"),
    writeln("5 - Rating/Função"),
    writeln("Escolha uma opção (1-5): "),
    writeln(""),
    read(Opcao),
    opcao_menu(Opcao).

opcao_menu(1) :- menu_jogadores.
opcao_menu(2) :- menu_times.
opcao_menu(3) :- menu_campeonatos.
opcao_menu(4) :- menu_paises.
opcao_menu(5) :- menu_funcoes.
opcao_menu(_) :- writeln("Opção inválida."), menu.

% -----------------------------------------------------------------


menu_jogadores :-
    writeln(""),
    writeln("=== MENU JOGADORES ==="),
    writeln("1 - Listar jogadores de um time"),
    writeln("2 - Melhor jogador de uma função em um país"),
    writeln("3 - Dream team de um país"),
    writeln("4 - Jogadores de um país"),
    writeln("5 - Top jogadores por rating"),
    writeln("0 - Voltar"),
    writeln(""),
    read(Opcao),
    opcao_jogadores(Opcao).

opcao_jogadores(1) :-
    writeln("Digite o nome do time:"),
    read(Time),
    jogadoresDeUmTime(Time, Jogadores),
    length(Jogadores, Tam),
    writeln("Jogadores do time:"),
    imprimeLista(Jogadores, Tam, "Jogador: "),
    menu_jogadores.

opcao_jogadores(2) :-
    writeln("Digite a função:"),
    read(Funcao),
    writeln("Digite o país:"),
    read(Pais),
    (melhor_jogador_funcao_pais(Funcao, Pais, JogadorMelhor) ->
        format("Melhor jogador na função ~w do país ~w: ~w~n", [Funcao, Pais, JogadorMelhor])
    ;
        writeln("Nenhum jogador encontrado para os critérios fornecidos.")
    ),
    menu_jogadores.

opcao_jogadores(3) :-
    writeln("Digite o país:"),
    read(Pais),
    (dream_team(Pais, TimeIdeal) ->
        writeln("Dream team:"),
        imprime_dream_team(TimeIdeal)
    ;
        writeln("Não foi possível formar um dream team para esse país.")
    ),
    menu_jogadores.

opcao_jogadores(4) :-
    writeln("Digite o país:"),
    read(Pais),
    jogador_pais(Pais, _),
    menu_jogadores.

opcao_jogadores(5) :-
    writeln("Top jogadores por rating:"),
    top_jogadores(),
    menu_jogadores.

opcao_jogadores(0) :-
    writeln("Voltando ao menu anterior...").

opcao_jogadores(_) :-
    writeln("Opção inválida."),
    menu_jogadores.

% Auxiliar para imprimir o dream team formatado
imprime_dream_team([]).
imprime_dream_team([jogador(Funcao, Nome) | Resto]) :-
    format("Função: ~w | Jogador: ~w~n", [Funcao, Nome]),
    imprime_dream_team(Resto).

% -----------------------------------------------------------------

menu_times :-
    writeln(""),
    writeln("=== MENU TIMES ==="),
    writeln("1 - Rating médio de um time"),
    writeln("2 - Combate entre dois times"),
    writeln("3 - Ranking dos times por rating médio"),
    writeln("4 - Posição de um time no ranking"),
    writeln("5 - Montar um time e calcular rating e posição"),
    writeln("0 - Voltar"),
    read(Opcao),
    opcao_times(Opcao).

opcao_times(1) :-
    writeln("Digite o nome do time:"),
    read(Time),
    (rating_medio(Time, Media) ->
        format("O rating médio do time ~w é ~2f~n", [Time, Media])
    ;
        writeln("Time não encontrado ou sem jogadores.")
    ),
    menu_times.

opcao_times(2) :-
    writeln("Digite o nome do primeiro time:"),
    read(T1),
    writeln("Digite o nome do segundo time:"),
    read(T2),
    (combate(T1, T2, Vencedor) ->
        format("O vencedor do confronto entre ~w e ~w é: ~w~n", [T1, T2, Vencedor])
    ;
        writeln("Erro ao simular o combate.")
    ),
    menu_times.

opcao_times(3) :-
    writeln("Ranking dos times por rating médio:"),
    ranking_media,
    menu_times.

opcao_times(4) :-
    writeln("Digite o nome do time:"),
    read(Time),
    (posicao_time(Time, Pos) ->
        format("A posição do time ~w no ranking é: ~d~n", [Time, Pos])
    ;
        writeln("Time não encontrado.")
    ),
    menu_times.

opcao_times(5) :-
    writeln("Digite a lista de jogadores no formato [jogador1, jogador2, ...]:"),
    read(Jogadores),
    (monta_time(Jogadores, rating(Rating, posicao(Pos))) ->
        format("Rating médio do time montado: ~2f~n", [Rating]),
        format("Posição no ranking geral: ~d~n", [Pos])
    ;
        writeln("Erro ao montar o time. Verifique os nomes dos jogadores.")
    ),
    menu_times.

opcao_times(0):-
    writeln("Voltando ao menu anterior...").

opcao_times(_) :-
    writeln("Opção inválida."),
    menu_times.

%---------------------------------------------------------------


menu_campeonatos :-
    writeln(""),
    writeln("=== MENU CAMPEONATOS ==="),
    writeln("1 - Listar todos os campeonatos"),
    writeln("2 - Mostrar times que participaram de um campeonato"),
    writeln("3 - Listar time com mais chances de ganhar o campeonato"),
    writeln("4 - Mostrar rating medio do campeonato"),
    writeln("5 - Listar em ordem do campeonato mais dificil para o mais facil com o rating medio"),
    writeln("0 - Voltar"),
    read(Opcao),
    opcao_campeonatos(Opcao).

opcao_campeonatos(1) :- listar_campeonatos, menu_campeonatos.
opcao_campeonatos(2) :-
    writeln("Digite o nome do campeonato entre aspas duplas (\"...\"): "),
    read(Camp),
    times_do_campeonato(Camp),
    menu_campeonatos.
opcao_campeonatos(3) :-
    writeln("Digite o nome do campeonato entre aspas duplas (\"...\"): "),
    read(Camp),
    melhor_time_campeonato(Camp),
    menu_campeonatos.
opcao_campeonatos(4) :-
    writeln("Digite o nome do campeonato entre aspas duplas (\"...\"): "),
    read(Camp),
    mostrar_rating_medio_campeonato(Camp),
    menu_campeonatos.
opcao_campeonatos(5) :- 
    ranking_campeonatos_dificuldade,
    menu_campeonatos.
opcao_campeonatos(0) :-
    writeln("Voltando ao menu anterior...").
opcao_campeonatos(_) :- 
    writeln("Opção inválida!"),
    menu_campeonatos.

%---------------------------------------------------------------


menu_paises :-
    writeln(""),
    writeln("=== MENU PAÍSES ==="),
    writeln("1 - Listar todos os países com times"),
    writeln("2 - Mostrar times de um país"),
    writeln("3 - Mostrar jogadores de um país"),
    writeln("4 - Mostrar país com a melhor média de rating"),
    writeln("5 - Mostrar função com o maior rating médio de um país"),
    writeln("0 - Voltar"),
    read(Opcao),
    opcao_paises(Opcao).

opcao_paises(1) :-
    listar_paises_com_times(_),
    menu_paises.

opcao_paises(2) :-
    writeln("Digite o nome do país:"),
    read(Pais),
    times_do_pais(Pais),
    menu_paises.

opcao_paises(3) :-
    writeln("Digite o nome do país:"),
    read(Pais),
    jogadores_pais(Pais),
    menu_paises.

opcao_paises(4) :-
    pais_com_melhor_media_rating(Pais),
    format("País com melhor média de rating: ~w~n", [Pais]),
    menu_paises.

opcao_paises(5) :-
    writeln("Digite o nome do país:"),
    read(Pais),
    melhor_funcao_pais(Pais, Funcao, Media),
    format("Função com maior rating médio no país ~w: ~w (~2f)~n", [Pais, Funcao, Media]),
    menu_paises.

opcao_paises(0) :-
    writeln("Voltando ao menu anterior...").

opcao_paises(_) :-
    writeln("Opção inválida."),
    menu_paises.



menu_funcoes :-
    writeln(""),
    writeln("=== MENU FUNÇÕES / RATINGS ==="),
    writeln("1 - Listar funções mais valiosas"),
    writeln("2 - Mostrar função mais importante por time"),
    writeln("3 - Mostrar média global de rating"),
    writeln("4 - Mostrar função com mais jogadores acima da média"),
    writeln("5 - Mostrar jogadores acima da média"),
    writeln("0 - Voltar"),
    read(Opcao),
    opcao_funcoes(Opcao).

opcao_funcoes(1) :-
    funcoes_mais_valiosas(Lista),
    imprimeListaFuncaoValor(Lista),
    menu_funcoes.

opcao_funcoes(2) :-
    writeln("Digite o nome do time:"),
    read(Time),
    funcao_mais_importante_por_time(Time, Funcao),
    format("Função mais importante no time ~w: ~w~n", [Time, Funcao]),
    menu_funcoes.

opcao_funcoes(3) :-
    media_global(Media),
    format("Média global de rating: ~2f~n", [Media]),
    menu_funcoes.

opcao_funcoes(4) :-
    funcao_com_mais_jogadores_acima_da_media(Funcao, Quantidade),
    format("Função com mais jogadores acima da média: ~w (~d jogadores)~n", [Funcao, Quantidade]),
    menu_funcoes.

opcao_funcoes(5) :-
    jogadores_acima_da_media(ListaJogadores),
    length(ListaJogadores, Tam),
    format("Jogadores acima da média (~d):~n", [Tam]),
    imprimeLista(ListaJogadores, Tam, "Jogador: "),
    menu_funcoes.

opcao_funcoes(0) :-
    writeln("Voltando ao menu anterior...").

opcao_funcoes(_) :-
    writeln("Opção inválida."),
    menu_funcoes.


imprimeListaFuncaoValor([]).
imprimeListaFuncaoValor([Valor-Funcao | Resto]) :-
    format("Função: ~w - Valor: ~2f~n", [Funcao, Valor]),
    imprimeListaFuncaoValor(Resto).