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
        car1.name = "Car1";
        car2.name = "Car2";
        car1.nameColor = "black";
        car2.nameColor = "black";
        car1.position = new Vector(400, 200);
        car2.position = new Vector(400, 240);
        var environment = new Environment();
        environment.objects.push(Road.buildRoadCorner(new Vector(1275, 220), 1.5*Math.PI));
        environment.objects.push(Road.buildRoadCorner(new Vector(1275, 525), 0*Math.PI));
        environment.objects.push(Road.buildRoadCorner(new Vector(170, 525), 0.5*Math.PI));
        environment.objects.push(Road.buildRoadCorner(new Vector(170, 220), 1*Math.PI));
        environment.objects.push(Road.buildRoad(new Vector(722.5, 220), 1005, 0*Math.PI));
        environment.objects.push(Road.buildRoad(new Vector(1275, 372.5), 205, 0.5*Math.PI));
        environment.objects.push(Road.buildRoad(new Vector(722.5, 525), 1005, 0*Math.PI));
        environment.objects.push(Road.buildRoad(new Vector(170, 372.5), 205, 0.5*Math.PI));
        environment.objects.push(new Checkpoint(new Vector(425, 220), 12, 90, 0*Math.PI, 0, false));
        environment.objects.push(new Checkpoint(new Vector(722.5, 220), 12, 90, 0*Math.PI, 1, false));
        environment.objects.push(new Checkpoint(new Vector(1275, 372.5), 12, 90, 0.5*Math.PI, 2, false));
        environment.objects.push(new Checkpoint(new Vector(722.5, 525), 12, 90, 0*Math.PI, 3, false));
        environment.objects.push(new Checkpoint(new Vector(170, 372.5), 12, 90, 0.5*Math.PI, 4, true));

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

        function calculateScaleFactor() {
            var carDistance = car1.position.subtract(car2.position);
            var scaleFactor = 1.0;
            var scaleHorisontal = 1.0;
            var scaleVertical = 1.0;

            if (Math.abs(carDistance.y) >= canvas.height-50) {
                scaleVertical = (canvas.height-50)/Math.abs(carDistance.y);
            }
            if (Math.abs(carDistance.x) >= canvas.width-50) {
                scaleHorisontal = (canvas.width-50)/Math.abs(carDistance.x);
            }
            scaleFactor = Math.min(scaleHorisontal,scaleVertical);
            return scaleFactor;
        }

        function getCollidingObjects(point: Vector) {
            var collidingObjects = [];

            for(object in environment.objects) {
                if(Std.is(object, Collidable)) {
                    if(Collision.collidesWith(point, cast(object,Collidable))) {
                        collidingObjects.push(object);
                    }
                }
            }

            return collidingObjects;
        }

        function handleRoadCollision(car: Car) {
            car.frictionFactor = 0.032;
        }

        function handleCheckpointCollision(car: Car, checkpoint: Checkpoint) {
            if (checkpoint.number == car.progress && checkpoint.last) {
                car.progress = 0;
            }
            else if (checkpoint.number == car.progress) {
                car.progress += 1;
                if (car.progress == 1) {
                    car.lap += 1;
                }
            }
        }

        function handleCollisions(car: Car) {
            for(object in getCollidingObjects(car.position)) {
                if(Std.is(object, Checkpoint)) {
                    handleCheckpointCollision(car, cast(object, Checkpoint));
                }
                if(Std.is(object, Road)) {
                    handleRoadCollision(car);
                }
            }
        }

        function processCar(car: Car, up: String, left: String, down: String, right: String) {
            controlCar(car, up, left, down, right);
            car.frictionFactor = 0.048;
            handleCollisions(car);
            car.applyFriction();
            car.updatePosition();
        }

        function gameLoop() {
            processCar(car1, "ArrowUp", "ArrowLeft", "ArrowDown", "ArrowRight");
            processCar(car2, "w", "a", "s", "d");
            context.clearRect(0, 0, canvas.width, canvas.height);
            context.save();
            var scaleFactor = calculateScaleFactor();
            var focusPoint = car1.position.add(car2.position).divide(2/scaleFactor);
            var midPoint = new Vector(0.5*canvas.width,0.5*canvas.height);
            context.translate(midPoint.x-focusPoint.x, midPoint.y-focusPoint.y);
            context.scale(scaleFactor, scaleFactor);
            environment.draw(context);
            car1.draw(context);
            car2.draw(context);
            context.restore();
        }

        var timer = new haxe.Timer(30);
        timer.run = gameLoop;
    }
}
