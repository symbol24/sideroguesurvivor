class_name WipeOverlay extends RidControl


@onready var _wipe: WipeTransition = $WipeTransition


func toggle_display(display:bool) -> void:
	if display:
		set_visible(true)
		_wipe.start()
	else:
		# Wipe OUT — slide out then hide
		await _wipe.start()
		set_visible(false)
