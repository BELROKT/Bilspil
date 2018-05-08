class Environment {
    public var boxList: Array<Box> = [];

    public function new() {}

    public function draw(context: js.html.CanvasRenderingContext2D) {
        for(box in boxList) {
            box.draw(context);
        }
    }

    public function buildRoad(position: Vector, length: Float, angle: Float, width = 100.0) {
        boxList.push(new Box(position, length, width, angle, "#505554"));
        boxList.push(new Box(position, length, width-10, angle, "#606665"));
    }

    public function buildRoadCorner(position: Vector, angle: Float, length = 100.0, width = 100.0) {
        boxList.push(new Box(position, length, width, angle, "#505554"));
        boxList.push(new Box(position, length-10, width-10, angle, "#606665"));
    }
}