class CompoundBox implements Drawable implements Collidable {
    public var position = new Vector(0, 0);
    public var angle = 0.0;
    public var boxList: Array<Box> = [];
    public var collisionBox: Box;
    
    public function new() {}

    public function draw(context: js.html.CanvasRenderingContext2D) {
        context.save();
        context.translate(position.x, position.y);
        context.rotate(angle);
        for(box in boxList) {
            box.draw(context);
        }
        context.restore();
    }

    public function getCollisionBox() {
        return collisionBox;
    }

    public function addCollisionBox(box: Box) {
        box.position = position.add(box.position.turnAngle(angle));
        box.angle = box.angle + angle;
        collisionBox = box;
    }
}