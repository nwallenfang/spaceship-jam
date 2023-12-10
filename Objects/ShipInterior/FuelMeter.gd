extends Node3D

var fuel_progress: float:
	set(x):
		fuel_progress = x
		$FuelMeter2/FuelMeter.get_surface_override_material(1).set("shader_parameter/progress", x)

var blink_amount: float:
	set(x):
		blink_amount = x
		$FuelMeter2/FuelMeter.get_surface_override_material(1).set("shader_parameter/blink_amount", x)
