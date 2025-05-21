:- consult('utils.pl').

% Fatos gerados automaticamente a partir do CSV

% %jogadore_time/2 (jogador relacionado ao seu time)
% jogador_time("ZywOo", "Vitality").
% %jogador_rating/2 (jogador relacionado ao seu rating)
% jogador_rating("ZywOo", 1.32).
% %jogador_funcao/2 (jogador relacionado a sua função)
% jogador_funcao("ZywOo", "AWPer").

% %time_pais/2 (time relacionado ao seu país)
% time_pais("Vitality", "França").

% %campionato_time/2 (time relacionado ao campeonato que jogou)
% campeonato_time("BLAST.tv Austin Major", "Vitality").


%Regras de Jogadores:

%1-
jogadoresDeUmTime(Time, Jogadores) :-
    jogadoresDeUmTime(Time, [], Jogadores).

jogadoresDeUmTime(Time, Acumulador, Jogadores) :-
    jogador_time(Jogador, Time),
    \+ member(Jogador, Acumulador),
    !,
    append(Acumulador, [Jogador], NovoAcumulador),
    jogadoresDeUmTime(Time, NovoAcumulador, Jogadores).

jogadoresDeUmTime(_, Jogadores, Jogadores).

%2-
% melhor_jogador_funcao_pais(Funcao, Pais, JogadorMelhor)
melhor_jogador_funcao_pais(Funcao, Pais, JogadorMelhor) :-
    findall(
        Rating-Jogador,
        (
            jogador_funcao(Jogador, Funcao),
            jogador_rating(Jogador, Rating),
            jogador_time(Jogador, Time),
            time_pais(Time, Pais)
        ),
        Lista
    ),
    quickSort(Lista, desc, Ordenada),
    member(_-JogadorMelhor, Ordenada).


%3-
% dream_team(Pais, TimeIdeal)
dream_team(Pais, DreamTeam) :-
    todas_funcoes(Funcoes),
    length(Funcoes, N),
    N >= 5,
    % tentar todas as combinações de 5 funções distintas
    combinacao(5, Funcoes, FuncoesEscolhidas),
    escolhe_melhores(FuncoesEscolhidas, Pais, [], DreamTeam), !.


% todas_funcoes/1 - coleta todas as funções distintas na base
todas_funcoes(FuncoesUnicas) :-
    findall(Funcao, jogador_funcao(_, Funcao), Funcoes),
    sort(Funcoes, FuncoesUnicas).

% escolhe jogadores únicos para as funções dadas
escolhe_melhores([], _, _, []).
escolhe_melhores([Funcao | RestoFuncoes], Pais, AcumuladoJogadores, [jogador(Funcao, Jogador) | Resto]) :-
    melhor_jogador_funcao_pais(Funcao, Pais, Jogador),
    \+ member(Jogador, AcumuladoJogadores),
    escolhe_melhores(RestoFuncoes, Pais, [Jogador | AcumuladoJogadores], Resto).


%4-
%jogador_pais(Pais, Lista).
jogador_pais_com_melhor_rating(Pais, List) :-
    findall(Rating-X, (jogador_rating(X, Rating), jogador_time(X, Time), time_pais(Time, Pais)), List),
    quickSort(List, desc, ListOrd),
    length(ListOrd, Tam),
    imprimeLista(ListOrd, Tam, "Jogador: ").

%5-
top_jogadores :-
    findall(Rating-Jogador,(jogador_rating(Jogador, Rating)), L1),
    quickSort(L1, desc, LST),
    length(LST, Tam),
    imprimeLista(LST, Tam, "Jogador: ").

% -----------------------------------------------------------------


%Regras de times

%1-
rating_medio(Time, RatingMedio):-
    findall(Rating, (jogador_rating(Jogador, Rating), jogador_time(Jogador, Time)), L1),
    media(L1, RatingMedio).

%2-
combate(T1, T2, Vencedor):-
    rating_medio(T1, RatingTime1),
    rating_medio(T2, RatingTime2),
    vencedor(T1, RatingTime1, T2, RatingTime2, Vencedor),!.


vencedor(T1, RatingTime1, _, RatingTime2, Vencedor) :-
    RatingTime1 > RatingTime2,
    Vencedor = T1.

vencedor(_, RatingTime1, T2, RatingTime2, Vencedor) :-
    RatingTime1 < RatingTime2,
    Vencedor = T2.

vencedor(_, RatingTime1, _, RatingTime2, "Empate") :-
    RatingTime1 =:= RatingTime2.


%3-
ranking_media :-
    findall(Time, jogador_time(_, Time), TimesComRepeticao),
    sort(TimesComRepeticao, TimesUnicos),
    calcula_ratings(TimesUnicos, ListaRatings),
    quickSort(ListaRatings, desc, Ordenado),
    length(Ordenado, Tam),
    imprimeLista(Ordenado, Tam, "Time: ").

