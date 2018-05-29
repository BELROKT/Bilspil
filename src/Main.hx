import js.Browser;

class Main {
    static function main() {
        var menuScreen = new MenuScreen();
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
        Browser.window.addEventListener("keypress", function(event) {
            if (event.key == "Escape") {
                menuScreen.show();
            }
        });

        var game = new Game(canvas, context, pressedKeys);
        menuScreen.addButton("Map 1", function(){
            game.changeEnvironment(game.environments[0]);
            menuScreen.hide();
        });
        menuScreen.addButton("Map 2", function(){
            game.changeEnvironment(game.environments[1]);
            menuScreen.hide();
        });

        var timer = new haxe.Timer(30);
        timer.run = game.gameLoop;
    }
}
