:- use_module(library(pce)).

% �adowanie biblioteki pce do tworzenia interfejsu graficznego.
start :-
    new(@window, picture('Wie�e Hanoi')),% Nowe okno
    send(@window, size, size(400, 400)),% Ustawienie rozmiaru okna
    draw_towers, %Rysowanie wie�
    InitialLeft = [3, 2, 1], % Inicjalizacja stanu pocz�tkowego wie�
    InitialCenter = [],% Inicjalizacja stanu pocz�tkowego wie�
    InitialRight = [],% Inicjalizacja stanu pocz�tkowego wie�
    send(@window, open),% Otwarcie okna
    move(3, InitialLeft, InitialCenter, InitialRight, _, _, _).% rozpocz�cie procedury przenoszenia dysk�w

% Rysowanie trzech wie�.
draw_towers :-
    %Tworzenie i wy�wietlanie �cie�ek dla ka�dej z wie�
    send(@window, display, new(Pa, path)),
    send(Pa, append, point(100, 100)),
    send(Pa, append, point(100, 250)),
    send(@window, display, new(Pb, path)),
    send(Pb, append, point(200, 100)),
    send(Pb, append, point(200, 250)),
    send(@window, display, new(Pc, path)),
    send(Pc, append, point(300, 100)),
    send(Pc, append, point(300, 250)).

% Rekurencyjne przenoszenie dysk�w.
move(0, Left, Center, Right, Left, Center, Right) :- draw(Left, Center, Right), !.% Bazowy przypadek rekursji
move(N, Left, Center, Right, FinalLeft, FinalCenter, FinalRight) :-
    N > 0, % Warunek kontynuacji rekursji
    M is N - 1, % Dekrementacja N do kolejnego wywo�ania rekurencyjnego
    move(M, Left, Right, Center, Left1, Right1, Center1),
    move_top(Left1, Center1, Left2, Center2),%Przeniesienie g�rnego dysku
    draw(Left2, Center2, Right1),  % Rysowanie aktualnego stanu
    sleep(1),  % Czekaj jedn� sekund�
    move(M, Right1, Center2, Left2, Right2, Center3, Left3),
    move(0, Left3, Center3, Right2, FinalLeft, FinalCenter, FinalRight).

% Przeniesienie g�rnego dysku z jednej wie�y na drug�
move_top([Top|RestSource], Target, RestSource, [Top|Target]).

%Rysowanie graficzne wie�
draw(Left, Center, Right) :-
    send(@window, clear),  % Czyszczenie poprzedniego stanu
    draw_towers,  % Rysowanie
    draw_disks(Left, 100), % Rysowanie dysk�w
    draw_disks(Center, 200), % Rysowanie dysk�w
    draw_disks(Right, 300). % Rysowanie dysk�w

% Rysowanie dysk� na okre�lonej wie�y
draw_disks(Disks, X) :-
    length(Disks, Len), % Obliczenie liczby dysk�w
    draw_disks(Disks, X, Len). % Rysowanie dysk�w

draw_disks([], _, _). % Przypadek bazowy - brak dysk�w do narysowania
draw_disks([D|Rest], X, N) :-
    %Obliczanie pozycji Y dla dysku
    Y is 250 - 20 * N, % przesuni�cie na podstawie liczby dysk�w
    %Rysowanie dysku (two�y nowy obiekt - prostok�t; i umieszcza go na ekranie, ze sta�� szeroko�ci�
    send(@window, display, new(T, box(40 - D*10, 20)), point(X - (40 - D*10)/2, Y)),
    send(T, fill_pattern, colour(green)), % ustawienie koloru na zielony
    NextN is N - 1, % Dekrementacja N, aby narysowa� kolejne dyski
    draw_disks(Rest, X, NextN).% Rekurencyjne wywo�anie