calcula_ratings([], []).
calcula_ratings([Time | Resto], [Rating-Time | Lista]) :-
    rating_medio(Time, Rating),
    calcula_ratings(Resto, Lista).

%4-
posicao_time(Time, Posicao) :-
    findall(T, jogador_time(_, T), TimesComRepeticao),
    sort(TimesComRepeticao, TimesUnicos),
    calcula_ratings(TimesUnicos, ListaRatings),
    quickSort(ListaRatings, desc, ListaOrdenada),
    buscaPosicaoPorTime(Posicao, ListaOrdenada, Time).

% Busca posição ignorando flutuações no float do rating
buscaPosicaoPorTime(Pos, [ _Rating-TimeAtual | _ ], TimeBuscado) :-
    TimeAtual == TimeBuscado, !,
    Pos = 1.

buscaPosicaoPorTime(Pos, [ _ | Resto ], TimeBuscado) :-
    buscaPosicaoPorTime(Pos1, Resto, TimeBuscado),
    Pos is Pos1 + 1.


%5-
monta_time(Jogadores, rating(RatingFinal, posicao(Posicao))) :-
    findall(R, (member(J, Jogadores), jogador_rating(J, R)), Ratings),
    media(Ratings, RatingFinal),

    findall(Time, jogador_time(_, Time), TimesComRepeticao),
    sort(TimesComRepeticao, TimesUnicos),
    calcula_ratings(TimesUnicos, ListaRatings),

    append(ListaRatings, [RatingFinal-Temp], ListaComTemp),
    quickSort(ListaComTemp, desc, ListaOrdenada),

    buscaPosicao(Posicao, ListaOrdenada, RatingFinal-Temp).


%------------------------------------------------------------
%Regras de campeonatos

%1-
listar_campeonatos :-
    findall(Camp, campeonato_time(Camp, _), ListaComRep),
    sort(ListaComRep, Lista),
    length(Lista, Tam),
    imprimeLista(Lista, Tam, "Campeonato: ").


%2-
times_do_campeonato(Camp) :-
    findall(Time, campeonato_time(Camp, Time), ListaComRep),
    sort(ListaComRep, Lista),
    length(Lista, Tam),
    imprimeLista(Lista, Tam, "Time: ").


%3-
melhor_time_campeonato(Camp) :-
    findall(Time, campeonato_time(Camp, Time), ListaComRep),
    sort(ListaComRep, ListaTimes),
    calcula_ratings(ListaTimes, ListaRatings),
    quickSort(ListaRatings, desc, [ _-MelhorTime | _ ]),
    format("Time com mais chances: ~w~n", [MelhorTime]).



%4-
mostrar_rating_medio_campeonato(Camp) :-
    rating_medio_campeonato(Camp, Media),
    format("Rating médio do campeonato ~w: ~2f~n", [Camp, Media]).

rating_medio_campeonato(Camp, Media) :-
    findall(Time, campeonato_time(Camp, Time), ListaComRep),
    sort(ListaComRep, ListaTimes),
    findall(R, (
        member(Time, ListaTimes),
        jogador_time(Jogador, Time),
        jogador_rating(Jogador, R)
    ), Ratings),
    media(Ratings, Media).

%5-
ranking_campeonatos_dificuldade :-
    findall(Camp, campeonato_time(Camp, _), ComRep),
    sort(ComRep, Unicos),
    calcula_ratings_campeonatos(Unicos, Lista),
    quickSort(Lista, desc, Ordenada),
    length(Ordenada, Tam),
    imprimeLista(Ordenada, Tam, "Campeonato: ").

calcula_ratings_campeonatos([], []).
calcula_ratings_campeonatos([Camp | Resto], [Media-Camp | Lst]) :-
    rating_medio_campeonato(Camp, Media),
    calcula_ratings_campeonatos(Resto, Lst).

%-------------------------------------------------------------------
%Regras de Pais
%1-
listar_paises_com_times(LST) :-
    findall(Pais, (time_pais(_, Pais)), LST),
    length(LST, Tam),
    imprimeLista(LST, Tam, "Pais: ").

%2-
times_do_pais(Pais) :-
    findall(Time, (time_pais(Time, Pais)), LST),
    length(LST, Tam),
    imprimeLista(LST, Tam, "Time: ").

%3-
jogadores_pais(Pais):-
    findall(Jogador, jogador_time(Jogador, _), LST),
    verifica_pais(LST, Pais, Jogadores),
    length(Jogadores, Tam),
    imprimeLista(Jogadores, Tam, "Jogador: ").

verifica_pais([], _, []).
verifica_pais([H|T], Pais, [H|JogadoresDoPais]):-
    jogador_time(H, Time),
    time_pais(Time, Pais),
    verifica_pais(T, Pais, JogadoresDoPais).

verifica_pais([H|T], Pais, JogadoresDoPais):-
    jogador_time(H, Time),
    time_pais(Time, OutroPais),
    OutroPais \= Pais,
    verifica_pais(T, Pais, JogadoresDoPais).

