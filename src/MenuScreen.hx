import js.Browser;

class MenuScreen {
    var root = Browser.document.createDivElement();

    public function new() {
        Browser.document.body.appendChild(root);
        root.style.position = "absolute";
        root.style.width = "100vw";
        root.style.height = "100vh";
        root.style.backgroundColor = "#654321";
        root.style.display = "";
        

        var title = Browser.document.createDivElement();
        title.innerText = "BILSPILLET";
        title.style.textAlign = "center";
        title.style.fontSize = "64px";
        title.style.fontWeight = "bold";
        title.style.marginTop = "10vh";
        root.appendChild(title);

        addButton("Start spil", function(){
            if (root.style.display == "") {
                hide();
            }
        });
    }

    public function show() {
        root.style.display = "";
    }

    public function hide() {
        root.style.display = "none";
    }

    public function addButton(title: String, callback: Void->Void) {
        var button = Browser.document.createButtonElement();
        button.innerText = title;
        button.onclick = callback;
        button.style.padding = "4px";
        button.style.margin = "8px";
        button.style.backgroundColor = "#606665";
        root.appendChild(button);
    }
}