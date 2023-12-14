extends CharacterBody3D

# Variaveis
var gravidade = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocidade = 0
var sensibilidadeMouse = 0.002
var somPasso = preload("res://data/sounds/step.mp3")
var timer = 60

# Quando comecar travar o mouse
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Mexer nas fisicas
func _physics_process(delta):
	
	# Gravidade
	velocity.y += -gravidade * delta
	
	# Variaveis de input e direcao de movimento
	var input = Input.get_vector("esquerda", "direita", "frente", "tras")
	var moverDirecao = transform.basis * Vector3(input.x, 0, input.y)
	
	# Aumentar velocidade e tocar som de passo
	if Input.is_action_pressed("frente") or Input.is_action_pressed("tras") or Input.is_action_pressed("esquerda") or Input.is_action_pressed("direita"):
		if !$Step.is_playing() and timer == 0 and !velocidade == 0:
			timer = 60
			$Step.stream = somPasso
			$Step.play()
		else:
			timer -= 1
			
		if velocidade < 3:
			velocidade += 0.1
	
	# Abaixar velocidade
	if moverDirecao == Vector3(0, 0, 0):
		timer = 60
		velocidade = 0
		
	# Mover jogador
	velocity.x = moverDirecao.x * velocidade
	velocity.z = moverDirecao.z * velocidade
	
	# Realizar todos os procedimentos
	move_and_slide()

# Verificar inputs
func _input(event):
	
	# rodar o jogador com o mouse se o mesmo estiver capturado
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * sensibilidadeMouse)
		$Shape/Camera.rotate_x(-event.relative.y * sensibilidadeMouse)
		$Shape/Camera.rotation.x = clampf($Shape/Camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
