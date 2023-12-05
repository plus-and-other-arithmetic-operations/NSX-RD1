# NSX-RD1

Commission for ASC's Demo NSX

https://github.com/plus-and-other-arithmetic-operations/NSX-RD1/assets/88043761/33809eb3-0851-48b0-999b-0c8d218d0397

Some features:
- Boot-up screen
- Several toggleable menus in the display
- Odometer
- Fuel amount
- Oil temp
- Oil pressure
- Water temp
- Boost pressure

## Setup

Install the required fonts

Add the script entry into the car's ext_config

```ini
;EXTRA D - Enter select mode (stays blinking for 5 seconds, after then locks selection)
;EXTRA C - Select specific screen (will toggle between the blinking screen selected with EXTRA D)
[SCRIPTABLE_DISPLAY_...]
ACTIVE= 1
MESHES = INT_RD1_SCREEN
RESOLUTION = 1024,1024
DISPLAY_POS = 0,0
DISPLAY_SIZE = 1024,1024
SKIP_FRAMES = 0
SCRIPT = rd1.lua
```
