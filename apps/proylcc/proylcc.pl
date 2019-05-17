:- module(proylcc,
	[  
		emptyBoard/1,
		goMove/4,
		reemplazarBoard/6,
		limpiarAlrededor/5,
		cascaraLimpiarEncerrado/6,
		invertirColor/2,
		encerrado/7,
		contarFichas/3,
		contarEnCol/3,
		contarEnFila/3,
		rellenarCol/5,
		rellenarFila/5,
		cascaraEncerrarVacio/5
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
    limpiarAlrededor(RBoard, Fila, Col, Color, RRBoard),
    not(suicidio(RRBoard,Fila,Col,Color)).
	

%suicidio
suicidio(Board, Fila, Col, Color):-
	invertirColor(Color, ColorI),
	encerrado(Board, Fila, Col, ColorI, Color, "v", RBoard),
	Board \== RBoard.


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


%limpiarAlrededor
limpiarAlrededor(Board, Fila, Col, Color, RBoard):-
	FilaN is Fila-1,
	FilaNN is Fila+1,
	ColN is Col-1,
	ColNN is Col+1,
	invertirColor(Color,ColorI),
	cascaraLimpiarEncerrado(Board, FilaN, Col, Color, ColorI, Board1),
	cascaraLimpiarEncerrado(Board1, Fila, ColN, Color, ColorI, Board2),	
	cascaraLimpiarEncerrado(Board2, FilaNN, Col, Color, ColorI, Board3),
	cascaraLimpiarEncerrado(Board3, Fila, ColNN, Color, ColorI, RBoard).


%invertirColor
invertirColor("b","w").
invertirColor("w","b").


% si no esta encerrado devuelvo el mismo tablero
cascaraLimpiarEncerrado(Board, Fila, Col, ColorE, ColorV, Board):- 
	not(encerrado(Board, Fila, Col, ColorE, ColorV, "v", _RBoard)).
cascaraLimpiarEncerrado(Board, Fila, Col, ColorE, ColorV, RRBoard):-
	encerrado(Board, Fila, Col, ColorE, ColorV, "v", RBoard),
	%limpiar
	encerrado(RBoard, Fila, Col, ColorE, "v", "-", RRBoard).

%
%Board tablero de entrada
%Fila
%Col
%ColorE Encerrador
%ColorV Vistima
%ColorR color de reemplazo
%BoardSalida tablero de salida
%este es el caso donde me caigo del tablero
encerrado(Board, -1, _Col, _ColorE, _ColorV, _ColorR, Board):-!.
encerrado(Board, _Fila, -1, _ColorE, _ColorV, _ColorR, Board):-!.
encerrado(Board, 19, _Col, _ColorE, _ColorV, _ColorR, Board):-!.
encerrado(Board, _Fila, 19, _ColorE, _ColorV, _ColorR, Board):-!.
%este caso es donde el color de la ficha es del color encerrador
encerrado(Board, Fila, Col, ColorE, _ColorV, _ColorR, Board):-
	reemplazarBoard(ColorE, Board, Fila, Col, ColorE, Board),!.
%este es el caso donde la ficha ya esta visitada
encerrado(Board, Fila, Col, _ColorE, _ColorV, ColorR, Board):-
	reemplazarBoard(ColorR, Board, Fila, Col, ColorR, Board),!.
%caso general
encerrado(Board, Fila, Col, ColorE, ColorV, ColorR, RBoard):-
	%aca la dejo visitada
	!,
	reemplazarBoard(ColorV, Board, Fila, Col, ColorR, Board0), 
	%de aca en adelante visito las de alrededor
	FilaN is Fila-1,
	FilaNN is Fila+1,
	ColN is Col-1,
	ColNN is Col+1,
	encerrado(Board0, FilaN, Col, ColorE, ColorV, ColorR, Board1),
	encerrado(Board1, Fila, ColN, ColorE, ColorV, ColorR, Board2),	
	encerrado(Board2, FilaNN, Col, ColorE, ColorV, ColorR, Board3),
	encerrado(Board3, Fila, ColNN, ColorE, ColorV, ColorR, RBoard).


%cuento la cantidad de fichas negras y blancas
contarFichas(Board, CantBlancas, CantNegras):-
	rellenarCol(Board, 18, 18, "w", RBoardB),
	contarEnCol(RBoardB, "w", CantBlancas),
	rellenarCol(Board, 18, 18, "b", RBoardN),
	contarEnCol(RBoardN, "b", CantNegras).

contarEnCol([], _Color, 0).
contarEnCol([F|Bs], Color, Rta):-
	contarEnFila(F, Color, Rtaa),
	contarEnCol(Bs, Color, Rtab),
	Rta is Rtaa + Rtab.

contarEnFila([], _Color, 0).
contarEnFila([Color|Ls], Color, Rta):-
	contarEnFila(Ls, Color, Rtaa),
	Rta is Rtaa +1.
contarEnFila([X|Ls], Color, Rta):-
	X \= Color,
	contarEnFila(Ls, Color, Rta).	

rellenarCol(Board, _Fila, -1, _Color, Board).
rellenarCol(Board, Fila, Col, Color, RBoard):-
	NCol is Col - 1,
	rellenarFila(Board, Fila, Col, Color, RRBoard),
	rellenarCol(RRBoard, Fila, NCol, Color, RBoard).

rellenarFila(Board, -1, _Col, _Color, Board).
rellenarFila(Board, Fila, Col, Color, RBoard):-
	NFila is Fila - 1,
	cascaraEncerrarVacio(Board, Fila, Col, Color, RRBoard),
	rellenarFila(RRBoard, NFila, Col, Color, RBoard).

cascaraEncerrarVacio(Board, Fila, Col, Color, Board):-
	not(encerrado(Board, Fila, Col, Color, "-", Color, _RBoard)).
cascaraEncerrarVacio(Board, Fila, Col, Color, RBoard):-
	encerrado(Board, Fila, Col, Color, "-", Color, RBoard).
	