%4-
pais_com_melhor_media_rating(PaisMelhor) :-
    findall(P, time_pais(_, P), PaisesComRepeticao),
    sort(PaisesComRepeticao, Paises),
    calcula_media_pais(Paises, Medias),
    quickSort(Medias, desc, [ _-PaisMelhor | _]).

calcula_media_pais([], []).
calcula_media_pais([Pais | Resto], [Media-Pais | MediasResto]) :-
    findall(Rating, (
        jogador_time(Jogador, Time),
        time_pais(Time, Pais),
        jogador_rating(Jogador, Rating)
    ), Ratings),
    media(Ratings, Media),
    calcula_media_pais(Resto, MediasResto).

%5-
melhor_funcao_pais(Pais, FuncaoMelhor, MediaMelhor) :-
    todas_funcoes(Funcoes),
    calcula_media_funcoes_pais(Funcoes, Pais, ListaMedias),
    quickSort(ListaMedias, desc, [MediaMelhor-FuncaoMelhor | _]).

calcula_media_funcoes_pais([], _, []).
calcula_media_funcoes_pais([Funcao | Resto], Pais, [Media-Funcao | Lista]) :-
    findall(Rating, (
        jogador_funcao(Jogador, Funcao),
        jogador_time(Jogador, Time),
        time_pais(Time, Pais),
        jogador_rating(Jogador, Rating)
    ), Ratings),
    Ratings \= [],
    media(Ratings, Media),
    calcula_media_funcoes_pais(Resto, Pais, Lista).

calcula_media_funcoes_pais([_ | Resto], Pais, Lista) :-
    calcula_media_funcoes_pais(Resto, Pais, Lista).

%-------------------------------------------------------------
%Regras de Funcoes ou rating

%1-
funcoes_mais_valiosas(ListaOrdenada) :-
    todas_funcoes(Funcoes),
    calcula_valor_funcoes(Funcoes, Lista),
    quickSort(Lista, desc, ListaOrdenada).

calcula_valor_funcoes([], []).
calcula_valor_funcoes([F | R], [Valor-F | Lst]) :-
    findall(Rating, (
        jogador_funcao(J, F),
        jogador_rating(J, Rating)
    ), Ratings),
    length(Ratings, Qtd),
    Ratings \= [],
    media(Ratings, Media),
    Valor is Media * Qtd,
    calcula_valor_funcoes(R, Lst).

calcula_valor_funcoes([_ | R], Lst) :-
    calcula_valor_funcoes(R, Lst).


%2-
funcao_mais_importante_por_time(Time, FuncaoMaisImportante) :-
    findall(Funcao, (
        jogador_time(J, Time),
        jogador_funcao(J, Funcao)
    ), Funcoes),
    sort(Funcoes, Unicas),
    calcula_melhor_rating_por_funcao(Unicas, Time, ListaRatings),
    quickSort(ListaRatings, desc, [_-FuncaoMaisImportante | _]).

calcula_melhor_rating_por_funcao([], _, []).
calcula_melhor_rating_por_funcao([Funcao | Resto], Time, [MelhorRating-Funcao | Lista]) :-
    findall(R, (
        jogador_time(J, Time),
        jogador_funcao(J, Funcao),
        jogador_rating(J, R)
    ), Ratings),
    max_list(Ratings, MelhorRating),
    calcula_melhor_rating_por_funcao(Resto, Time, Lista).

%3-
media_global(Media) :-
    findall(Rating, jogador_rating(_, Rating), Ratings),
    media(Ratings, Media).


%4-
funcao_com_mais_jogadores_acima_da_media(FuncaoMaisForte, Quantidade) :-
    media_global(MediaGlobal),

    todas_funcoes(Funcoes),

    conta_jogadores_acima_media(Funcoes, MediaGlobal, Contagens),

    quickSort(Contagens, desc, [Quantidade-FuncaoMaisForte | _]).

conta_jogadores_acima_media([], _, []).
conta_jogadores_acima_media([Funcao | Resto], MediaGlobal, [Quantidade-Funcao | ContagemResto]) :-
    findall(Jogador, jogador_funcao(Jogador, Funcao), JogadoresFuncao),
    include(acima_da_media(MediaGlobal), JogadoresFuncao, JogadoresAcima),
    length(JogadoresAcima, Quantidade),
    conta_jogadores_acima_media(Resto, MediaGlobal, ContagemResto).

acima_da_media(MediaGlobal, Jogador) :-
    jogador_rating(Jogador, Rating),
    Rating > MediaGlobal.


%5-
jogadores_acima_da_media(ListaJogadores) :-
    media_global(MediaGlobal),
    findall(Jogador,
            (jogador_rating(Jogador, Rating), Rating > MediaGlobal),
            ListaJogadores).

%----------------------------------------------------------------