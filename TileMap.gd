extends TileMap

const TILE_SIZE = 64

export(int) var width
export(int) var height

var playing = false

var temp_field


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var width_px = width * TILE_SIZE
	var height_px = height * TILE_SIZE
	
	var cam = $Camera2D
	
	cam.position = Vector2(width_px, height_px) / 2
	cam.zoom = Vector2(width_px, height_px) / (Vector2(960,540))
	
	temp_field = []
	for x in range(width):
		var temp = []
		for y in range(height):
			set_cell(x,y,0)
			temp.append(0)
		temp_field.append(temp)
		
func _input(event):
	if event.is_action_pressed("toggle_play"):
		playing = !playing
	if event.is_action_pressed("leftclick"):
		var pos = (get_local_mouse_position()/TILE_SIZE).floor()
		set_cellv(pos, 1-get_cellv(pos))
# Get slider placed appropriately. Turn off tile pressing outside. Attach slider to speed.

func _physics_process(delta):
	if Input.is_action_pressed("leftclick"):
		var pos = (get_local_mouse_position()/TILE_SIZE).floor()
		if pos.y <= 26 and pos.y >= 0 and pos.x <= 47 and pos.x >= 0:
			set_cellv(pos, 1)
	if Input.is_action_pressed("rightclick"):
		var pos = (get_local_mouse_position()/TILE_SIZE).floor()
		if pos.y <= 26 and pos.y >= 0 and pos.x <= 47 and pos.x >= 0:
			set_cellv(pos, 0)
"""
func update_field():
	if event.is_action_pressed("click"):

"""


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_speed():
	return $HSlider.value


func _on_FlashTimer_timeout():
	
	$FlashTimer.wait_time = $HSlider.value
	print($FlashTimer.wait_time)
	if !playing:
		return
	
	var total = 0
	for x in range(width):
		for y in range(height):
			var live_neighbors = 0
			for x_off in [-1, 0, 1]:
				for y_off in [-1, 0, 1]:
					if x_off != y_off or x_off != 0:
						if get_cell(x+x_off, y+y_off) == 1:
							live_neighbors += 1
							
			if get_cell(x,y) == 1:
				if live_neighbors in [2,3]:
					temp_field[x][y] = 1
					total += 1
				else:
					temp_field[x][y] = 0
			else:
				if live_neighbors == 3:
					temp_field[x][y] = 1
					total += 1
				else:
					temp_field[x][y] = 0
			
	for x in range(width):
		for y in range(height):
			set_cell(x, y, temp_field[x][y])
	$AudioStreamPlayer2D.pitch_scale = .1 + (float(total) / 91)
	$AudioStreamPlayer2D.play()
