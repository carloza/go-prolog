// Reference to object provided by pengines.js library which interfaces with Pengines server (Prolog-engine)
// by making query requests and receiving answers.
var pengine;
// Bidimensional array representing board configuration.
var gridData;
// Bidimensional array with board cell elements (HTML elements).
var cellElems;
// States if it's black player turn.
var turnBlack = false;
var bodyElem;
var latestStone;
//variable para ver si ya pasaron una vez
var passTurn = false;
var quienLlamo = "";
//variable de debuggeo
var debug = false;

/**
* Initialization function. Requests to server, through pengines.js library, 
* the creation of a Pengine instance, which will run Prolog code server-side.
*/

function init() {
    document.getElementById("passBtn").addEventListener('click', () => pasarTurno());
    document.getElementById("contarBtn").addEventListener('click', () => contarFichas());
    bodyElem = document.getElementsByTagName('body')[0];
    createBoard();
    // Creación de un conector (interface) para comunicarse con el servidor de Prolog.
    pengine = new Pengine({
        server: "http://localhost:3030/pengine",
        application: "proylcc",
        oncreate: handleCreate,
        onsuccess: handleSuccess,
        onfailure: handleFailure,
        destroy: false
    });
}

/**
 * Create grid cells elements
 */

function createBoard() {
    const dimension = 19;
    const boardCellsElem = document.getElementById("boardCells");
    for (let row = 0; row < dimension - 1; row++) {
        for (let col = 0; col < dimension - 1; col++) {
            var cellElem = document.createElement("div");
            cellElem.className = "boardCell";
            boardCellsElem.appendChild(cellElem);
        }
    }
    const gridCellsElem = document.getElementById("gridCells");
    cellElems = [];
    for (let row = 0; row < dimension; row++) {
        cellElems[row] = [];
        for (let col = 0; col < dimension; col++) {
            var cellElem = document.createElement("div");
            cellElem.className = "gridCell";
            cellElem.addEventListener('click', () => handleClick(row, col));
            gridCellsElem.appendChild(cellElem);
            cellElems[row][col] = cellElem;
        }
    }
}

/**
 * Callback for Pengine server creation
 */

function handleCreate() {
    quienLlamo = "fichaColocada"
    pengine.ask('emptyBoard(Board)');
}

/**
 * Callback for successful response received from Pengines server.
 */

function handleSuccess(response) {
    if(quienLlamo === "fichaColocada"){
        gridData = response.data[0].Board;
        for (let row = 0; row < gridData.length; row++){
            for (let col = 0; col < gridData[row].length; col++) {
                cellElems[row][col].className = "gridCell" +
                    (gridData[row][col] === "w" ? " stoneWhite" : gridData[row][col] === "b" ? " stoneBlack" : "") + (latestStone && row === latestStone[0] && col === latestStone[1] ? " latest" : "");
            }
        }
        switchTurn();
    }
    if(quienLlamo === "finPartida"){
        //aca actuo despues de haber consultado para ver al ganador
    }
    if(debug) alert("pase1");
    if(quienLlamo === "contarFichas"){
        //aca miro cuantas fichas tengo de cada color, por el momento esto es de prueba
        var cantBlancas = response.data[0].CantBlancas;
        var cantNegras = response.data[0].CantNegras;
        //alert("cantBlancas");
        alert("el jugador blanco colocó " + cantBlancas + " fichas y el juagaor negro colocó " + cantNegras + " fichas");
    }
    
}

/**
 * Called when the pengine fails to find a solution.
 */

function handleFailure() {
    alert("Invalid move!");
}

/**
 * Handler for color click. Ask query to Pengines server.
 */

function handleClick(row, col) {
    quienLlamo = "fichaColocada";
    const s = "goMove(" + Pengine.stringify(gridData) + "," + Pengine.stringify(turnBlack ? "b" : "w") + "," + "[" + row + "," + col + "]" + ",Board)";
    //alert(s);
    pengine.ask(s);
    latestStone = [row, col];
    passTurn = false;
}

function switchTurn() {
    turnBlack = !turnBlack;
    bodyElem.className = turnBlack ? "turnBlack" : "turnWhite";
}

function probando(){
    alert("boton de prueba");
}

function pasarTurno(){
    if(!passTurn){
        passTurn = true;
        switchTurn();
    }
    else{
        alert("juego finalizado");
        //aca consulto quien es el ganador
        //finPartida();
    }
}

function finPartida(){
    quienLlamo = "finPartida";
    const s = "string para ver quien ganó";
    pengine.ask(s);
}

function contarFichas(){
    quienLlamo = "contarFichas";
    const s = "contarFichas(" + Pengine.stringify(gridData) + ",CantBlancas,CantNegras)";
    pengine.ask(s);
    if(debug) alert(s);
}

/**
* Call init function after window loaded to ensure all HTML was created before
* accessing and manipulating it.
*/

window.onload = init;