extends Control


const DEFAULT_COLORSETS: Dictionary = {
	"FireRed":  {
		"top_color": "831c08",
		"middle_color": "5cb1a4",
		"bottom_color": "831c08"
	},
	"LeafGreen":  {
		"top_color": "317813",
		"middle_color": "dc7f5c",
		"bottom_color": "317813"
	},
}

var tween: Tween
var can_press_start: bool = false

@onready var sprites: Node2D = $Sprites
@onready var top_color_rect: ColorRect = $TopColorRect
@onready var middle_color_rect: ColorRect = $MiddleColorRect
@onready var bottom_color_rect: ColorRect = $BottomColorRect


func _ready() -> void:
	set_version_theme(Global.version_name)
	default_state()
	startup_animation.call_deferred()


func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_TAB):
		startup_animation()
	if Input.is_action_just_pressed("ui_accept") and can_press_start:
		can_press_start = false
		get_tree().change_scene_to_file("res://source/maps/overworld/overworld.tscn")


func default_state() -> void:
	sprites.hide()
	can_press_start = false
	top_color_rect.position.x += top_color_rect.size.x
	middle_color_rect.position.x -= middle_color_rect.size.x
	bottom_color_rect.position.x -= bottom_color_rect.size.x


func startup_animation() -> void:
	if tween:
		tween.kill()
		default_state()
	tween = create_tween()

	tween.tween_callback($AudioStreamPlayer.play.bind(0.0))

	tween.tween_property(middle_color_rect, "position:x",
		middle_color_rect.size.x, 0.15).from(-middle_color_rect.size.x).as_relative().set_delay(4.1)

	tween.tween_property(top_color_rect, "position:x",
		-top_color_rect.size.x, 0.15).from(top_color_rect.size.x).as_relative()

	tween.tween_property(bottom_color_rect, "position:x",
		-bottom_color_rect.size.x, 0.15).from(bottom_color_rect.size.x).as_relative()

	tween.tween_callback(sprites.show)
	tween.tween_property(sprites,
		"material:shader_parameter/flash_value", 0.0, 0.25).from(1.0)
	
	await tween.finished
	can_press_start = true
	
	tween = create_tween()
	tween.set_loops()
	tween.tween_callback($PressStart.show).set_delay(0.6)
	tween.tween_callback($PressStart.hide).set_delay(0.6)


func set_version_theme(version: String) -> void:
	if Global.version_config:
		top_color_rect.color = Global.version_config.get_value("TitleScreen", "top_color", top_color_rect.color)
		middle_color_rect.color = Global.version_config.get_value("TitleScreen", "middle_color", middle_color_rect.color)
		bottom_color_rect.color = Global.version_config.get_value("TitleScreen", "bottom_color", bottom_color_rect.color)
		if ResourceLoader.exists(Global.version_config.get_value("TitleScreen", "pokemon_art")):
			$Sprites/PokemonArt.texture = load(Global.version_config.get_value("TitleScreen", "pokemon_art"))
		if ResourceLoader.exists(Global.version_config.get_value("TitleScreen", "version_logo")):
			$Sprites/VersionTitleLogo.texture = load(Global.version_config.get_value("TitleScreen", "version_logo"))
	elif DEFAULT_COLORSETS.has(version):
		top_color_rect.color = Color(DEFAULT_COLORSETS[version].top_color)
		middle_color_rect.color = Color(DEFAULT_COLORSETS[version].middle_color)
		bottom_color_rect.color = Color(DEFAULT_COLORSETS[version].bottom_color)
