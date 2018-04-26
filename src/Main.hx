import js.Browser;

class Main {
    static function main() {
        trace("Hello, world!");
        var canvas = Browser.document.createCanvasElement();
        var context = canvas.getContext2d();
        context.fillRect(345,5,657,123);
        Browser.document.body.appendChild(canvas);
        canvas.width = Browser.window.innerWidth;
        canvas.height = Browser.window.innerHeight;
        canvas.style.backgroundColor = "black";
        function onResize() {
            canvas.width = Browser.window.innerWidth;
            canvas.height = Browser.window.innerHeight;
        }
        Browser.window.onresize = onResize;

        var pressedKeys = new Map<String, Bool>();
        var car = new Car();

        Browser.window.addEventListener("keyup", function (event) {
            pressedKeys[event.key] = false;
        });
        Browser.window.addEventListener("keydown", function (event) {
            pressedKeys[event.key] = true;
        });

        function gameLoop() {
            if (pressedKeys["ArrowUp"]) {
                car.y -= 5;
            }
            if (pressedKeys["ArrowLeft"]) {
                car.x -= 5;
            }
            if (pressedKeys["ArrowDown"]) {
                car.y += 5;
            }
            if (pressedKeys["ArrowRight"]) {
                car.x += 5;
            }
            context.fillStyle = "black";
            context.fillRect(0, 0, canvas.width, canvas.height);
            car.draw(context);
        }
        var timer = new haxe.Timer(30);
        timer.run = gameLoop;
    }
}
