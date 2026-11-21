class_name BulletIcon extends Control


@onready var inner:TextureRect = %inner


func toggle(value := true) -> void:
	if value: inner.show()
	else: inner.hide()