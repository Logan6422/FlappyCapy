extends Area2D

signal hit  #senal

func _on_body_entered(body):
	hit.emit()   #emite la senal si el pajaro entra en el area 
