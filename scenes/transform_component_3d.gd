extends Node
class_name TransformComponent3D
## Handles transforms for anything that needs to be visualized
##
## The TransformComponent can handle 3D transformations for any 3d object that has a "beat" parameter
## It handles regular Editor transformations and Game Emulation transformations (note jump, noodle, etc)
## If configured correctly, it can also handle lining up events with other events
