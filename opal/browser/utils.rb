class String
	def encode_uri_component
		`encodeURIComponent(#{self})`
	end

	def encode_uri
		`encodeURI(#{self})`
	end

	def decode_uri_component
		`decodeURIComponent(#{self})`
	end

	def decode_uri
		`decodeURI(#{self})`
	end
end
