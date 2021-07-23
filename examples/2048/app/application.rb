require 'opal'
require 'native'
require 'promise'
require 'browser/setup/full'

class Game
  def initialize
    @grid = ([[nil] * 4] * 4).map(&:dup)

    2.times { add_field }
  end

  attr_reader :grid

  def lost?
    @grid.all? { |row| row.all? } && !(begin
      (0..2).any? do |y|
        (0..3).any? do |x|
          @grid[y][x] == @grid[y+1][x]
        end
      end
    end || begin
      (0..3).any? do |y|
        (0..2).any? do |x|
          @grid[y][x] == @grid[y][x+1]
        end
      end
    end)
  end

  def won?
    @grid.any? { |row| row.any? { |f| f == 2048 } }
  end

  def add_field
    return if lost? or won?

    y,x = nil

    loop do
      y,x = random_field
      break unless @grid[y][x]
    end

    @grid[y][x] = [2,4].sample
  end

  def shake(dir)
    grid = @grid
    conversion = proc {}
    back_conversion = nil

    case dir
    when :left
    when :right
      conversion = proc { grid = grid.map(&:reverse) }
    when :top
      conversion = proc { grid = grid.transpose }
    when :bottom
      conversion = proc do
        grid = grid.transpose
        grid = grid.map(&:reverse)
      end

      back_conversion = proc do
        grid = grid.map(&:reverse)
        grid = grid.transpose
      end
    end

    back_conversion ||= conversion

    conversion.()

    grid = grid.map do |row|
      row = row.compact
      (0..2).each do |x|
        if row[x] && row[x+1] && row[x] == row[x+1]
          row[x], row[x+1] = row[x] + row[x+1], nil
        end
      end
      row = row.compact
      row = (row + [nil]*4)[0..3]
    end

    back_conversion.()

    changed = grid != @grid

    @grid = grid

    add_field if changed && !lost?
  end

  private

  def random_field
    [rand(4), rand(4)]
  end
end

def render(game)
  $document[:arena].inner_dom { |b|
    (0..3).each do |y|
      b.tr {
        (0..3).each do |x|
          b.td(class: "f_"+(game.grid[y][x] || "nil").to_s) {
            (game.grid[y][x] || "").to_s
          }
        end
      }
    end
  }
end

$document.head << DOM("<style>
  #arena {
    border-collapse: separate;
    border-spacing: 4px;
  }
  #arena td {
    width: 150px;
    height: 150px;
    border: 2px solid black;
    font-size: 50px;
    vertical-align: middle;
    text-align: center;
  }
  #arena .f_2    { background-color: #eff; }
  #arena .f_4    { background-color: #eef; }
  #arena .f_8    { background-color: #def; }
  #arena .f_16   { background-color: #dee; }
  #arena .f_32   { background-color: #ded; }
  #arena .f_64   { background-color: #ced; }
  #arena .f_128  { background-color: #cdd; }
  #arena .f_256  { background-color: #cdc; }
  #arena .f_512  { background-color: #bdc; }
  #arena .f_1024 { background-color: #bcc; }
  #arena .f_2048 { background-color: #bbc; }
</style>")
$document.body << DOM("<div id='arena'></div>")

$game = game = Game.new
render(game)

$document.on(:keydown) do |e|
  case e.key
  when :ArrowUp
    game.shake(:top)
  when :ArrowDown
    game.shake(:bottom)
  when :ArrowLeft
    game.shake(:left)
  when :ArrowRight
    game.shake(:right)
  end

  render(game)

  if game.lost?
    alert "You lost!"
    game = Game.new
  elsif game.won?
    alert "You won!"
    game = Game.new
  end

  render(game)
end