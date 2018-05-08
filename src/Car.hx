enum CarAction {Forward; Reverse; Right; Left;}

class Car {
    public var position = new Vector(0, 0);
    public var width = 24;
    public var length = 40;
    public var widthWheels = 4;
    public var lengthWheels = 8;
    public var angle = 0.5*Math.PI;
    public var maxVelocityForward = 8.0;
    public var maxVelocityReverse = 4.0;
    public var velocity = new Vector(0, 0);
    public var forwardAcceleration = 0.5;
    public var reverseAcceleration = 0.3;
    public var turnSpeed = 0.01;
    public var turnAngle = 0.0;
    public var friction = 0.05;
    public var color = "";

    public function new() {}

    public function draw(context: js.html.CanvasRenderingContext2D) {
        context.save();
        context.translate(position.x, position.y);
        context.rotate(angle);
        drawWheel(context, -0.3*length, -0.5*width, 0);
        drawWheel(context, -0.3*length, 0.5*width, 0);
        drawWheel(context, 0.3*length, -0.5*width, turnAngle);
        drawWheel(context, 0.3*length, 0.5*width, turnAngle);
        context.fillStyle = color;
        context.fillRect(-0.5*length, -0.5*width, length, width);
        context.restore();
    }

    public function drawWheel(context: js.html.CanvasRenderingContext2D, x: Float, y: Float, angle: Float) {
        context.save();
        context.translate(x, y);
        context.rotate(angle);
        context.fillStyle = "black";
        context.fillRect(-0.5*lengthWheels, -0.5*widthWheels, lengthWheels, widthWheels);
        context.restore();
    }

    function capSpeed(maxVelocity) {
        if (velocity.length() > maxVelocity) {
            velocity = velocity.unityVector().multiply(maxVelocity);
        }
    }

    public function updatePosition() {
        position = position.add(velocity);
    }

    public function controlInput(actions: Array<CarAction>) {
        turnAngle = 0;
        for(action in actions) {
            handleAction(action);
        }
    }

    function handleAction(action: CarAction) {
        if (action == Forward) {
            forward();
        }
        if (action == Reverse) {
            reverse();
        }
        if (action == Left) {
            left();
        }
        if (action == Right) {
            right();
        }
    }

    function forward() {
        velocity = velocity.add(Vector.fromAngle(angle).multiply(forwardAcceleration));
        capSpeed(maxVelocityForward);
    }

    function reverse() {
        var accelerationVector = Vector.fromAngle(angle + Math.PI).multiply(reverseAcceleration);

        velocity = velocity.add(accelerationVector);
        if (velocity.x*accelerationVector.x > 0 && velocity.y*accelerationVector.y > 0) {
            capSpeed(maxVelocityReverse);
        }
        else {
            capSpeed(maxVelocityForward);
        }
    }

    function left() {
        turnAngle -= 0.3;

        turn(-1);
    }

    function right() {
        turnAngle += 0.3;

        turn(1);
    }

    public function turn(direction: Float) {
        var relativeVelocity = getRelativeVelocity();
        if (relativeVelocity.x > 0) {
            angle += turnSpeed * direction * velocity.length();
        }
        if (relativeVelocity.x < 0) {
            angle -= turnSpeed * direction * velocity.length();
        }
        velocity = Vector.fromAngle(angle).multiply(relativeVelocity.x);
    }

    public function applyFriction() {
        velocity = velocity.subtract(velocity.unityVector().multiply(friction));
        if (velocity.length() < friction) {
            velocity = new Vector(0, 0);
        }
    }

    public function getRelativeVelocity() {
        if (velocity.length() == 0) {
            return new Vector(0, 0);
        }
        var temp = velocity.scalarProduct(Vector.fromAngle(angle))/velocity.length();
        
        if (temp > 1) {
            temp = 1;
        }
        if (temp < -1) {
            temp = -1;
        }

        var vinkel = Math.acos(temp);
        var relativeVelocity = Vector.fromAngle(vinkel).multiply(velocity.length());

        if (Math.isNaN(relativeVelocity.x)) {
            trace("x: " + velocity.x + " y: " + velocity.y);
            trace(temp);
        }

        return relativeVelocity;
    }
}