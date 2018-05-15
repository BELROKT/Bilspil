class CompoundBox implements Drawable {
    public var position = new Vector(0, 0);
    public var angle = 0.0;
    public var boxList: Array<Box> = [];
    
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
}