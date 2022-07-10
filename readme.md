# Voice Slideshow

haxeui + openfl slideshow player

## Directory Structure:
```
/
├─ image/
│  ├─ 000.png
├─ sound/
│  ├─ 000.wav
├─ chapter.dat
```

image/sound files do not need to have zero padding but must be numeric and be in order

### chapter.dat
csv file with format: `chapter name, slide number`

### image
lime native target supports [png and jpeg](https://github.com/openfl/lime/blob/81d682d355dfeaeb74c40d907283a1c7d7e66258/project/src/ExternalInterface.cpp#L1794)

### sound
lime native target supports [wav and ogg (vorbis only)](https://github.com/openfl/lime/blob/81d682d355dfeaeb74c40d907283a1c7d7e66258/project/src/ExternalInterface.cpp#L290)

