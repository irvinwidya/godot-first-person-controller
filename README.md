# First Person Controller

A template for first person POV system for character using Godot Engine 4

## Movement Control

`W A S D` : Forward, Left, Backward, Right

`Spacebar` : Jump

`Shift` : Sprint

`Ctrl` : Crouch

## Mechanism

- Character Movement Speed
    - Walking, sprinting, and crouching speed _(crouching takes prirority over sprinting)_
    - Gradual movement speed using `lerp()` function
        _(so it doesn't looks snappy/choppy)_
- Character Collision
    - Changes collision height when crouching
    - Stay crouching when object/collision detected above character's head using RayCast3D node
- Character Camera (Player's POV)
    - Camera rotation based on mouse movement
        - Y-axis rotation is set so camera can't rotate too much that can cause the world's view inverted (upside-down)
    - Camera height follows when character's crouching 
        _(also using `lerp()` to prevent snappy/choppy movement)_

Note: The jumping mechanism is already GDScript built-in