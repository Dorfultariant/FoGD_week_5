extends Node

var score_counter : int = 0
var score_file = "user://highscore.txt"

@onready var LBL_SCORE : Label = $UI/Score
@onready var LBL_HIGHSCORE : Label = $UI/HighScore

var start_time : int = Time.get_unix_time_from_system()

func update_score() -> void:
		LBL_SCORE.text = "Score: {0}".format([score_counter]) 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		update_score()
		var hs = load_highscore()
		LBL_HIGHSCORE.text = "Highscore: {0}".format([hs])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		
		if get_node_or_null("Player"):
			if $Player.global_position.y > -20:
					#score_counter += Time.get_ticks_msec()
					#score_counter /= 1000
					score_counter = (Time.get_unix_time_from_system() - start_time)
					update_score()
			else:
				$Player.queue_free()
				check_highscore()

func load_highscore():
		var fd = FileAccess.open(score_file, FileAccess.READ)
		if fd == null:
				write_highscore(0)
				return 0
		var d64 = fd.get_double()
		fd.close()
		return d64

func write_highscore(score) -> void:
		var fd = FileAccess.open(score_file, FileAccess.WRITE)
		fd.store_double(score)
		fd.close()

func check_highscore() -> void:
		var hs = load_highscore()
		if hs < score_counter:
				write_highscore(ceil(score_counter))
