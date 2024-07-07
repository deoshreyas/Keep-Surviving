extends Node2D

func play_sound(sound):
	match sound:
		"coin": $Coin.play()
		"levelup": $Levelup.play()
