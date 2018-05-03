class Car {
    public var position = new Vector(0, 0);
    public var width = 24;
    public var length = 40;
    public var widthWheels = 32;
    public var lengthWheels = 8;
    public var angle = 0.5*Math.PI;
    public var maxVelocity = 5.0;
    public var velocity = new Vector(0, 0);
    public var forwardAcceleration = 0.5;
    public var turnForwardSpeed = 0.01;
    public var turnReverseSpeed = 0.01;
    public var reverseAcceleration = 0.3;
    public var friction = 0.05;
    public var color = "";

    public function new() {}

    public function draw(context: js.html.CanvasRenderingContext2D) {
        context.save();
        context.translate(position.x, position.y);
        context.rotate(angle);
        context.fillStyle = "black";
        context.fillRect(-0.4*length, -(2/3)*width, lengthWheels, widthWheels);
        context.fillRect(0.2*length, -(2/3)*width, lengthWheels, widthWheels);
        context.fillStyle = color;
        context.fillRect(-0.5*length, -0.5*width, length, width);
        context.restore();
    }

    function capSpeed() {
        if (velocity.length() > maxVelocity) {
            velocity = velocity.unityVector().multiply(maxVelocity);
        }
    }

    public function updatePosition() {
        position = position.add(velocity);
    }

    public function forward() {
        velocity = velocity.add(Vector.fromAngle(angle).multiply(forwardAcceleration));
        capSpeed();
    }

    public function reverse() {
        velocity = velocity.add(Vector.fromAngle(angle + Math.PI).multiply(reverseAcceleration));
        capSpeed();
    }

    public function left() {
        turn(-1);
    }

    public function right() {
        turn(1);
    }

    public function turn(direction: Float) {
        var relativeVelocity = getRelativeVelocity();
        if (relativeVelocity.x > 0) {
            angle += turnForwardSpeed * direction * velocity.length();
        }
        if (relativeVelocity.x < 0) {
            angle -= turnReverseSpeed * direction * velocity.length();
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