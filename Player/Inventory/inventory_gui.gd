extends Control

var isOpen: bool = false

signal opened
signal closed

func open():
	visible = true
	isOpen = true
	opened.emit()

func close():
	visible = false
	isOpen = false
	closed.emit()
