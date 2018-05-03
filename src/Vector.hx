class Vector {
    public var x = 0.0;
    public var y = 0.0;

    public function new(X: Float, Y: Float) {
        x = X;
        y = Y;
    }

    public function add(vector: Vector):Vector {
        var newVector = new Vector(0, 0);

        newVector.x = x + vector.x;
        newVector.y = y + vector.y;

        return newVector;
    }

    public function subtract(vector: Vector) {
        var newVector = new Vector(0, 0);

        newVector.x = x - vector.x;
        newVector.y = y - vector.y;

        return newVector;
    }

    public function multiply(scalar: Float) {
        var newVector = new Vector(0, 0);

        newVector.x = x * scalar;
        newVector.y = y * scalar;

        return newVector;
    }

    public function divide(scalar: Float) {
        var newVector = new Vector(0, 0);

        newVector.x = x / scalar;
        newVector.y = y / scalar;

        return newVector;
    }

    public function length() {
        return Math.sqrt(x*x+y*y);
    }

    public static function fromAngle(angle: Float) {
        var newVector = new Vector(0, 0);

        newVector.x = Math.cos(angle);
        newVector.y = Math.sin(angle);

        return newVector;
    }
}