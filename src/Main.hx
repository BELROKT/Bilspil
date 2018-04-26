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
        var car1 = new Car();
        var car2 = new Car();
        car1.color = "#800000";
        car2.color = "#434ea1";
        car1.x = 600;
        car2.x = 550;

        Browser.window.addEventListener("keyup", function (event) {
            pressedKeys[event.key] = false;
        });
        Browser.window.addEventListener("keydown", function (event) {
            pressedKeys[event.key] = true;
        });

        function controlCar(car: Car, up: String, left: String, down: String, right: String) {
            if (pressedKeys[up]) {
                if (pressedKeys[left]) {
                    car.forwardLeft();
                }
                else if (pressedKeys[right]) {
                    car.forwardRight();
                }
                else {
                    car.forward();
                }
            }
            if (pressedKeys[down]) {
                if (pressedKeys[left]) {
                    car.reverseLeft();
                }
                else if (pressedKeys[right]) {
                    car.reverseRight();
                }
                else {
                    car.reverse();
                }
            }
        }

        function gameLoop() {
            controlCar(car1, "ArrowUp", "ArrowLeft", "ArrowDown", "ArrowRight");
            controlCar(car2, "w", "a", "s", "d");
            context.clearRect(0, 0, canvas.width, canvas.height);
            car1.draw(context);
            car2.draw(context);
        }

        var timer = new haxe.Timer(30);
        timer.run = gameLoop;
    }
}
