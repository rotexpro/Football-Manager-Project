extends Area2D

var player = null

func _on_Detectplayer_body_entered(body):
	player = body

func _on_Detectplayer_body_exited(_body):
	player = null
