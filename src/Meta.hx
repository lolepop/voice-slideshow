package;

import haxe.io.Path;
import encoding.SJIS;
import sys.FileSystem;
import sys.io.File;

using StringTools;

private typedef Chapter = { name: String, slide: Int };
private typedef Slide = { image: String, audio: String };

class Meta
{
    public static final chapterPath = "./chapter.dat";
    public static final titlePath = "./title.dat";
    public static final imageDir = "./image";
    public static final audioDir = "./sound";

    private static var _chapters: Null<Array<Chapter>>;
    public static var chapters(get, null): Array<Chapter>;

    private static var _slides: Null<Map<Int, Slide>>;
    public static var slides(get, null): Map<Int, Slide>;
    private static var _slidesLen: Int = 0;
    public static var slidesLen(get, null): Int;
    
    private static function get_chapters()
    {
        if (_chapters == null)
        {
            _chapters = loadFile(chapterPath)
                .split("\n")
                .map(function(s) {
                    var r = s.split(",").map(a -> a.trim());
                    return { slide: Std.parseInt(r[0]), name: r[1] }
                });
        }
        return _chapters;
    }

    private static function get_slides()
    {
        if (_slides == null)
        {
            var images = FileSystem.readDirectory(imageDir)
                .map(p -> 'file://${Path.join([imageDir, p])}');
            var audio = FileSystem.readDirectory(audioDir)
                .map(p -> Path.join([audioDir, p]));

            _slidesLen = images.length;
            _slides = [for (i => v in images) i => { image: v, audio: audio[i] }];
        }
        return _slides;
    }

    private static function get_slidesLen()
    {
        get_slides();
        return _slidesLen;
    }

    private static function loadFile(path: String): String
    {
        var bytes = File.getBytes(path);
        return switch (SJIS.decode(bytes))
        {
            case Right(v): v;
            case _: bytes.toString();
        }
    }

}