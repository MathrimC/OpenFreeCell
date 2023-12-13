class_name PseudoRNG

var state: int

func set_seed(_seed: int):
	state = _seed

func get_number() -> int:
	state = (214013 * state + 2531011) % (pow(2,31) as int)
	return state / (pow(2,16) as int)
