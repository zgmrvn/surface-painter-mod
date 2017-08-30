# Surface Painter

Surface Painter is a simple toolbox to help map makers in specific tasks. It's not meant to cover all your needs, the mod currently has very few features but it's open source and meant to be modular, allowing you to create your own modules using the interface, controls and other features like the Object Pool.

# Features
 
## Surface Painter
This tool lets you tweak the surface map directly in Arma using a dll that replicates your actions in a bitmap file.
Copy the corresponding dlls and your surface.bmp in your Arma installation directory.
Run Arma with Battleye disabled. Take manual backups of your surface map.
 
## Object Pool
It lets you define objects that will be used by modules. You can search objects by name and set the spawn probability for each one.
 
## Brush
A simple brush tool for random object placement.
 
## Edge
Draw lines and create objects along them, can be set to detect terrain and follow it.

# Install

1. Download the latest version here : https://github.com/zgmrvn/surface-painter-mod/releases

2. Extract the archive

3. Copy the `@surface_painter` directory where you store your mods

You can skip the steps 4 and 5 if you don't plan to use the Surface Painter tool, the tool that lets you paint your surface map directly in Arma.

4. Copy the corresponding dlls in your Arma 3 directory :

32 bits :
```
\Arma 3\corp_tls.dll
\Arma 3\libgcc_s_dw2-1.dll
\Arma 3\libstdc++-6.dll
\Arma 3\libwinpthread-1.dll
```
64 bits :
```
\Arma 3\corp_tls_x64.dll
\Arma 3\libgcc_s_seh-1.dll
\Arma 3\libstdc++-6.dll
\Arma 3\libwinpthread-1.dll
```

# How to use

In the editor, place a unit and run the mission. In the action menu you should see an action named "Surface Painter".

basically :
- `WASD` to translate the camera
- `right click` to turn the camera
- `Shit + WASD` camera speed x10
- `Shit + Alt + WASD` camera speed x100
- `Alt + click` to use the alternative function of the current tool (eg. erasing with brush tool)
- `mouse wheel` to set the size of the cursor
- `Shift + mouse wheel` to set the size of the cursor x10
- fields can be incremented/decremented with `mouse wheel`

## Object Pool
The panel on the right. Search for an object in the top field. `double click` on an item to add it to the pool. Use your `mouse wheel` to change the spawn probability of each object.
