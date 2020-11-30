class_name Utils


static func truncate_and_free(array: Array, size: int) -> void:
	assert(array.size() >= size, "Specified size of the array should be bigger or equal than truncation size")
	for _index in range(size, array.size()):
		array.pop_back().free()


static func accumulate_property(objects: Array, property: String) -> int:
	var property_value: int = 0
	for object in objects:
		property_value += object.get(property)
	return property_value


static func accumulate_function(objects: Array, function: String) -> int:
	var property_value: int = 0
	for object in objects:
		property_value += object.call(function)
	return property_value
