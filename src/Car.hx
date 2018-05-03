class Car {
    public var position = new Vector(0, 0);
    public var width = 24;
    public var length = 40;
    public var widthWheels = 32;
    public var lengthWheels = 8;
    public var angle = 0.5*Math.PI;
    public var maxVelocity = 3;
    public var velocity = new Vector(0, 0);
    public var forwardAcceleration = 0.5;
    public var turnForwardSpeed = Math.PI/48;
    public var turnReverseSpeed = Math.PI/64;
    public var reverseAcceleration = 0.3;
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
        if (velocity.x > maxVelocity) {
            velocity.x = maxVelocity;
        }
        if (velocity.x < -maxVelocity) {
            velocity.x = -maxVelocity;
        }
        if (velocity.y > maxVelocity) {
            velocity.y = maxVelocity;
        }
        if (velocity.y < -maxVelocity) {
            velocity.y = -maxVelocity;
        }
    }

    public function updatePosition() {
        position = position.add(velocity);
    }

    public function forward() {
        velocity = velocity.add(Vector.fromAngle(angle).multiply(forwardAcceleration));
        capSpeed();
    }

    public function forwardLeft() {
        velocity = velocity.add(Vector.fromAngle(angle).multiply(forwardAcceleration));
        angle -= turnForwardSpeed;
        capSpeed();
    }

    public function forwardRight() {
        velocity = velocity.add(Vector.fromAngle(angle).multiply(forwardAcceleration));
        angle += turnForwardSpeed;
        capSpeed();
    }

    public function reverse() {
        velocity = velocity.add(Vector.fromAngle(angle + Math.PI).multiply(reverseAcceleration));
        capSpeed();
    }

    public function reverseLeft() {
        velocity = velocity.add(Vector.fromAngle(angle + Math.PI).multiply(reverseAcceleration));
        angle += turnReverseSpeed;
        capSpeed();
    }

    public function reverseRight() {
        velocity = velocity.add(Vector.fromAngle(angle + Math.PI).multiply(reverseAcceleration));
        angle -= turnReverseSpeed;
        capSpeed();
    }
}