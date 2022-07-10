package ;

import haxe.ui.Toolkit;
import Router.Router;
import haxe.ui.HaxeUIApp;

class Main {
    public static function main() {
        Toolkit.theme = "dark";

        var app = new HaxeUIApp();
        var router = new Router(app);

        app.ready(function() {
            router.init();
            app.start();
        });
    }
}
