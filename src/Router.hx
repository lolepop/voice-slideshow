package;

import haxe.ui.containers.Box;
import pages.Index;
import pages.Player;
import haxe.ds.GenericStack;
import haxe.ui.HaxeUIApp;

enum Page
{
    Root;
    Player(chapter: Int);
}

typedef State = {
    router: Router
};

class Router
{
    var app: HaxeUIApp;
    var length: Int;
    var pages = new GenericStack<RouterPage>();
    var state: State;

    public function init()
    {
        push(Page.Root);
    }

    public function push(p: Page)
    {
        var c: RouterPage = switch (p) {
            case Root: new Index(state);
            case Player(chapter): new Player(state, chapter);
        };
        app.addComponent(c);
        pages.add(c);
        length++;
    }

    public function pop()
    {
        if (length > 1)
        {
            var p = pages.pop();
            p.dispose();
            app.removeComponent(p);
            app.addComponent(pages.first());
        }
    }

    public function new(app: HaxeUIApp)
    {
        this.app = app;
        state = {
            router: this
        };
    }
}

class RouterPage extends Box
{
    var state: State;

    public function new(state: State)
    {
        super();
        this.state = state;
    }

    public function dispose() { }
}