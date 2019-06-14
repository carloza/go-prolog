;Funcion cars
;Se toma la primera lista de la matriz M para luego tomar el primer elemento de dicha lista, 
;adicionalmente se llama al resto de la listas de la matriz M hasta que no haya mas listas.
;Luego se contanera todos los primeros elementos de cada lista devolviendo asi unalista 
;con todos los primeros elementos de cada lista de la matriz.
(DEFUN cars (M)
	(COND 
		((NULL M) NIL)
		(T(CONS (CAR (CAR M)) (cars (CDR M))))
	)		
)

;Funcion cdrs
;Similar a la funcion cars pero en vez de obtener las cabeza de las listas
;obiene una lista con las colas de todas las sublista de M
(DEFUN cdrs (M)
	(COND 
		((NULL M) NIL)
		(T(CONS (CDR (CAR M)) (cdrs (CDR M))))
	)
)

;Funcion esMatriz Cascara 
; funcion para corroborar que una lista de listas tenga forma de matriz
(DEFUN esMatrix(M)
	(esMatrixC (Longitud(CAR M)) M)
)

;Funcion esMatriz
;esta funcion tine sentido si es llamada desde esMatrixC
;lo que hace es verificar que todas las sublistas de M
;tengan el largo N, N es ingresado por parametro, y 
;corresponderia con el largo de la primer lista y si es
;matriz las demas listas deberian tener el mismo largo tambien
(DEFUN esMatrixC (N M)
	(COND
		((NULL M)
			T
		)
		((AND  (= N (Longitud (CAR M)))  (esMatrixC N (CDR M))
			);AND
			T
		)
		(T NIL)
	)
)

;Funcion transC.
;esta es la funcion que obtiene la matriz transpuesta de M
;lo que hace es obtener la primer columna con cars y llama
;recursivamente con cdrs para obtener las demas columnas
(DEFUN transC (M)
	(COND 
		((NULL M) NIL)
		((NULL (CAR M)) NIL)
		(T (CONS (cars M) (transC (cdrs M))))
	)
)

;Funcion trans (es una cascara)
;Primero se verifica que M sea una lista, luego se verifica que M sea una
;lista de listas y por ultimo se verifica que todas las listas de M tengan
;la misma cantidad de elementos. Si todo esta pipi cucu, llama a transC.
;Esto retornara una matriz transpuesta.
(DEFUN trans (M)
	(COND
		((AND (listp M) (listp(CAR M)) (esMatrix M))
			(transC M)
		)
		(T 
			(print "El parametro ingresado no tiene forma de Matriz.")
		)
	)
)

;------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------

;Función esPrimo
;Retorna N si N es primo, 0 caso contrario
;esto es una carcara, ya que la funcionlidad la hace RecPrimo
(DEFUN esPrimo (N)
	(COND((= N 1) 0)
		 ((> N 1) (RecPrimo N 2))
	)
)

;Funcion RecPrimo
;corrobora si un numero N es primo, si lo es retorna N
;en caso contrario retorna 0, la idea es simple, voy viendo 
;a partir de 2 si encuentro divisores, esto es ver si el 
;modulo da 0, si tiene divisores retorno 0, sino pruebo con
;el sigueinte eventualmento no encontraré divisores, entonces
;llegare a N, lo que indica que es primo, en ese punto retorno N 
(DEFUN RecPrimo (N M)
	(COND ((= M N) N)
		  ((< M N) (
			COND((= 0 (MOD N M)) 0)
			(T
				(RecPrimo N (+ 1 M))
			) 
			)
		)
	)
)

;Función sumaPrimos
;Retorna la suma de los primeros N números primos
(DEFUN sumaPrimos (N)
	(COND 
		((numberp N)(COND 	
						((< N 1) (print "N no es un numero positivo."))
						((= N 1) 0)
						((> N 1) (+ (esPrimo N) (sumaPrimos(- N 1)) )) 
					)
		)
		(T (print "N no es un numero natural.") )
	)
)


;------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------

;Función Longitud
;Retorna la longitud de la lista L
(DEFUN Longitud (L)
	(COND
		((NULL L) 0)
		(T	(+ 1 (Longitud (CDR L))))
	)
)

;Funcion BorrarElemento
;esta funcion elimina un elemento E de una lista L
;y retorna la la lista resultante sin dicho elemento
(DEFUN BorrarElemento(E L)
	(COND
		((=(Longitud L) 0) 
			NIL
		)
		((EQUAL(CAR L) E)
			(CDR L)
		)
		(T (CONS (CAR L)(BorrarElemento E (CDR L))))
	)
)


;Funcion derechoInverso
;esta funcion recive una lista L y restorna otra con 2 elementos
;el primer elemento es la lista L original y el segundo es una 
;lista con la cabeza de L precedida por su cola, es una lista de
;dos elementos devuelve una lista de lista, con el derecho y el
;inverso de L (esta ultima seria la permutacion para una lista 
;de 2 elementos)
(DEFUN derechoInverso(L)
	(LIST L (APPEND (CDR L) (LIST (CAR L))))
)

;Funcion ponerPrimero
;La funcion ponerPrimero recive un elemento E y una lista de listas L
;y lo que hace es agregar a E como primer elemento de las listas de L
(DEFUN ponerPrimero(E L)
	(COND
		((> (Longitud L) 0)
			(APPEND (LIST (CONS E (CAR L))) (ponerPrimero E (CDR L)) )
		)
		(T NIL)
	)
)

;Funcion PermLex y Permuta2
;Estas funciones son la logica principal de permLex, para que tenga logica su uso debe llamarse
;a permLex con una lista, el cual llamara a permuta2 con esta lista duplicada, de este modo la 
;primera servira de control y la otra servira para realizar las permutaciones, en el caso base
;lista tiene dos elementos lo cual las permutaciones posibles son al derecho y al inverso,
;en el caso recursivo se toma un elemento de la primer lista de "control" y se elimina de
;la segunda lista de "permutaciones", de este resto se obtienen todas la permutaciones a las
;cuales se le añadira el elemento sustraido anteriormente, asi por cada elemento de la lista de 
;control. Notar que al eliminar de la segunda lista esta reduce su tamaño lo cual eventualmente
;caera en el caso base de una lista de 2 elementos
(DEFUN permLex (L)
	(COND
		((listp L) 
		(COND
				((<(Longitud L) 2)
					L
				)
				(T
					(permuta2 L L)
				)
			)
		
		)
		(T 
			(print "L no es una Lista de elementos.")
		)
	)
)

;Funcion permuta2
(DEFUN permuta2(L1 L2)
	(COND
		((=(Longitud L2) 2) 
			(derechoInverso L2)
		)
		(T
			(COND
				((> (Longitud L1) 0)
					(APPEND (ponerPrimero (CAR L1)(permLex (BorrarElemento (CAR L1) L2))) (permuta2 (CDR L1) L2))
				)
				(T NIL)
			)
		)
	)
)