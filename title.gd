extends Node2D

signal play


func _on_play_button_pressed():
	play.emit()
