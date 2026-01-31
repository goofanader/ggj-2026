extends Object
class_name Utilities

static func replace_animated_sprite_image(sprite:AnimatedSprite2D,image_file:String) -> void:
	var sf_old: SpriteFrames = sprite.sprite_frames
	var sf_new: SpriteFrames = SpriteFrames.new()
	var image: Texture2D = load(image_file)
	for anime_name:String in sf_old.get_animation_names():
		sf_new.add_animation(anime_name)
		for frame_ind:int in sf_old.get_frame_count(anime_name):
			var texture_old: Texture2D = sf_old.get_frame_texture(anime_name,frame_ind)
			var texture_new: Texture2D = texture_old.duplicate()
			texture_new.atlas = image
			sf_new.set_frame(anime_name,frame_ind,texture_new,sf_old.get_frame_duration(anime_name,frame_ind))
	sprite.sprite_frames = sf_new
