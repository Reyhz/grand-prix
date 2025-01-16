extends Node2D

var straightCount = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	%Track/TrackPos.global_position = $Back.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position.y = %PlayerCar.global_position.y
	if %Track/TrackPos.global_position.y > $Front.global_position.y:
		if straightCount > 10 && randi_range(1,25) == 1:
			place_track(%Station)
			straightCount = 0
		else: 
			place_track(%Road)
			straightCount += 1


# Duplicating Road nodes Object Pooling might be better on the future
func place_track(track):	
	var placedTrack = track.duplicate()
	%Track.add_child(placedTrack)
	placedTrack.position = %Track/TrackPos.global_position
	
	%Track/TrackPos.global_position.y -= (track.texture.get_height()) * track.scale.y
	
	#print_debug("FRONT : " + str($Front.global_position) + " BACK : " + str($Back.global_position) + " TRACK POS : " + str(%Track/TrackPos.global_position))


# TODO : Initializing default start to then use object pooling. Fow now I will dup sprites
func default_track():
	pass
