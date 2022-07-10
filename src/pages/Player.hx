package pages;

import components.ChapterDrawer;
import lime.media.AudioBuffer;
import haxe.ui.events.UIEvent;
import openfl.events.Event;
import haxe.ui.events.DragEvent;
import openfl.media.SoundChannel;
import openfl.net.URLRequest;
import openfl.media.Sound;
import haxe.ui.events.MouseEvent;
import Router.State;
import Router.RouterPage;
import haxe.ui.components.Button;
import Meta.Meta;

private enum PlayerEvent
{
    Start(slide: Int);
    Play;
    Pause;
    Seek(pos: Float);
    Stop;
}

@:build(haxe.ui.ComponentBuilder.build("assets/player.xml"))
class Player extends RouterPage
{
    private var slide = new Observable(0);
    
    private var audio: Null<SoundChannel>;
    private var audioLength = 0.;
    private var isAudioPlaying = new Observable(false);
    private var isSeeking = false;
    private var autoplay = new Observable(true);
    
    private var chapterDrawer = new ChapterDrawer();

    public function new(s: State, slide: Int)
    {
        super(s);

        isAudioPlaying.addObserver(isPlaying -> playPauseBtn.text = isPlaying ? "pause" : "play");
        this.slide.addObserver(updateSlide);
        autoplay.addObserver(v -> autoBtn.selected = v);
        chapterDrawer.onSlideSelect = trySetSlide;
        addEventListener(Event.ENTER_FRAME, updateProgress);

        prevSlideBtn.onClick = _ -> skipBackSlide();
        nextSlideBtn.onClick = _ -> skipForwardSlide();
        prevChapterBtn.onClick = _ -> skipBackChapter();
        nextChapterBtn.onClick = _ -> skipForwardChapter();
        autoBtn.onClick = _ -> autoplay.value = !autoplay.value;

        this.slide.value = slide;
    }

    private function updateSlide(slide: Int)
    {

        trackLabel.text = '${Meta.chapters[getCurrentChapter()].name} - ${slide}';
        var c = Meta.slides[slide];
        this.background.resource = c.image;
        dispatchPlayerEvent(Start(slide));
    }

    private function updateProgress(_: Dynamic)
    {
        if (audio == null || !isAudioPlaying.value || isSeeking)
            return;
        var pos = audio.position;
        var progress = pos / audioLength * 100;
        progressBar.pos = progress;
    }

    private inline function trySetSlide(newSlide: Int)
    {
        if (Meta.slides.exists(newSlide))
            slide.value = newSlide;
    }

    private inline function getCurrentChapter()
    {
        var match = 0;
        for (i => v in Meta.chapters)
        {
            if (slide.value < v.slide)
                break;
            match = i;
        }
        return match;
    }

    private function skipBackSlide()
    {
        trySetSlide(slide.value - 1);
    }

    private function skipForwardSlide()
    {
        trySetSlide(slide.value + 1);
    }

    private function skipBackChapter()
    {
        var c = Meta.chapters[getCurrentChapter() - 1];
        trySetSlide(c != null ? c.slide : 0);
    }
    
    private function skipForwardChapter()
    {
        var c = Meta.chapters[getCurrentChapter() + 1];
        if (c != null)
            trySetSlide(c.slide);
    }
    
    @:bind(menuBtn, MouseEvent.CLICK)
    private function menuBtnClick(_: Dynamic)
    {
        state.router.pop();
    }

    @:bind(playPauseBtn, MouseEvent.CLICK)
    private function playPauseBtnClick(_: Dynamic)
    {
        dispatchPlayerEvent(isAudioPlaying.value ? Pause : Play);
    }

    @:bind(progressBar, DragEvent.DRAG_START)
    private function progressBarDragStart(_: Dynamic)
    {
        isSeeking = true;
    }

    @:bind(progressBar, UIEvent.CHANGE)
    private function progressBarChange(_: Dynamic)
    {
        var seekDuration = progressBar.pos / 100 * audioLength;
        progressBarLabel.text = '${Util.formatTime(seekDuration)}/${Util.formatTime(audioLength)}';
    }

    @:bind(progressBar, DragEvent.DRAG_END)
    private function progressBarDragEnd(_: Dynamic)
    {
        // audio does not end if pos set to audioLength
        var seekDuration = Math.min(progressBar.pos / 100 * audioLength, audioLength - 1);
        dispatchPlayerEvent(Seek(seekDuration));
        isSeeking = false;
    }

    @:bind(chapterDisplayBtn, MouseEvent.CLICK)
    private function toggleChapterDisplay(_: Dynamic)
    {
        chapterDrawer.show();
    }

    private function dispatchPlayerEvent(e: PlayerEvent)
    {
        switch (e)
        {
            case Start(c):
                if (audio != null)
                    audio.stop();
                var sound = new Sound();
                sound.addEventListener("complete", function(_) {
                    audio = sound.play();
                    audio.addEventListener(Event.SOUND_COMPLETE, _ -> dispatchPlayerEvent(Stop));
                    audioLength = sound.length;
                    isAudioPlaying.value = true;
                });
                sound.load(new URLRequest(Meta.slides[c].audio));
            case Play:
                @:privateAccess
                if (audio != null && audio.__source != null)
                {
                    @:privateAccess audio.__source.play();
                    isAudioPlaying.value = true;
                }
                else
                {
                    dispatchPlayerEvent(Start(slide.value));
                }
            case Pause:
                @:privateAccess
                if (audio != null && audio.__source != null)
                {
                    @:privateAccess audio.__source.pause();
                    isAudioPlaying.value = false;
                }
            case Seek(pos):
                @:privateAccess
                if (audio != null && audio.__source != null)
                {
                    // highly epic gangnam style
                    if (!isAudioPlaying.value)
                    {
                        @:privateAccess audio.__source.play();
                        audio.position = pos;
                        @:privateAccess audio.__source.pause();
                    }
                    else
                    {
                        audio.position = pos;
                    }
                }
            case Stop:
                if (audio != null)
                    audio.stop();
                isAudioPlaying.value = false;
                if (autoplay.value)
                    skipForwardSlide();
        };
    }

    public override function dispose()
    {
        if (audio != null)
            audio.stop();
        removeEventListener(Event.ENTER_FRAME, updateProgress);
    }
}