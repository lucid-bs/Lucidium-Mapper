class_name DifficultyThingy
extends Panel

## Yup, that's its official name now.
## I can't be bothered to come up with an original, sensible one so it's staying like this
## You're welcome to make a PR if it bothers you that much
## And I will be welcome to deny said pr at my discretion :P

signal copy_status_changed(copying: bool)


@export var copy_pending : bool = false:
	set(value):
		copy_pending = value
		copy_status_changed.emit(copy_pending)
		
