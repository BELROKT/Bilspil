class Car {
    public var x = 550;
    public var y = 300;
    
    public function new() {}

    public function draw(context: js.html.CanvasRenderingContext2D) {
        context.fillStyle = "red";
        context.fillRect(x, y, 20, 20);
    }
}