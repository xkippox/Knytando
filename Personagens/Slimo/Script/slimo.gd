# AJEITAR O SISTEMA DE KNOCKBAAAAAAAAAAAACKKKKKKKKKKKKKK


extends CharacterBody2D

# Exportando a variavel para ser mais facil de mexer.
@export var vida_max: int = 3	

# Referência ao sprite animado (pega automaticamente quando a cena inicia)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Lista contendo os 3 coracoes do player
@onready var hearts = [
	$CORACOES/CORACAO1,
	$CORACOES/CORACAO2,
	$CORACOES/CORACAO3
]

# Forca do knockback
const FORCA_KNOCKBACK_X = 250.0
const FORCA_KNOCKBACK_Y = -200.0
# Constantes de movimento (valores fixos)
const VELOCIDADE = 120.0
const VELOCIDADE_PULO = -200.0

# Criando uma variavel para a vida atual	
var vida: int

# Funcao que inicia assim que o jogo inicia
func _ready():
	vida = vida_max
	atualizar_coracoes()

# Funcao que, quando o player toma dano, é chamada
func tomar_dano(posicao_inimigo: Vector2):
	
	# Impede que a vida fique negativa
	if vida <= 0:
		return
	# Calcula a direcao do knockback
	var direcao = global_position - posicao_inimigo
	
	# Se o inimigo estiver a direita, empurra pra esquerda
	if direcao.x > 0:
		velocity.x = FORCA_KNOCKBACK_X
	elif direcao.x < 0:
		velocity.x = -FORCA_KNOCKBACK_X
	else: 
		velocity.x = FORCA_KNOCKBACK_X
		
	# Aplica um pequeno impulso para cima
	velocity.y = FORCA_KNOCKBACK_Y
	
	vida -= 1
	atualizar_coracoes()
	print("Vidas restantes: ", vida)
	
	# Se a vida for igual ou menor que zero, chama a funcao morrer
	if vida <= 0:
		morrer()

# Funcao que atualiza os coracoes conforme a vida atual
func atualizar_coracoes():
	for i in range(hearts.size()):
		# Se o indice for menor que a vida atual, o coracao fica visivel
		hearts[i].visible = i < vida

# Funcao morrer
func morrer():
	print("O player morreu!")
	get_tree().reload_current_scene()
	
func _physics_process(delta: float) -> void:
	
	# GRAVIDADE
	# Se não estiver no chão, aplica gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# PULO
	# Se apertar o botão de pulo e estiver no chão
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = VELOCIDADE_PULO

	# MOVIMENTO HORIZONTAL
	# Pega direção (-1 esquerda, 1 direita, 0 nada)
	var direction := Input.get_axis("esquerda", "direita")
	
	if direction:
		# Move para esquerda ou direita
		velocity.x = direction * VELOCIDADE
		
		# Ajusta a direção do sprite (flip horizontal)
		if direction > 0:
			animated_sprite_2d.flip_h = false
		elif direction < 0:
			animated_sprite_2d.flip_h = true
	else:
		# Se não estiver apertando nada, desacelera suavemente até parar
		velocity.x = move_toward(velocity.x, 0, VELOCIDADE)

	# MOVIMENTO FINAL
	# Aplica o movimento calculado
	move_and_slide()	
