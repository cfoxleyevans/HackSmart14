module Helpers


	def self.shorten_description(string)
		string[25..string.length] if string[0..24] === 'Journey Time Section for '
	end
end
