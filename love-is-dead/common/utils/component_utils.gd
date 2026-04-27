class_name ComponentUtils


static func get_component(object: Variant, component_string_name: StringName) -> Variant:
	return object.get_meta(component_string_name, null)


static func has_component(object: Variant, component_string_name: StringName) -> bool:
	return object.has_meta(component_string_name)
