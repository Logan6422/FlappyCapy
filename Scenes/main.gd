extends Node2D

@export var pipe_scene : PackedScene   #activa una casilla visual para insertar la pipe

var game_running : bool   #juego activo
var game_over : bool      #gameover
var scroll                #distancia de scrolleado
var score				  #almacena score
const SCROLL_SPEED : int = 4	#Velocidad a la que scrollea el piso y los pipes
var screen_size : Vector2i		#vector para guardar el tamanio de la pantalla
var ground_height : int			#int para guardar la altura del piso
var pipes : Array				#array de pipes
const PIPE_DELAY : int = 100	#delay entre generacion de pipes
const PIPE_RANGE : int = 200	#rango de altura de pipes


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size   #obtenemos el tamanio de la ventana
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()  #obtenemos el height del ground
	new_game()  #inicia un nuevo juego

func new_game():
	#Reset variables
	game_running = false
	game_over = false
	score = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	pipes.clear()
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free") #limpia los pipes anteriores (con group)
	scroll = 0
	$Bird.reset()
	generate_pipes()
	score = 0
	


func _input(event):    #manage imputs
	if game_over == false:  #si esta jugando
		if event is InputEventMouseButton: #y se presiona el click izq
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()   #si no se esta jugando arranca el juego
			else: 
				if $Bird.flying:  #sino si el pajaro esta volando flapea y se fija si no choca el techo
					$Bird.flap()
					check_top()

func start_game():
	game_running = true   #activa el juego
	$Bird.flying = true   #hace que el pajaro empiece a volar
	$Bird.flap()          #primer flap
	$PipeTimer.start()	  #activa el timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_running:
		scroll += SCROLL_SPEED   #mueve el juego
		if scroll >= screen_size.x-255:  #si el scroll llega al final reinicia para hacer infinito el mismo
			scroll = 0
		$Ground.position.x = -scroll    #vuelve el ground a su posicion inicial
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED		 #mueve los pipes para atras


func _on_pipe_timer_timeout():
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)

func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	$Bird.flying = false
	game_running = false
	game_over = true
	$GameOver.show()
	
func bird_hit():
	$Bird.falling = true
	stop_game()

func _on_ground_hit():
	$Bird.falling = false
	$Bird.set_rotation(PI)
	stop_game()


func _on_game_over_restart():
	new_game()
