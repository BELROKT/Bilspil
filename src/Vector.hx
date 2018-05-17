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

    public function unityVector() {
        if (length() == 0) {
            return new Vector(0, 0);
        }
        return divide(length());
    }

    public function scalarProduct(vector: Vector) {
        return x * vector.x + y * vector.y;
    }

    public function turnAngle(angle: Float) {
        var newVector = new Vector(0, 0);

        newVector = fromAngle(angle + getAngle()).multiply(length());

        if(Math.isNaN(newVector.x)) {
            newVector.x = 0;
        }
        if(Math.isNaN(newVector.y)) {
            newVector.y = 0;
        }

        return newVector;
    }

    public function getAngle() {
        return Math.acos((Math.pow(x, 2) + Math.pow(length(), 2) - Math.pow(y, 2)) / (2*x * length()));
    }

    public static function fromAngle(angle: Float) {
        var newVector = new Vector(0, 0);

        newVector.x = Math.cos(angle);
        newVector.y = Math.sin(angle);

        return newVector;
    }
}