class_name UpgradePopup extends PanelContainer


@onready var description: Label = %description
@onready var display_name: Label = %name

func set_text(upgrade_group: UpgradeGroup) -> void:
	display_name.text = upgrade_group.display_name
	description.text = upgrade_group.description