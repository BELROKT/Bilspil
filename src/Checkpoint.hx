class Checkpoint extends Box {
    public var number: Int;
    public var last = false;

    public function new(position: Vector, width: Float, height: Float, angle: Float, number: Int, last: Bool) {
        super(position, width, height, angle, "#0c9b7c");
        this.number = number;
        this.last = last;
        if (number == 0) {
            color = "yellow";
        }
    }
}