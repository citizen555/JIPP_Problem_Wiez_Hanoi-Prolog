:- use_module(library(pce)).

% £adowanie biblioteki pce do tworzenia interfejsu graficznego.
start :-
    new(@window, picture('Wie¿e Hanoi')),% Nowe okno
    send(@window, size, size(400, 400)),% Ustawienie rozmiaru okna
    draw_towers, %Rysowanie wie¿
    InitialLeft = [3, 2, 1], % Inicjalizacja stanu pocz¹tkowego wie¿
    InitialCenter = [],% Inicjalizacja stanu pocz¹tkowego wie¿
    InitialRight = [],% Inicjalizacja stanu pocz¹tkowego wie¿
    send(@window, open),% Otwarcie okna
    move(3, InitialLeft, InitialCenter, InitialRight, _, _, _).% rozpoczêcie procedury przenoszenia dysków

% Rysowanie trzech wie¿.
draw_towers :-
    %Tworzenie i wyœwietlanie œcie¿ek dla ka¿dej z wie¿
    send(@window, display, new(Pa, path)),
    send(Pa, append, point(100, 100)),
    send(Pa, append, point(100, 250)),
    send(@window, display, new(Pb, path)),
    send(Pb, append, point(200, 100)),
    send(Pb, append, point(200, 250)),
    send(@window, display, new(Pc, path)),
    send(Pc, append, point(300, 100)),
    send(Pc, append, point(300, 250)).

% Rekurencyjne przenoszenie dysków.
move(0, Left, Center, Right, Left, Center, Right) :- draw(Left, Center, Right), !.% Bazowy przypadek rekursji
move(N, Left, Center, Right, FinalLeft, FinalCenter, FinalRight) :-
    N > 0, % Warunek kontynuacji rekursji
    M is N - 1, % Dekrementacja N do kolejnego wywo³ania rekurencyjnego
    move(M, Left, Right, Center, Left1, Right1, Center1),
    move_top(Left1, Center1, Left2, Center2),%Przeniesienie górnego dysku
    draw(Left2, Center2, Right1),  % Rysowanie aktualnego stanu
    sleep(1),  % Czekaj jedn¹ sekundê
    move(M, Right1, Center2, Left2, Right2, Center3, Left3),
    move(0, Left3, Center3, Right2, FinalLeft, FinalCenter, FinalRight).

% Przeniesienie górnego dysku z jednej wie¿y na drug¹
move_top([Top|RestSource], Target, RestSource, [Top|Target]).

%Rysowanie graficzne wie¿
draw(Left, Center, Right) :-
    send(@window, clear),  % Czyszczenie poprzedniego stanu
    draw_towers,  % Rysowanie
    draw_disks(Left, 100), % Rysowanie dysków
    draw_disks(Center, 200), % Rysowanie dysków
    draw_disks(Right, 300). % Rysowanie dysków

% Rysowanie dyskó na okreœlonej wie¿y
draw_disks(Disks, X) :-
    length(Disks, Len), % Obliczenie liczby dysków
    draw_disks(Disks, X, Len). % Rysowanie dysków

draw_disks([], _, _). % Przypadek bazowy - brak dysków do narysowania
draw_disks([D|Rest], X, N) :-
    %Obliczanie pozycji Y dla dysku
    Y is 250 - 20 * N, % przesuniêcie na podstawie liczby dysków
    %Rysowanie dysku (two¿y nowy obiekt - prostok¹t; i umieszcza go na ekranie, ze sta³¹ szerokoœci¹
    send(@window, display, new(T, box(40 - D*10, 20)), point(X - (40 - D*10)/2, Y)),
    send(T, fill_pattern, colour(green)), % ustawienie koloru na zielony
    NextN is N - 1, % Dekrementacja N, aby narysowaæ kolejne dyski
    draw_disks(Rest, X, NextN).% Rekurencyjne wywo³anie
