extends Node


# Spawn Manager
signal spawn_one(data:CharacterData, is_left:bool)
signal spawn_character(player_character_data: PlayerCharacterData, pos:Vector2)
signal remove_one(enemy:Enemy)
signal get_closest_to_shoot(player:PlayerCharacter, is_looking_left:bool)
signal closest_to_shoot(enemy:Enemy)

# UI
signal toggle_display(id:StringName, display:bool)
signal resource_1_updated(value:int)
signal show_upgrade_tooltip(upgrade_data:UpgradeGroup, position:Vector2, btn_size:Vector2)
signal hide_upgrade_tooltip
signal unlock_upgrade_group_in_ui(upgrade_group: UpgradeGroup)

# PLAYER
signal player_ready(player:PlayerCharacter)
signal start_reload_timer(time:float)
signal reload_timer_complete
signal shots_fired(remaining:int)

# GAME
signal update_resource_1(value:int)
signal spawn_a_gribly(type:Griblies.Type, pos:Vector2, value:int)
signal toggle_active(value:bool)
signal start_round()
signal round_timer_updated(value:int)
signal round_number_updated(value:int)

# UPGRADES
signal new_upgrade(new_upgrade:Upgrade, type:UpgradeGroup.Type)
signal attempt_purchase(group: UpgradeGroup)
signal upgrade_purchased(group:UpgradeGroup)
signal upgrade_group_updated(upgrade_group: UpgradeGroup)

# SAVE / LOAD
signal create_debug_data
signal request_save
signal request_load(id: int)
signal save_complete
signal load_complete(data: SaveData)