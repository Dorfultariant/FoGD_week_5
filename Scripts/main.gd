extends Node


var score_counter : int = 0
var score_file = "user://highscore.txt"

@onready var LBL_SCORE : Label = $UI/Score
@onready var LBL_HIGHSCORE : Label = $UI/HighScore

var start_time : int = Time.get_unix_time_from_system()

func update_score() -> void:
	LBL_SCORE.text = "Score: {0}".format([score_counter]) # Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score()
	var hs = load_highscore()
	LBL_HIGHSCORE.text = "Highscore: {0}".format([hs])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Player.global_position.y > -20:
		score_counter = int((Time.get_unix_time_from_system() - start_time))
		update_score()
	else:
		check_highscore()

func load_highscore() -> int:
	var fd = FileAccess.open(score_file, FileAccess.READ)
	if fd == null:
		write_highscore(0)
		return 0
	var c64 = fd.get_64()
	fd.close()
	return c64

func write_highscore(score: int) -> void:
	var fd = FileAccess.open(score_file, FileAccess.WRITE)
	fd.store_64(score)
	fd.close()

func check_highscore() -> void:
	var hs = load_highscore()
	if hs < score_counter:
		write_highscore(score_counter)
