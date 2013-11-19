# Word search in grid of letters
# @author: Josef Harte
# A user-defined grid can be used (follow the prompt). This should be a plaintext file that has
# each row in the grid as a row of letters in the text file, no spaces!
# A random grid will be generated otherwise

puts "Welcome to Wordsearch!\nPress 'r' to use a random grid, 'o' to use your own:"
type = gets.chomp
grid = []
if type == "r" then
	# Create the random square grid with size given on command line
	puts "Enter the size of the NxN grid:"
	size = gets.chomp.to_i
	if (size == 0) || (size < 0) then abort("Error: size of grid must be a positive integer") end
	grid = Array.new(size) { Array.new(size) }
	
	# Populate grid randomly with letters from A to Z
	charAry = ("A".."Z").to_a
	grid = grid.collect do |row|
		row.collect do |col|
			col = charAry.sample
		end
	end
elsif type == "o" then
	# Load the user-defined grid from text file
	puts "Enter the path to your own grid file:"
	begin
		userGrid = File.open( gets.chomp, "r")
	rescue Errno::ENOENT
		abort("Error: cannot find the grid file")
	else
		userGrid.each_line { |line| grid << line.split(//) }
		userGrid.close
	end
else
	abort("Error: invalid option")
end	

# Pull the relevant words from dictionary file into array, ignoring definitions etc.
# Script looks in current dir for "dict.txt" - if not found it checks if
# a file was passed as arg on command line
dict = []
begin
	dictFile = File.open("dict.txt", "r").each_line do |line|
		dict << line.split(/\s/)[0]
	end
rescue Errno::ENOENT
	if ARGV[0] == nil then # No dictionary file given on command line either
		abort("Error: cannot find dictionary file")
	else 
		begin
			dictFile = File.open(ARGV[0], "r")
		rescue Errno::ENOENT
			abort("Error: cannot find dictionary file passed as argument")
		else
			dictFile.each_line { |line| dict << line.split(/\s/)[0] }
			dictFile.close
		end
	end	
end

# Function that finds words horizontally by going thru each row, left to right
def findWords( letterGrid, wordList, direction )
	word = ""
	letterGrid.each do |row|
		row.each do |col|
			word << col
			if (word.length >= 2) then
				wordList.each { |dictWord| if word === dictWord then puts direction + ": " + word end }
			end
		end
		word = "" # Reset to empty string for each row
	end
end

puts "Looking in the grid for words..."

# Look left to right in original grid
findWords( grid, dict, "Left to Right" )

# Look in the grid with reversed rows - equivalent to going right to left in "grid"
gridRev = grid.collect { |row| row.reverse }
findWords( gridRev, dict, "Right to Left" )

# Look in the transposed grid - equivalent to looking top to bottom in "grid"
gridTrans = grid.transpose
findWords( gridTrans, dict, "Top to Bottom" )

# Look in the transposed and reversed grid - equivalent to looking bottom to top in "grid"
gridTransRev = grid.transpose.collect { |row| row.reverse }
findWords( gridTransRev, dict, "Bottom to Top" )

# Function that finds words on the diagonals
def findWordsDiag( letterGrid, wordList, direction )
	# Start on main diagonal and work on diagonals to the right
	( letterGrid[0].size - 1 ).times do |offset|
		word = ""
		letterGrid.each_with_index do |row, i|
			if row[ i + offset ] != nil then
				word << row[ i + offset ]
				if (word.length >= 2) then
					wordList.each { |dictWord| if word === dictWord then puts direction + ": " + word end }
				end
			end
		end
	end
	
	# Transpose the grid and work to the right again
	# Equivalent to looking at diagonals to the left of the main diagonal
	( letterGrid[0].size - 1 ).times do |offset|
		word = ""
		letterGrid.transpose.each_with_index do |row, i| # Should not transpose on each iteration!!!
			if (i == 0) && (offset == 0 ) then	# Should only test for offset==0!!!
				next # ignore the main diagonal, already searched it!
			else
				if row[ i + offset ] != nil then
					word << row[ i + offset ]
					if (word.length >= 2) then
						wordList.each { |dictWord| if word === dictWord then puts direction + ": " + word end }
					end
				end
			end
		end	
	end		
end

# I took it that a diagonal runs left to right if it starts in top left corner, finished in bottom right
# Going thru it in reverse is going from bottom right to top left
# Left to right diagonals go from top right to bottom left...

# Find words on diagonals, left to right
findWordsDiag( grid, dict, "Left to Right Diagonals")

# Find words on diagonal, left to right in reverse, ie. check same diagonals as above but backwards
# To do this, reverse the grid, transpose it, and reverse it again, then use findWordsDiag()
gridRev = grid.collect { |row| row.reverse }
gridRevTrans = gridRev.transpose
gridRevTransRev = gridRevTrans.collect { |row| row.reverse }
findWordsDiag( gridRevTransRev, dict, "Left to Right Diagonals, Backwards")

# Find words on diagonals, right to left
findWordsDiag( gridRev, dict, "Right to Left Diagonals" )

# Find words on diagonals, right to left in reverse
gridTransRevTrans = gridTransRev.transpose
findWordsDiag( gridTransRevTrans, dict, "Right to Left Diagonals, Backwards")





