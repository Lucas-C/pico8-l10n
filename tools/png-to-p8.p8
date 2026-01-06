pico-8 cartridge
version 43
__lua__
-- The .p8.png file must 1st be copied to ~/.lexaloffle/pico-8/carts/
function _init()
	p8_file = 'vampire_vs_pope_army'
	load(p8_file .. '.p8.png')
	save(p8_file)
end
-- Then the .p8 file must retrieved from ~/.lexaloffle/pico-8/carts/
