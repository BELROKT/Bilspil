class Road extends CompoundBox {
    

    public static function buildRoad(position: Vector, length: Float, angle: Float, width = 100.0) {
        var road = new Road();
        road.position = position;
        road.angle = angle;

        road.boxList.push(new Box(new Vector(0, 0), length, width, 0, "#505554"));
        road.boxList.push(new Box(new Vector(0, 0), length, width-10, 0, "#606665"));
        road.addCollisionBox(new Box(new Vector(0, 0), length, width, 0, "#505554"));
        return road;
    }

    public static function buildRoadCorner(position: Vector, angle: Float, length = 100.0, width = 100.0) {
        var road = new Road();
        road.position = position;
        road.angle = angle;

        road.boxList.push(new Box(new Vector(0, 0), length, width, 0, "#505554"));
        road.boxList.push(new Box(new Vector(-2.5, -2.5), length-5, width-5, 0, "#606665"));
        road.boxList.push(new Box(new Vector(-0.5*length+2.5, -0.5*width+2.5), 5, 5, 0, "#505554"));
        road.addCollisionBox(new Box(new Vector(0, 0), length, width, 0, "#505554"));
        return road;
    }
}