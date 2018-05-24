import js.Browser;

class Main {
    static function main() {
        var canvas = Browser.document.createCanvasElement();
        var context = canvas.getContext2d();
        context.fillRect(345,5,657,123);
        Browser.document.body.appendChild(canvas);
        canvas.width = Browser.window.innerWidth;
        canvas.height = Browser.window.innerHeight;
        canvas.style.backgroundColor = "olivedrab";
        function onResize() {
            canvas.width = Browser.window.innerWidth;
            canvas.height = Browser.window.innerHeight;
        }
        Browser.window.onresize = onResize;
        
        var pressedKeys = new Map<String, Bool>();

        Browser.window.addEventListener("keyup", function (event) {
            pressedKeys[event.key] = false;
        });
        Browser.window.addEventListener("keydown", function (event) {
            pressedKeys[event.key] = true;
        });

        var game = new Game(canvas, context, pressedKeys);

        var timer = new haxe.Timer(30);
        timer.run = game.gameLoop;
    }
}
