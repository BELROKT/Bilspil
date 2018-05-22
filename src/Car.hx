enum CarAction {Forward; Reverse; Right; Left;}

class Car {
    public var position = new Vector(0, 0);
    public var width = 24;
    public var length = 40;
    public var widthWheels = 4;
    public var lengthWheels = 8;
    public var angle = 0*Math.PI;
    public var velocity = new Vector(0, 0);
    public var baseForwardAcceleration = 0.5;
    public var baseReverseAcceleration = 0.3;
    public var forwardAcceleration = 0.5;
    public var reverseAcceleration = 0.3;
    public var turnSpeed = 0.01;
    public var turnAngle = 0.0;
    public var friction = 0.0;
    public var color = "";
    public var name = "";
    public var nameColor = "";

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
        context.fillStyle = nameColor;
        context.font = "16px Arial";
        context.textAlign = "center";
        context.textBaseline = "middle";
        context.fillText(name, 0, 1, 38);
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
    }

    function reverse() {
        var accelerationVector = Vector.fromAngle(angle + Math.PI).multiply(reverseAcceleration);

        velocity = velocity.add(accelerationVector);
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

    public function applyFriction(frictionFactor: Float) {
        friction = velocity.length() * frictionFactor;
        forwardAcceleration = baseForwardAcceleration - friction;
        reverseAcceleration = baseReverseAcceleration - friction;
        
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