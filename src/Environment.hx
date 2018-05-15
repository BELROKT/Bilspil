class Environment {
    public var objects: Array<Drawable> = [];

    public function new() {}

    public function draw(context: js.html.CanvasRenderingContext2D) {
        for(object in objects) {
            object.draw(context);
        }
    }

    public function buildRoad(position: Vector, length: Float, angle: Float, width = 100.0) {
        objects.push(new Box(position, length, width, angle, "#505554"));
        objects.push(new Box(position, length, width-10, angle, "#606665"));
    }

    public function buildRoadCorner(position: Vector, angle: Float, length = 100.0, width = 100.0) {
        var compoundBox = new CompoundBox();
        compoundBox.position = position;
        compoundBox.angle = angle;

        compoundBox.boxList.push(new Box(new Vector(0, 0), length, width, 0, "#505554"));
        compoundBox.boxList.push(new Box(new Vector(-2.5, -2.5), length-5, width-5, 0, "#606665"));
        compoundBox.boxList.push(new Box(new Vector(-0.5*length+2.5, -0.5*width+2.5), 5, 5, 0, "#505554"));
        objects.push(compoundBox);
    }
}