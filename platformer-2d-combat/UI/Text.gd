extends Control

var dialog = [
	"Use [color=#20d6c7]AD to move, SPACE to jump, MOUSE to aim and CLKICK to attack. ESC to pause.[/color]",
	"I will be your mentor in this... let's call it experience.",
	"The [color=#20d6c7]blue squares[/color] in the top left are your health. [color=#20d6c7]Do not[/color] lose any of it, you will not be gifted with one of these anymore.",
	"Anyway, welcome to...",
	"Fire deals damage. To jump long distances use your attack! Just [color=#20d6c7]jump and click super fast[/color].",
	"Now be carefull with these guys, they're fast. [color=#20d6c7]You can only pass this level once you've killed all of them.[/color]",
	"I still haven't told you how you got here thought...",
	"There's no escape.",
	"But I think it's more important to tell why you're here.",
	"Why are you killing this guys, where are you going to...",
	"Fall. You can trust me.",
	"See? Now [color=#20d6c7]jump and attack tree times[/color].",
	"You are here so I... we can experiment something, that's going to help us understand more about [color=#20d6c7]consciousness and unconsciousness[/color].",
	"You will need to run, [color=#20d6c7]attack and jump at the same time[/color], since your jump height will be increased. Use your attack also to go to the platform once you've reached the height needed.",
	"Now I need to tell you where are we going to. We are going to see [color=#20d6c7]YOU[/color].",
	"To be more specific, [color=#20d6c7]the image that you have about yourself while in this simulation. Basically the only link between your real consciousness and this world[/color].",
	"We have never done anything like it before... you're the first one to [color=#20d6c7]meet your consciousness in a non conscious world[/color].",
	"To be fair, this is not a simulated world. At least no by me. [color=#20d6c7]We are in the surface of your unconsciousness[/color], where I still have some controll of. But we are descending.",
	"This is it. I have no controll anymore. [color=#20d6c7]If you lose all your health, I can only bring you back to here[/color].",
	"You must be thinking: 'If this is my generated world, why does this obstacles and red guys are here? Why do I have to pass all this?'",
	"The answer is simple: Autodefense. As we get closer to YOU, [color=#20d6c7]the image that your unconsious have of your consciousness[/color], your mind will try to avoid it, difficulting this 'levels'.",
	"I'm sorry, I have no controll of here now, I can't help you with these jumps. This part of your mind is unstable.",
	"We're so close",
	"Ok, now I get why the previous level was easy... your unconscious was preparing this... An advice: remember the attacks of these jumps.",
	"Wow, I think the other [color=#20d6c7]YOU[/color] really lost it. Or maybe he's out of creativity... it's right after... that mess.",
	"[color=#20d6c7]We're here[/color]. I can't believe it.",
	"So... this is what I need you to do: To test my hypothesis, [color=#20d6c7]you need to kill yourself[/color].",
	"Let me explain. I want to know what can happend when you [color=#20d6c7]kill the representation of your conscience in a non conscious world[/color].",
	"We've got so far... there's no turning back now. [color=#20d6c7]I can't get you out of here anymore... This is the only choice you have[/color].",
	"[color=#20d6c7]Kill your consciousness.[/color]",
	"It's right [color=#20d6c7]there[/color].",
	"[color=red]DO IT[/color]",
	"Yeah. It's done. My theory was right in the end.",
	"Want to know what was it?",
	"I don't think you're going to like it thought...",
	"When you killed your consciousness you [color=#20d6c7]trapped yourself[/color] in this non existent world.",
	"So yeah. You're [color=#20d6c7]not coming back ever again.[/color]",
	"I'm sorry that I had to do this.",
	"But sorry is not enought, since you have [color=#20d6c7]an eternity of void, just with your thoughts and nothing more.[/color]",
	"[color=#20d6c7]No feeling, no hunger, no loving, no hearing, nothing... Just a non world with thoughts.[/color]",
	"Is it like dying? I dont't know yet. [color=#20d6c7]Maybe will do another experiment testing this as well.[/color]",
	"Not with you. Of course. You are going to be here. [color=#20d6c7]Alone.[/color]",
	"Bye, I have to go. If this makes you feel any better: Thank you for helping me, science thanks you as well.",
	""
	]
var page = 0

onready var text = $TextLabel
onready var timer = $Timer
onready var clear = $Clear
onready var typing = $Typing

func _ready():
	pass

func display_text(pg):
	typing.play()
	page = pg
	text.set_bbcode("[center]%s[/center]"%dialog[page])
	text.set_visible_characters(0)
	timer.start()
	clear.stop()
	
func _on_Timer_timeout():
	var visible_characters = text.get_visible_characters()
	if visible_characters == len(dialog[page]) - 1:
		typing.stop()
		timer.stop()
		clear.start(text.get_total_character_count()/9.0)
		
	text.set_visible_characters(visible_characters + 1)

func _on_Clear_timeout():
	text.clear()
