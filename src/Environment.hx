enum Terrain {Grass; Road;}

class Environment {
    public var objects: Array<Drawable> = [];

    public function new() {}

    public function draw(context: js.html.CanvasRenderingContext2D) {
        for(object in objects) {
            object.draw(context);
        }
    }
}