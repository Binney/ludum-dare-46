extends Area2D

signal cancel

var currentMouse = null

const ActionButton = preload('res://ActionButton.gd')
const Mousician = preload('res://Mousician.gd')

func _input(event):
	if (event is InputEventScreenTouch):
		var space_state = get_world_2d().direct_space_state
		var hits = space_state.intersect_point(
			event.get_position(), 32, [ ], 2147483647, false, true)
		
		var hit_button = false
		for hit in hits:
			if (hit.collider is ActionButton && currentMouse != null):
				currentMouse.handleAction(hit.collider.action)
				self.visible = false
		
		if !hit_button && event.is_pressed():
			var opened_menu = false
			for hit in hits:
				if (hit.collider is Mousician && hit.collider != currentMouse && !hit.collider.is_always_happy):
					self.position = event.get_position()
					$Sharpen.visible = !hit.collider.is_percussion
					$Flatten.visible = !hit.collider.is_percussion
					currentMouse = hit.collider
					self.visible = true
					opened_menu = true
					
			if (!opened_menu):
				self.visible = false
				currentMouse = null

func _input_event(viewport, event, shape_idx):
	if (event is InputEventScreenTouch && event.is_pressed()):
		emit_signal("cancel")
			
