combinacao(0, _, []).
combinacao(N, [X | T], [X | Comb]) :-
    N > 0,
    N1 is N - 1,
    combinacao(N1, T, Comb).
combinacao(N, [_ | T], Comb) :-
    N > 0,
    combinacao(N, T, Comb).


imprimeLista(_,0, _):-!.
imprimeLista([H|T], Tam, Label):-
    Tam > 0,
    write(Label),
    writeln(H),
    T1 is Tam - 1,
    imprimeLista(T, T1, Label).

quickSort([], _, []) :- !.
quickSort([Pivot|T], Dir, Sorted) :-
    partition(Dir, Pivot, T, Menor, Maior),
    quickSort(Menor, Dir, MenorOrdenado),
    quickSort(Maior, Dir, MaiorOrdenado),
    append(MenorOrdenado, [Pivot|MaiorOrdenado], Sorted).

% Particionamento para ambas direções
partition(_, _, [], [], []) :- !.

partition(asc, Pivot, [H|T], [H|Menor], Maior) :-
    H @=< Pivot, !,
    partition(asc, Pivot, T, Menor, Maior).

partition(asc, Pivot, [H|T], Menor, [H|Maior]) :-
    partition(asc, Pivot, T, Menor, Maior).

partition(desc, Pivot, [H|T], [H|Menor], Maior) :-
    H @>= Pivot, !,
    partition(desc, Pivot, T, Menor, Maior).

partition(desc, Pivot, [H|T], Menor, [H|Maior]) :-
    partition(desc, Pivot, T, Menor, Maior).


media(Lista, Media) :-
    length(Lista, Tam),
    somatorio(Lista, Soma),
    Media is Soma / Tam.

somatorio([], 0).
somatorio([H|T], Soma) :-
    somatorio(T, SomaT),
    Soma is H + SomaT.


buscaPosicao(1, [X|_], X).
buscaPosicao(N, [_|T], X) :-
    N > 1,
    N1 is N - 1,
    buscaPosicao(N1, T, X).
