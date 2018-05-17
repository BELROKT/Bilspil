class Box implements Drawable implements Collidable {
    public var position = new Vector(0, 0);
    public var width = 0.0;
    public var height = 0.0;
    public var angle = 0.0;
    public var color = "";

    public function new(position: Vector, width: Float, height: Float, angle: Float, color: String) {
        this.position = position;
        this.width = width;
        this.height = height;
        this.angle = angle;
        this.color = color;
    }

    public function draw(context: js.html.CanvasRenderingContext2D) {
        context.save();
        context.translate(position.x, position.y);
        context.rotate(angle);
        context.fillStyle = color;
        context.fillRect(-0.5*width, -0.5*height, width, height)
        context.restore();
    }

    public function getCollisionBox() {
        return this;
    }
}