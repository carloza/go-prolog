:- module(proylcc,
	[  
		emptyBoard/1,
		goMove/4
	]).

% Empiezo a contar de 0 hasta 18 (19 filas x 19 columnas).
emptyBoard([
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"],
		 ["-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-","-"]
		 ]).

% goMove(+Board, +Player, +Pos, -RBoard)
% RBoard es la configuración resultante de reflejar la movida del jugador Player
% en la posición Pos a partir de la configuración Board.
goMove(Board, Color, [Fila,Col], RRBoard):-
	reemplazarBoard(Board, Fila, Col, Color, Board0),
    cascaraEncerrado(Board, Fila, Col, Color, RBoard).

%reemplazarBoard
reemplazarBoard(Board, Fila, Col, Color, RBoard);-
	replace(Fila, R, NFila, Board, RBoard),
    replace("-", Col, Color, Fila, NFila).

% replace(?X, +XIndex, +Y, +Xs, -XsY)
replace(X, 0, Y, [X|Xs], [Y|Xs]).

replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    replace(X, XIndexS, Y, Xs, XsY).

%cascaraEncerrado
cascaraEncerrado(Board, Fila, Col, Color, RBoard):-
	FilaN is Fila-1,
	FilaNN is Fila+1,
	ColN is Col-1,
	ColNN is Col+1,
	invertirColor(Color,ColorI),
	cascaraBuscarEncierro(Board0, FilaN, Col, ColorI, Board1),
	cascaraBuscarEncierro(Board1, Fila, ColN, ColorI, Board2),	
	cascaraBuscarEncierro(Board2, FilaNN, Col, ColorI, Board3),
	cascaraBuscarEncierro(Board3, Fila, ColNN, ColorI, RBoard).

%invertirColor
invertirColor(n,b).
invertirColor(b,n).

% cascaraBuscarEncerrado
cascaraBuscarEncerrado(Board, R, C, Color, Board):- 
	not(limpiarEncerrado(Board, R, C, Color, _RBoard)).

cascaraBuscarEncerrado(Board, Fila, Col, Color, RBoard):-
	limpiarEncerrado(Board, Fila, Col, Color, RBoard).


%aca estoy en los caso base donde me caigo del Board, no deberia moficar el Board
limpiarEncerrado(Board, -1, Col, Color, Board).
limpiarEncerrado(Board, Fila, -1, Color, Board).
limpiarEncerrado(Board, 19, Col, Color, Board).
limpiarEncerrado(Board, Fila, 19, Color, Board).

limpiarEncerrado(Board, Fila, Col, Color, Rta):-
	noVacio(Board, Fila, Col)), %aca verifico que esa celda no es vacia (si fuera vacia no estaria encerrada)
	replace(Board, Fila, Col, Color, Board), %miro que sea el color que venia limpiando
	replace(Board, Fila, Col, "-", Board0), %aca efectivamente la limpio (es decir coloco un vacio)
	%de aca en adelante limpio las de alrededor
	FilaN is Fila-1,
	FilaNN is Fila+1,
	ColN is Col-1,
	ColNN is Col+1,
	limpiarEncerrado(Board0, FilaN, Col, Color, Board1),
	limpiarEncerrado(Board1, Fila, ColN, Color, Board2),	
	limpiarEncerrado(Board2, FilaNN, Col, Color, Board3),
	limpiarEncerrado(Board3, Fila, ColNN, Color, RBoard).

% verVacio
	noVacio(Board, Fila, Col):-
		not(replace(Board,Fila,Col,"-",Board)).	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TODA LA BASURA QUE NO SIRBE QUEDARA DE ACA EN ADELANTE
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% adyacentes(Board, Fila, Col, *[[i, j, c]|....]*).
%


%adyacentes(Board, Fila, Col, R):-

% encerrado(+Board, +Fila, +Col, +Color, -Lista?(Para evitar ciclos).

/*
encerrado(Board, Fila, Col, Color, RBoard):-

	FilaN is Fila-1,
	FilaNN is Fila+1,
	ColN is Col-1,
	ColNN is Col+1,
	borrarBoard(Board, Fila, Col, Color, Board0),
	limpiarEncerrado(Board0, FilaN, Col, Color, Board1),
	limpiarEncerrado(Board1, Fila, ColN, Color, Board2),	
	limpiarEncerrado(Board2, FilaNN, Col, Color, Board3),
	limpiarEncerrado(Board3, Fila, ColNN, Color, RBoard).


% verVacio
	verVacio(Board, Fila, Col):-
		buscar(Board, Fila, NFila),
		buscar(NFila, Col, "-").

% buscar
	buscar([L|Ls], 0, L).
	buscar([L|Ls], N, Rta):-
		NN is N-1,
		buscar(Ls, NN, Rta).

*/