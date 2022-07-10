package components;

import haxe.ui.containers.SideBar;

using StringTools;

@:build(haxe.ui.ComponentBuilder.build("assets/components/chapter-drawer.xml"))
class ChapterDrawer extends SideBar
{
    public var onSlideSelect: Int -> Void = _ -> {};

    public function new()
    {
        super();
        buildChapterTree();
    }

    private function buildChapterTree()
    {
        var slideRanges = Meta.chapters.map(c -> c.slide).slice(1);
        slideRanges.push(Meta.slidesLen);
        // var slidePaddingLen = Math.floor(Math.log(Meta.slidesLen)/Math.log(10)) + 1;
        for (i => c in Meta.chapters)
        {
            var parent = tree.addNode({ text: c.name, value: c.slide });
            parent.onDblClick = _ -> onSlideSelect(tree.selectedNode.data.value);
            for (v in c.slide...slideRanges[i])
                parent.addNode({ text: Std.string(v), value: v });
                // parent.addNode({ text: Std.string(v).lpad("0", slidePaddingLen) });
        }
    }
}