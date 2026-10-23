extends Node


# Spawn Manager
signal spawn_one(data:CharacterData, is_left:bool)
signal remove_one(enemy:Enemy)
signal get_closest_to_shoot(player:PlayerCharacter, is_looking_left:bool)
signal closest_to_shoot(enemy:Enemy)

# UI
signal toggle_display(id:StringName, display:bool)
signal resource_1_updated(value:int)

# PLAYER
signal start_reload_timer(time:float)
signal reload_timer_complete
signal shots_fired(remaining:int)

# GAME
signal update_resource_1(value:int)
signal spawn_a_gribly(type:Griblies.Type, pos:Vector2, value:int)