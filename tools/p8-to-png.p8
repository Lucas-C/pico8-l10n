pico-8 cartridge
version 43
__lua__
function _init()
	p8_file = 'vampire_vs_pope_army-fr-FR'
	load(p8_file .. '.p8')
	export(p8_file .. '.p8.png')
end
-- Then the .p8.png file must retrieved from ~/.lexaloffle/pico-8/carts/
