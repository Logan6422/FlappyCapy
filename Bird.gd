extends CharacterBody2D


const GRAVITY : int = 1000  #Gravedad para el pajaro
const MAX_VEL : int = 600	#Velocidad maxima del pajaro
const FLAP_SPEED : int = -500  #Velocidad del flap
var flying : bool = false      #booleano para saber si esta volando
var falling : bool = false	   #booleano para saber si esta cayendo
const START_POS = Vector2(100,400)  #Posicion inicial del pajaro

#Called when the node enters the scene tree for the first time.
func _ready():
	reset()    
	
func reset():
	falling = false   #resetea las variables del pajaro
	flying = false
	position = START_POS
	set_rotation(0)
	
	
#Called every frame. 'delta' is the elapsed time since the previous frame
func _physics_process(delta):
	if flying or falling:  							#Si cae o vuela
		move_and_collide(velocity * delta)			#mueve al pajaro
		velocity.y += GRAVITY * delta				#agrega gravedad
		#Terminal velocity							
		if velocity.y > MAX_VEL:					#limita la velocidad 
			velocity.y = MAX_VEL

		if flying:									#si esta volando (click)
			set_rotation(deg_to_rad(velocity.y * 0.05)) #rota la cara del pajaro
			$AnimatedSprite2D.play()					#reproduce animacion
		elif falling:									#si esta cayendo
			set_rotation(PI/2)							#rota para que mire el suelo
			$AnimatedSprite2D.stop()					#para la animacion

	else:	
		$AnimatedSprite2D.stop()					#si no vuela o cae para la animacion
			
func flap():		#agrega la velocidad en y para volar
	velocity.y = FLAP_SPEED
			
