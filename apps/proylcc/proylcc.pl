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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% goMove(+Board, +Player, +Pos, -RBoard)
%
% RBoard es la configuración resultante de reflejar la movida del jugador Player
% en la posición Pos a partir de la configuración Board.

goMove(Board, Player, [R,C], RBoard):-
	replace(Row, R, NRow, Board, RBoard),
    replace("-", C, Player, Row, NRow).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%

replace(X, 0, Y, [X|Xs], [Y|Xs]).

replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    replace(X, XIndexS, Y, Xs, XsY).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% encerrado(+Tablero, +Fila, +Col, +Color, -Lista?(Para evitar ciclos).
%
/*
encerrado(Board, Fila, Col, Color, RBoard):-

	FilaN is Fila-1,
	FilaNN is Fila+1,
	ColN is Col-1,
	ColNN is Col+1,
	borrarTablero(Board, Fila, Col, Color, Tablero0),
	buscarEncerrado(Tablero0, FilaN, Col, Color, Tablero1),
	buscarEncerrado(Tablero1, Fila, ColN, Color, Tablero2),	
	buscarEncerrado(Tablero2, FilaNN, Col, Color, Tablero3),
	buscarEncerrado(Tablero3, Fila, ColNN, Color, RBoard).
*/
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% buscarEncerrado
%
buscarEncerrado(Board, -1, Col, Color, Board).

buscarEncerrado(Board, Fila, -1, Color, Board).

buscarEncerrado(Board, 19, Col, Color, Board).

buscarEncerrado(Board, Fila, 19, Color, Board).

buscarEncerrado(Board, Fila, Col, Color, Rta):-
	not(verVacio(Board, Fila, Col)),
	replace(Board, Fila, Col, Color, Board),
	FilaN is Fila-1,
	FilaNN is Fila+1,
	ColN is Col-1,
	ColNN is Col+1,
	replace(Board, Fila, Col, "-", Tablero0),
	buscarEncerrado(Tablero0, FilaN, Col, Color, Tablero1),
	buscarEncerrado(Tablero1, Fila, ColN, Color, Tablero2),	
	buscarEncerrado(Tablero2, FilaNN, Col, Color, Tablero3),
	buscarEncerrado(Tablero3, Fila, ColNN, Color, RBoard).
	
	
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% verVacio
%	
	verVacio(Board, Fila, Col):-
		buscar(Board, Fila, NFila),
		buscar(NFila, Col, "-").
		
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% buscar
%	
	buscar([L|Ls], 0, L).
	buscar([L|Ls], N, Rta):-
		NN is N-1,
		buscar(Ls, NN, Rta).
	
	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% adyacentes(Tablero, Fila, Col, *[[i, j, c]|....]*).
%


%adyacentes(Board, Fila, Col, R):-



