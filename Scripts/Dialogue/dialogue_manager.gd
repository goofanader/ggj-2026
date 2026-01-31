extends Node

signal line(step)
signal choice(step)

var data := []
var i := 0

func start(d):
	data = d
	i = 0
	_play()
	
func _play():
	if i >= data.size():
		return

	var next = data[i]
	
	if next.has("talking"):
		line.emit(next)
	elif next.has("choice"):
		choice.emit(next)

func next():
	i+=1
	_play()
	
func choices(i: int) -> void:
	return
