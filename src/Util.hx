package;

using StringTools;

class Util
{
    private static inline var SECONDS = 1000;
    private static inline var MINUTES = SECONDS * 60;
    private static inline var HOURS = MINUTES * 60;

    // time in ms
    public static function formatTime(time: Float)
    {
        var hours = Math.floor(time / HOURS);
        time = time % HOURS;
        var minutes = Math.floor(time / MINUTES);
        time = time % MINUTES;
        var seconds = Math.floor(time / SECONDS);

        var buf = new StringBuf();
        if (hours > 0)
            buf.add('${timePad(hours)}:');
        buf.add('${timePad(minutes)}:');
        buf.add('${timePad(seconds)}');
        
        return buf.toString();
    }

    private static inline function timePad(i: Int): String
    {
        return Std.string(i).lpad("0", 2);
    }
}