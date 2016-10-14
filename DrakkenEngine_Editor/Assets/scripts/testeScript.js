function Awake() {
    consoleLog("Awake");
}

function Start() {
    consoleLog("Start");
}

var p = transform.position.x;
var d = 1;

function Update() {
    transform.position.Set(p, transform.position.y, 0);
    
    p += 1 * d;
    
    if(d > 0 && p > 200)
        d = -1
        
    if(d < 0 && p < -200)
        d = 1
}
