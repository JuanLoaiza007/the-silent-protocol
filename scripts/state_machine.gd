class_name StateMachine
extends Node

enum State {IDLE, WALKING, RUNNING, JUMPING, FALLING}
var current_state: State = State.IDLE

func update_state(is_on_floor: bool, velocity_y: float, has_direction: bool, is_running: bool) -> void:
    if not is_on_floor:
        if velocity_y > 0:
            current_state = State.JUMPING
        else:
            current_state = State.FALLING
    else:
        if has_direction:
            if is_running:
                current_state = State.RUNNING
            else:
                current_state = State.WALKING
        else:
            current_state = State.IDLE

func get_state() -> State:
    return current_state

func get_state_name() -> String:
    return State.keys()[current_state]