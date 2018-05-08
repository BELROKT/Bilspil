import js.Browser;

class Main {
    static function main() {
        var canvas = Browser.document.createCanvasElement();
        var context = canvas.getContext2d();
        context.fillRect(345,5,657,123);
        Browser.document.body.appendChild(canvas);
        canvas.width = Browser.window.innerWidth;
        canvas.height = Browser.window.innerHeight;
        canvas.style.backgroundColor = "olivedrab";
        function onResize() {
            canvas.width = Browser.window.innerWidth;
            canvas.height = Browser.window.innerHeight;
        }
        Browser.window.onresize = onResize;
        
        var pressedKeys = new Map<String, Bool>();
        var car1 = new Car();
        var car2 = new Car();
        car1.color = "#800000";
        car2.color = "#434ea1";
        car1.position = new Vector(400, 200);
        car2.position = new Vector(400, 240);
        var environment = new Environment();
        environment.buildRoadCorner(new Vector(1275, 220), 0*Math.PI);
        environment.buildRoadCorner(new Vector(1275, 525), 0*Math.PI);
        environment.buildRoadCorner(new Vector(170, 525), 0*Math.PI);
        environment.buildRoadCorner(new Vector(170, 220), 0*Math.PI);
        environment.buildRoad(new Vector(722.5, 220), 1015, 0*Math.PI);
        environment.buildRoad(new Vector(1275, 372.5), 215, 0.5*Math.PI);
        environment.buildRoad(new Vector(722.5, 525), 1015, 0*Math.PI);
        environment.buildRoad(new Vector(170, 372.5), 215, 0.5*Math.PI);
        environment.boxList.push(new Box(new Vector(425, 220), 4, 90, 0*Math.PI, "yellow"));

        Browser.window.addEventListener("keyup", function (event) {
            pressedKeys[event.key] = false;
        });
        Browser.window.addEventListener("keydown", function (event) {
            pressedKeys[event.key] = true;
        });

        function controlCar(car: Car, up: String, left: String, down: String, right: String) {
            var actions: Array<Car.CarAction> = [];
            if (pressedKeys[up]) {
                actions.push(Forward);
            }
            if (pressedKeys[down]) {
                actions.push(Reverse);
            }
            if (pressedKeys[left]) {
                actions.push(Left);
            }
            if (pressedKeys[right]) {
                actions.push(Right);
            }
            car.controlInput(actions);
        }

        function gameLoop() {
            controlCar(car1, "ArrowUp", "ArrowLeft", "ArrowDown", "ArrowRight");
            controlCar(car2, "w", "a", "s", "d");
            car1.applyFriction();
            car2.applyFriction();
            car1.updatePosition();
            car2.updatePosition();
            context.clearRect(0, 0, canvas.width, canvas.height);
            environment.draw(context);
            car1.draw(context);
            car2.draw(context);
        }

        var timer = new haxe.Timer(30);
        timer.run = gameLoop;
    }
}
