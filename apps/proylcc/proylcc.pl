:- module(proylcc,
	[  
		emptyBoard/1,
		goMove/4,
		reemplazarBoard/6,
		limpiarAlrededor/5,
		cascaraLimpiarEncerrado/5,
		invertirColor/2,
		encerrado/5,
		limpiar/4,
		contarFichas/3,
		contarCol/3,
		contarFila/3
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
	encerrado(Board, Fila, Col, Color, RBoard),
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
	cascaraLimpiarEncerrado(Board, FilaN, Col, ColorI, Board1),
	cascaraLimpiarEncerrado(Board1, Fila, ColN, ColorI, Board2),	
	cascaraLimpiarEncerrado(Board2, FilaNN, Col, ColorI, Board3),
	cascaraLimpiarEncerrado(Board3, Fila, ColNN, ColorI, RBoard).


%invertirColor
invertirColor("b","w").
invertirColor("w","b").


% cascaraBuscarEncerrado, si no esta encerrado devuelvo el mismo tablero
cascaraLimpiarEncerrado(Board, Fila, Col, Color, Board):- 
	not(encerrado(Board, Fila, Col, Color, _RBoard)).
cascaraLimpiarEncerrado(Board, Fila, Col, Color, RRBoard):-
	encerrado(Board, Fila, Col, Color, RBoard),
	limpiar(RBoard, Fila, Col, RRBoard).


%estos son los caso donde me caigo del Tablero, no deberia moficar el Tablero
encerrado(Board, -1, _Col, _Color, Board).
encerrado(Board, _Fila, -1, _Color, Board).
encerrado(Board, 19, _Col, _Color, Board).
encerrado(Board, _Fila, 19, _Color, Board).
%este es otro caso donde el color de la ficha es de otro color al que estoy buscando
encerrado(Board, Fila, Col, Color, Board):-
	invertirColor(Color, ColorI),
	reemplazarBoard(ColorI, Board, Fila, Col, ColorI, Board).
%este es el caso donde la ficha ya esta visitada
encerrado(Board, Fila, Col, _Color, Board):-
	reemplazarBoard("v", Board, Fila, Col, "v", Board).
%caso general
encerrado(Board, Fila, Col, Color, RBoard):-
	%aca la dejo visitada
	reemplazarBoard(Color, Board, Fila, Col, "v", Board0), 
	%de aca en adelante visito las de alrededor
	FilaN is Fila-1,
	FilaNN is Fila+1,
	ColN is Col-1,
	ColNN is Col+1,
	encerrado(Board0, FilaN, Col, Color, Board1),
	encerrado(Board1, Fila, ColN, Color, Board2),	
	encerrado(Board2, FilaNN, Col, Color, Board3),
	encerrado(Board3, Fila, ColNN, Color, RBoard).


%estos son los caso donde me caigo del Tablero, no deberia moficar el Tablero
limpiar(Board, -1, _Col, Board).
limpiar(Board, _Fila, -1, Board).
limpiar(Board, 19, _Col, Board).
limpiar(Board, _Fila, 19, Board).
%este es otro caso donde la ficha no es una visitada
limpiar(Board, Fila, Col, Board):-
	reemplazarBoard("b", Board, Fila, Col, "b", Board).
limpiar(Board, Fila, Col, Board):-
	reemplazarBoard("w", Board, Fila, Col, "w", Board).
%este es el caso donde la ficha ya fue limpiada
limpiar(Board, Fila, Col, Board):-
	reemplazarBoard("-", Board, Fila, Col, "-", Board).
%caso general
limpiar(Board, Fila, Col, RBoard):-
	%aca la dejo visitada
	reemplazarBoard("v", Board, Fila, Col, "-", Board0), 
	%de aca en adelante visito las de alrededor
	FilaN is Fila-1,
	FilaNN is Fila+1,
	ColN is Col-1,
	ColNN is Col+1,
	limpiar(Board0, FilaN, Col, Board1),
	limpiar(Board1, Fila, ColN, Board2),	
	limpiar(Board2, FilaNN, Col, Board3),
	limpiar(Board3, Fila, ColNN, RBoard).


%cuento la cantidad de fichas negras y blancas
contarFichas(Board, CantBlancas, CantNegras):-
	contarCol(Board, "w", CantBlancas),
	contarCol(Board, "b", CantNegras).

contarCol([], _Color, 0).
contarCol([F|Bs], Color, Rta):-
	contarFila(F, Color, Rtaa),
	contarCol(Bs, Color, Rtab),
	Rta is Rtaa + Rtab.

contarFila([], _Color, 0).
contarFila([Color|Ls], Color, Rta):-
	contarFila(Ls, Color, Rtaa),
	Rta is Rtaa +1.
contarFila([X|Ls], Color, Rta):-
	X \= Color,
	contarFila(Ls, Color, Rta).

