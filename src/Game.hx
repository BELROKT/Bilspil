class Game {
    var canvas: js.html.CanvasElement;
    var context: js.html.CanvasRenderingContext2D;
    var pressedKeys = new Map<String, Bool>();

    var cars: Array<Car> = [];
    var environments: Array<Environment> = [];
    var currentEnvironment: Environment;

    public function new(canvas: js.html.CanvasElement, context: js.html.CanvasRenderingContext2D, pressedKeys: Map<String, Bool>) {
        this.canvas = canvas;
        this.context = context;
        this.pressedKeys = pressedKeys;
        var car = new Car();
        car.color = "#800000";
        car.name = "Car1";
        car.nameColor = "black";
        cars.push(car);
        car = new Car();
        car.color = "#434ea1";
        car.name = "Car2";
        car.nameColor = "black";
        cars.push(car);

        addEnvironments();
        changeEnvironment(environments[0]);
    }

    function addEnvironments() {
        var environment = new Environment();
        environment.startPositions.push(new Vector(400, 200));
        environment.startPositions.push(new Vector(400, 240));
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
        environments.push(environment);

        environment = new Environment();
        environment.startPositions.push(new Vector(400, 200));
        environment.startPositions.push(new Vector(400, 240));
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
        environments.push(environment);
    }

    function changeEnvironment(environment: Environment) {
        currentEnvironment = environment;
        for(car in cars) {
            car.lap = 0;
            car.progress = 0;
            car.velocity = new Vector(0, 0);
            car.position = currentEnvironment.startPositions[0];
        }
    }

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
        var carDistance = cars[0].position.subtract(cars[1].position);
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

        for(object in currentEnvironment.objects) {
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

    public function gameLoop() {
        processCar(cars[0], "ArrowUp", "ArrowLeft", "ArrowDown", "ArrowRight");
        processCar(cars[1], "w", "a", "s", "d");
        context.clearRect(0, 0, canvas.width, canvas.height);
        context.save();
        var scaleFactor = calculateScaleFactor();
        var focusPoint = cars[0].position.add(cars[1].position).divide(2/scaleFactor);
        var midPoint = new Vector(0.5*canvas.width,0.5*canvas.height);
        context.translate(midPoint.x-focusPoint.x, midPoint.y-focusPoint.y);
        context.scale(scaleFactor, scaleFactor);
        currentEnvironment.draw(context);
        for(car in cars){
            car.draw(context);
        }
        context.restore();
    }
}