# Player setup
# Create empty board
# Player 1 chooses a slot. They fill lowest point in slot. Board updates
# Check if either have 4 in a row
# If not, play passes to other player
# If yes, game ends

class Board
  attr_reader :player1, :player2, :header
  attr_accessor :board, :current_player

  def initialize
    @player1 = Player.new('Black', '◇')
    @player2 = Player.new('White', '◆')
    @header = [1, 2, 3, 4, 5, 6, 7]
    @board = [['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
              ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
              ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
              ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
              ['☐', '☐', '☐', '☐', '☐', '☐', '☐'],
              ['☐', '☐', '☐', '☐', '☐', '☐', '☐']]
    @current_player = [@player1, @player2].sample
  end

  def play_game
    display_board
    until game_over?
      change_player
      assign_move
      display_board
    end

    puts "#{@current_player.name} wins! Congrats!"
  end

  def display_board
    puts %x(/usr/bin/clear) # Clears the console
    @board.each { |row| row.each { |space| print space + '  ' }; puts '' }
    @header.each { |num| print "#{num}  " }
    puts ''
  end

  def change_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def assign_move
    move = @current_player.choose_move

    until @board[0][move - 1] == '☐'
      puts 'Column already full. Please choose another:'
      move = @current_player.choose_move
    end

    @board.reverse.each do |row|
      if row[move - 1] == '☐'
        row[move - 1] = @current_player.symbol
        break
      end
    end
  end

  def game_over?
    if winning_combos.any? { |combo| combo.all?(player1.symbol) || combo.all?(player2.symbol) }
      true
    else
      false
    end
  end

  def winning_combos
    combos = []
    # Add horizontal combos
    @board.each do |row|
      combos << [row[0..3]] + [row[1..4]] + [row[2..5]] + [row[3..6]]
    end

    # Add vertical combos
    columns = [[], [], [], [], [], [], []]
    @board.each do |row|
      i = 0
      row.each do |space|
        columns[i] << space
        i += 1
      end
    end
    columns.each do |column|
      combos << [column[0..3]] + [column[1..4]] + [column[2..5]]
    end

    # Add diagonal combos
    b = @board
    combos <<
      [[b[0][0], b[1][1], b[2][2], b[3][3]]] +
      [[b[0][1], b[1][2], b[2][3], b[3][4]]] +
      [[b[0][2], b[1][3], b[2][4], b[3][5]]] +
      [[b[0][3], b[1][4], b[2][5], b[3][6]]] +

      [[b[1][0], b[2][1], b[3][2], b[4][3]]] +
      [[b[1][1], b[2][2], b[3][3], b[4][4]]] +
      [[b[1][2], b[2][3], b[3][4], b[4][5]]] +
      [[b[1][3], b[2][4], b[3][5], b[4][6]]] +

      [[b[2][0], b[3][1], b[4][2], b[5][3]]] +
      [[b[2][1], b[3][2], b[4][3], b[5][4]]] +
      [[b[2][2], b[3][3], b[4][4], b[5][5]]] +
      [[b[2][3], b[3][4], b[4][5], b[5][6]]] +

      [[b[0][3], b[1][2], b[2][1], b[3][0]]] +
      [[b[0][4], b[1][3], b[2][2], b[3][1]]] +
      [[b[0][5], b[1][4], b[2][3], b[3][2]]] +
      [[b[0][6], b[1][5], b[2][4], b[3][3]]] +

      [[b[1][3], b[2][2], b[3][1], b[4][0]]] +
      [[b[1][4], b[2][3], b[3][2], b[4][1]]] +
      [[b[1][5], b[2][4], b[3][3], b[4][2]]] +
      [[b[1][6], b[2][5], b[3][4], b[4][3]]] +

      [[b[2][3], b[3][2], b[4][1], b[5][0]]] +
      [[b[2][4], b[3][3], b[4][2], b[5][1]]] +
      [[b[2][5], b[3][4], b[4][3], b[5][2]]] +
      [[b[2][6], b[3][5], b[4][4], b[5][3]]]
    return combos.flatten(1)
  end
end

class Player
  attr_reader :name, :symbol, :move

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def choose_move
    puts "\nPlayer #{name}, choose a column:"
    @move = gets.chomp.to_i
  end
end
