package pages;

import Router.State;
import Router.RouterPage;
import haxe.ui.components.Button;
import Meta.Meta;

@:build(haxe.ui.ComponentBuilder.build("assets/index.xml"))
class Index extends RouterPage
{
    public function new(s: State)
    {
        super(s);
        createChapters();
    }

    private function createChapters()
    {
        for (c in Meta.chapters)
        {
            var btn = new Button();
            btn.text = c.name;
            btn.onClick = _ -> openPlayer(c.slide);
            chapters.addComponent(btn);
        }
    }

    private function openPlayer(chapter: Int)
    {
        state.router.push(Player(chapter));
    }
    
}