extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# --- NAO E NESCESSARIO ESSAS FUNCOES POR AGORA
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

# Funcao chamada quando algum corpo entra na area
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("tomar_dano"):
		body.tomar_dano(global_position)
