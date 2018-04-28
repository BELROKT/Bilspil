class Car {
    public var x = 500.0;
    public var y = 300.0;
    public var width = 24;
    public var length = 40;
    public var widthWheels = 32;
    public var lengthWheels = 8;
    public var angle = 0.5*Math.PI;
    public var maxSpeed = 3;
    public var speedX = 0.0;
    public var speedY = 0.0;
    public var forwardAcceleration = 0.5;
    public var turnForwardSpeed = Math.PI/48;
    public var turnReverseSpeed = Math.PI/64;
    public var reverseAcceleration = 0.3;
    public var color = "";

    public function new() {}

    public function draw(context: js.html.CanvasRenderingContext2D) {
        context.save();
        context.translate(x, y);
        context.rotate(angle);
        context.fillStyle = "black";
        context.fillRect(-0.4*length, -(2/3)*width, lengthWheels, widthWheels);
        context.fillRect(0.2*length, -(2/3)*width, lengthWheels, widthWheels);
        context.fillStyle = color;
        context.fillRect(-0.5*length, -0.5*width, length, width);
        context.restore();
    }

    function capSpeed() {
        if (speedX > maxSpeed) {
            speedX = maxSpeed;
        }
        if (speedX < -maxSpeed) {
            speedX = -maxSpeed;
        }
        if (speedY > maxSpeed) {
            speedY = maxSpeed;
        }
        if (speedY < -maxSpeed) {
            speedY = -maxSpeed;
        }
    }

    public function updatePosition() {
        x += speedX;
        y += speedY;
    }

    public function forward() {
        speedX += forwardAcceleration*Math.cos(angle);
        speedY += forwardAcceleration*Math.sin(angle);
        capSpeed();
    }

    public function forwardLeft() {
        speedX += forwardAcceleration*Math.cos(angle);
        speedY += forwardAcceleration*Math.sin(angle);
        angle -= turnForwardSpeed;
        capSpeed();
    }

    public function forwardRight() {
        speedX += forwardAcceleration*Math.cos(angle);
        speedY += forwardAcceleration*Math.sin(angle);
        angle += turnForwardSpeed;
        capSpeed();
    }

    public function reverse() {
        speedX += reverseAcceleration*Math.cos(angle + Math.PI);
        speedY += reverseAcceleration*Math.sin(angle + Math.PI);
        capSpeed();
    }

    public function reverseLeft() {
        speedX += reverseAcceleration*Math.cos(angle + Math.PI);
        speedY += reverseAcceleration*Math.sin(angle + Math.PI);
        angle += turnReverseSpeed;
        capSpeed();
    }

    public function reverseRight() {
        speedX += reverseAcceleration*Math.cos(angle + Math.PI);
        speedY += reverseAcceleration*Math.sin(angle + Math.PI);
        angle -= turnReverseSpeed;
        capSpeed();
    }
}