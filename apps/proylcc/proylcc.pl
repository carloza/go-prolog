:- module(proylcc,
	[  
		emptyBoard/1,
		goMove/4,
		reemplazarBoard/6,
		cascaraEncerrado/5,
		cascaraBuscarEncierro/5,
		invertirColor/2,
		limpiarEncerrado/5,
		noVacio/3
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
	reemplazarBoard("-", Board, Fila, Col, Color, RBoard),
	%not(suicidio()).
    cascaraEncerrado(RBoard, Fila, Col, Color, RRBoard).

%reemplazarBoard
reemplazarBoard(Ant ,Board, F, C, Color, RBoard):-
	replace(Fila, F, NFila, Board, RBoard),
    replace(Ant, C, Color, Fila, NFila).

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
	cascaraBuscarEncierro(Board, FilaN, Col, ColorI, Board1),
	cascaraBuscarEncierro(Board1, Fila, ColN, ColorI, Board2),	
	cascaraBuscarEncierro(Board2, FilaNN, Col, ColorI, Board3),
	cascaraBuscarEncierro(Board3, Fila, ColNN, ColorI, RBoard).

%invertirColor
invertirColor(b,w).
invertirColor(w,b).

% cascaraBuscarEncerrado, si limpiar falla devuelvo el mimso tablero, es decir limpio
cascaraBuscarEncierro(Board, R, C, Color, Board):- 
	not(limpiarEncerrado(Board, R, C, Color, _RBoard)).
cascaraBuscarEncierro(Board, Fila, Col, Color, RBoard):-
	limpiarEncerrado(Board, Fila, Col, Color, RBoard).


%estos son los caso donde me caigo del Tablero, no deberia moficar el Board
limpiarEncerrado(Board, -1, _Col, _Color, Board).
limpiarEncerrado(Board, _Fila, -1, _Color, Board).
limpiarEncerrado(Board, 19, _Col, _Color, Board).
limpiarEncerrado(Board, _Fila, 19, _Color, Board).
%este es otro caso donde el color de la ficha es de otro color al que estoy limpiando
limpiarEncerrado(Board, Fila, Col, Color, Board):-
	invertirColor(Color, ColorI),
	reemplazarBoard(ColorI, Board, Fila, Col, ColorI, Board).
%caso general
limpiarEncerrado(Board, Fila, Col, Color, RBoard):-
	noVacio(Board, Fila, Col), %aca verifico que esa celda no es vacia (si fuera vacia no estaria encerrada)
	%reemplazarBoard( _, Board, Fila, Col, Color, Board), %miro que sea el color que venia limpiando
	reemplazarBoard(Color, Board, Fila, Col, "-", Board0), %aca efectivamente la limpio (es decir coloco un vacio)
														   %tambien verificaria si es del color que venia cambiando
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
	not(reemplazarBoard("-",Board,Fila,Col,"-",Board)).	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TODA LA BASURA QUE NO SIRBE QUEDARA DE ACA EN ADELANTE
%LUEGO ELIMINAREMOS
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