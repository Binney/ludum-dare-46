extends ProgressBar

var happy_style = create_style(Color('#ffffff'))
var sad_style = create_style(Color('#ff0000'))

func create_style(color):
	var style = StyleBoxFlat.new()
	style.bg_color = color
	return style

func set_is_sad(sad):
	add_stylebox_override('fg', sad_style if sad else happy_style)
