extends CanvasLayer

signal restart  #senal

func _on_restart_button_pressed():
	restart.emit()  #emite la senal si el boton es presionado
