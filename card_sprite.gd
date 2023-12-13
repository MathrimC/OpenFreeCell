class_name CardSprite
extends Sprite2D

# enum to support different card sprites
enum Type { Solitaire }

func set_card_sprite(type: Type, suit: Card.Suit, rank: int):
	match type:
		Type.Solitaire:
			self.frame = (suit * 13) + (rank - 1)

			var scaling = get_parent().size.x / 100
			self.scale = Vector2(scaling, scaling)
		_:
			printerr("Unsupported card sprite type")


