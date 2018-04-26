class Car {
    public var x = 500.0;
    public var y = 300.0;
    public var width = 24;
    public var length = 40;
    public var widthWheels = 32;
    public var lengthWheels = 8;
    public var angle = 1.5*Math.PI;
    public var forwardSpeed = 5;
    public var turnForwardSpeed = Math.PI/48;
    public var turnReverseSpeed = Math.PI/64;
    public var reverseSpeed = 3;
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

    public function forward() {
        x += forwardSpeed*Math.cos(angle);
        y += forwardSpeed*Math.sin(angle);
    }

    public function forwardLeft() {
        x += forwardSpeed*Math.cos(angle);
        y += forwardSpeed*Math.sin(angle);
        angle -= turnForwardSpeed;
    }

    public function forwardRight() {
        x += forwardSpeed*Math.cos(angle);
        y += forwardSpeed*Math.sin(angle);
        angle += turnForwardSpeed;
    }

    public function reverse() {
        x += reverseSpeed*Math.cos(angle + Math.PI);
        y += reverseSpeed*Math.sin(angle + Math.PI);
    }

    public function reverseLeft() {
        x += reverseSpeed*Math.cos(angle + Math.PI);
        y += reverseSpeed*Math.sin(angle + Math.PI);
        angle += turnReverseSpeed;
    }

    public function reverseRight() {
        x += reverseSpeed*Math.cos(angle + Math.PI);
        y += reverseSpeed*Math.sin(angle + Math.PI);
        angle -= turnReverseSpeed;
    }
}