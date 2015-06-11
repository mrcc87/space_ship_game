require 'gosu'
require './player'
require './zorder'
require './star'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Star WARS"
    @background_image = Gosu::Image.new self, "media/Space.png", true
    @player = Player.new self
    @player.warp 320, 240

    @star_animation = Gosu::Image.load_tiles self, "media/Star.png", 25, 25, false
    @stars = []

    @score_text = Gosu::Font.new self, Gosu::default_font_name, 20
    @player_angle = Gosu::Font.new self, Gosu::default_font_name, 20
    @player_vel_x = Gosu::Font.new self, Gosu::default_font_name, 20
    @player_vel_y = Gosu::Font.new self, Gosu::default_font_name, 20
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end

    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end

    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end

    @player.move
    @player.collect_stars @stars

    if rand(100) < 4 and @stars.size < 25 then
      @stars.push Star.new @star_animation
    end
  end

  def draw
    @background_image.draw 0, 0, ZOrder::Background
    @player.draw
    @stars.each { |star| star.draw }
    @score_text.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    @player_angle.draw("Angle: #{@player.angle}", 110, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    @player_vel_x.draw("X Velocity: #{@player.vel_x}", 210, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    @player_vel_y.draw("Y Velocity: #{@player.vel_y}", 210, 60, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down id
    if id == Gosu::KbEscape
      close
    end
  end

end

window = GameWindow.new
window.show
