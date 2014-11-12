# cygame

cygame is a simple game engine using SFML via the cysfml project. It provides both Python and Cython interfaces to graphics, audio, window, system and network modules.

## About

cygame is built around the cysfml Cython bindings to CSFML. SFML is a 'small and fast multi-media library' which provides modules for graphics, audio, window, system and network functionality.

### Node

Nodes provide the following functionality:
 - drawing a list of Drawable objects
 - handling of events, e.g. keyboard and mouse input 
 - scheduling actions
 - tree structure containing child Nodes


### Graphics

Graphics are rendered by SFML using OpenGL. SFML provides support for drawing sprites, text, basic shapes (rectangles, circles and polygons), along with lower-level vertex arrays.

The easiest way to draw something is to add it to a Node's list of drawables.

```python
from cysml import graphics

rect = graphics.RectangleShape(10, 10, 20, 20)
node.drawables.append(rect)
scene.add(node)
```

Drawables can also be added by name for convenient access.

```python
# Add the rectangle to the Node's drawing loop.
node.named_drawables['My Rectangle'] = rect
# Get the rectangle.
print(node.named_drawables['My Rectangle'])
# Remove the rectangle from the Node's drawing loop.
del node.named_drawables['My Rectangle']
```

### Scheduling Actions

It is often useful to schedule actions to be performed on a regular basis, e.g. move a node every frame or regain one health point every second.

```python
class Asteroid(Node):
    def move_node(self, delta):
        # delta is the time in seconds since the last frame.
        self.move_xy(0, -10 * delta)

asteroid = Asteroid()

asteroid.schedule(asteroid.move_node)


class Ship(Node):
    def __init__(self):
        super().__init__()
        self.shield = 100
        
    def regain_shield(self):
        if self.shield < 100:
            self.shield += 1


ship = Ship()

ship.schedule_once(ship.regain_sheild, 1.5) # Call once after 1.5 seconds
ship.schedule_interval(ship.regain_sheild, 0.5) # Call every 0.5 seconds
```

### Node Tree Structure

Nodes are organised in a tree structure.

```python
parent_node = Node()
child_node = Node()

parent_node.add(child_node)
parent_node.remove(child_node)
```

Graphical transforms made to parent nodes, e.g. positioning or scaling, affects child nodes. This allows for the construction of complex layers, e.g. HUD, character, and background layers.

Events are forwarded to child nodes if the handle_key_events, handle_mouse_events or handle_joystick_events attributes are set to True.

child_node.handle_key_events = True # parent_node will not forward events.
parent_node.handle_key_events = True # Events will be forwarded to child_node.

This can be frustrating, but is intended as an optimisation to avoid unnecessary node tree traversals.

Input events can be handled by overriding event handler methods.

```python
class Player(Node):
    
    def __init__(self):
        super().__init__()
        self.handle_key_events = True
        
        self.move_left = False
        self.schedule(self.move_player)
    
    def on_key_event(self, key, ...):
        if key == 'Left':
            self.move_left = True
    
    def move_player(self, delta):
        if self.move_left:
            self.move_xy(-10 * delta, 0)
```

Overriding input event handlers is the most flexible way of handling input events. For simple cases such as the one above, the game engine offers a default implementation which avoids lengthy if statements.

```python
class Player(Node):
    
    def __init__(self):
        super().__init__()
        self.handle_key_events = True
        
        self.move_left = False
        self.attacking = False
        self.key_handlers['Left'] = self.left
        self.mouse_handlers['Left'] = self.attack
        self.schedule(self.move_player)
    
    def left(self, shift...): # *args is appropriate as the arguments are not used.
        self.move_left = True
    
    def attack(self, ...): # *args is appropriate as the arguments are not used.
        self.attacking = True
    
    def move_player(self, delta):
        if self.move_left:
            self.move_xy(-10 * delta, 0)
```

### Actions

Actions modify an object, typically drawable, over time, e.g. Action(duration, *args)

```python
cdef class Action():
    '''
    Action superclass.
    '''
    float duration
    drawable drawable
    def __cinit__(self, float duration):
        self.duration = duration
    
    cdef update(self)


cdef class MoveAction(duration, position):
    '''
    Move to a specific position.
    '''
    
    def __cinit__(self, 


cdef class ShiftAction(duration, shift):
    '''
    Shift by a number of pixels.
    '''
    pass
```


## TODO

 - Node in operator for children
 - actions
 - aligning nodes
 - tile maps
 - scene transitions

