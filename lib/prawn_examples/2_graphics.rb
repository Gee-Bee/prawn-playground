class PrawnExamples::Graphics
  include Prawn::View

  def initialize
    stroke_axis
  end

  def custom_axis
    stroke_axis(at: [70, 70], height: 200, step_length: 50,
                negative_axes_length: 5, color: "0000FF")
    stroke_axis(at: [140, 140], width: 200, height: cursor.to_i - 140,
                step_length: 20, negative_axes_length: 40, color: "FF0000")
  end

  def filling_and_stroking
    # No block
    line [0, 200], [100, 150]
    stroke
    rectangle [0, 100], 100, 100
    fill
    # With block
    stroke { line [200, 200], [300, 150] }
    fill { rectangle [200, 100], 100, 100 }
    # Method hook
    stroke_line [400, 200], [500, 150]
    fill_rectangle [400, 100], 100, 100
  end

  # SHAPES

  def lines_and_curves
    # line_to and curve_to
    stroke do
      move_to 0, 0
      line_to 100, 100
      line_to 0, 100
      curve_to [150, 250], bounds: [[20, 200], [120, 200]]
      curve_to [200, 0], bounds: [[150, 200], [450, 10]]
    end
    # line and curve
    stroke do
      line [300, 200], [400, 50]
      curve [500, 0], [400, 200], bounds: [[600, 300], [300, 390]]
    end
  end

  def common_lines
    stroke_color "ff0000"
    stroke do
      horizontal_rule
      vertical_line 100, 300, at: 50
      horizontal_line 200, 500, at: 150
    end
  end

  def rectangles
    stroke do
      rectangle [100, 300], 100, 200
      rounded_rectangle [300, 300], 100, 200, 20
    end
  end

  def polygons
    # Triangle
    stroke_polygon [50, 200], [50, 300], [150, 300]
    # Hexagon
    fill_polygon [50, 150], [150, 200], [250, 150], [250, 50], [150, 0], [50, 50]
    # Pentagram
    pentagon_points = [500, 100], [430, 5], [319, 41], [319, 159], [430, 195]
    pentagram_points = [0, 2, 4, 1, 3].map { |i| pentagon_points[i] }
    stroke_rounded_polygon(20, *pentagram_points)
  end

  def circle_and_ellipse
    stroke_circle [100, 300], 100
    fill_ellipse [200, 100], 100, 50
    fill_ellipse [400, 100], 50
  end

  # # FILL AND STROKE SETTINGS

  def sroke_line_width
    y = 250
    3.times do |i|
      case i
      # when 0 then line_width = 10 # This call will have no effect
      when 1 then self.line_width = 10
      when 2 then self.line_width = 25
      end
      stroke do
        horizontal_line 50, 150, at: y
        rectangle [275, y + 25], 50, 50
        circle [500, y], 25
      end
      y -= 100
    end
  end

  def stroke_cup
    self.line_width = 15
    [:butt, :round, :projecting_square].each_with_index do |cap, i|
      self.cap_style = cap
      y = 250 - i * 100
      stroke_horizontal_line 100, 300, at: y
      stroke_circle [400, y], 15
    end
  end

  def stroke_join
    self.line_width = 25
    [:miter, :round, :bevel].each_with_index do |style, i|
      self.join_style = style
      y = 200 - i * 100
      stroke do
        move_to(100, y)
        line_to(200, y + 100)
        line_to(300, y)
      end
      stroke_rectangle [400, y + 75], 50, 50
    end
  end

  def stroke_dash
    dash([1, 2, 3, 2, 1, 5], phase: 6)
    stroke_horizontal_line 50, 500, at: 230
    dash([1, 2, 3, 4, 5, 6, 7, 8])
    stroke_horizontal_line 50, 500, at: 220

    base_y = 210
    24.times do |i|
      length = (i / 4) + 1
      space = length # space between dashes same length as dash
      phase = 0 # start with dash
      case i % 4
      when 0 then base_y -= 5
      when 1 then phase = length # start with space between dashes
      when 2 then space = length * 0.5 # space between dashes half as long as dash
      when 3
        space = length * 0.5 # space between dashes half as long as dash
        phase = length
      end
      base_y -= 5

      dash(length, space: space, phase: phase)
      stroke_horizontal_line 50, 500, at: base_y - (2 * i)
    end
  end

  def color
    fill_color "FFFFCC" # Fill with Yellow using RGB
    fill_polygon [50, 150], [150, 200], [250, 150], [250, 50], [150, 0], [50, 50]
    stroke_color 50, 100, 0, 0 # Stroke with Purple using CMYK
    stroke_rectangle [300, 300], 200, 100
    fill_and_stroke_circle [400, 100], 50 # Both together
    fill_and_stroke do
      circle [500, 100], 40
    end
  end

  def gradients
    self.line_width = 10

    fill_gradient [50, 300], [150, 200], "ff0000", "0000ff"
    fill_rectangle [50, 300], 100, 100

    stroke_gradient [200, 200], [300, 300], "00ffff", "ffff00"
    stroke_rectangle [200, 300], 100, 100

    fill_gradient [350, 300], [450, 200], "ff0000", "0000ff"
    stroke_gradient [350, 200], [450, 300], "00ffff", "ffff00"
    fill_and_stroke_rectangle [350, 300], 100, 100

    fill_gradient [100, 100], 0, [100, 100], 70.71, "ff0000", "0000ff"
    fill_rectangle [50, 150], 100, 100

    stroke_gradient [250, 100], 45, [250, 100], 70.71, "00ffff", "ffff00"
    stroke_rectangle [200, 150], 100, 100

    stroke_gradient [400, 100], 45, [400, 100], 70.71, "00ffff", "ffff00"
    fill_gradient [400, 100], 0, [400, 100], 70.71, "ff0000", "0000ff"
    fill_and_stroke_rectangle [350, 150], 100, 100

    fill_gradient [500, 300], 15, [500, 50], 0, "ff0000", "0000ff"
    fill_rectangle [485, 300], 30, 250
  end

  def transparency
    self.line_width = 5
    fill_color "ff0000"
    fill_rectangle [0, 100], 500, 100

    fill_color "000000"
    stroke_color "ffffff"

    base_x = 100
    [[0.5, 1], 0.5, [1, 0.5]].each do |args|
      transparent(*args) do
        fill_circle [base_x, 100], 50
        stroke_rectangle [base_x - 20, 100], 40, 80
      end
      base_x += 150
    end
  end

  def soft_masks
    save_graphics_state do
      soft_mask do
        0.upto 15 do |i|
          fill_color 0, 0, 0, 100.0 / 16.0 * (15 - i)
          fill_circle [75 + i * 25, 100], 60
        end
      end

      fill_color "009ddc"
      fill_rectangle [0, 60], 600, 20
      fill_color "963d97"
      fill_rectangle [0, 80], 600, 20
      fill_color "e03a3e"
      fill_rectangle [0, 100], 600, 20
      fill_color "f5821f"
      fill_rectangle [0, 120], 600, 20
      fill_color "fdb827"
      fill_rectangle [0, 140], 600, 20
      fill_color "61bb46"
      fill_rectangle [0, 160], 600, 20
    end
  end

  def blend_modes
    bottom_layer = "#{PrawnExamples::DATADIR}/images/blend_modes_bottom_layer.jpg"
    top_layer = "#{PrawnExamples::DATADIR}/images/blend_modes_top_layer.jpg"
    blend_modes =
      [:Normal, :Multiply, :Screen, :Overlay, :Darken, :Lighten,
       :ColorDodge, :ColorBurn, :HardLight, :SoftLight, :Difference, :Exclusion, :Hue,
       :Saturation, :Color, :Luminosity]

    blend_modes.each_with_index do |blend_mode, index|
      x = index % 4 * 135
      y = cursor - (index / 4 * 200)

      image bottom_layer, at: [x, y], fit: [125, 125]
      blend_mode(blend_mode) do
        image top_layer, at: [x, y], fit: [125, 125]
      end

      y -= 130

      fill_color "009ddc"
      fill_rectangle [x, y], 75, 25
      blend_mode(blend_mode) do
        fill_color "fdb827"
        fill_rectangle [x + 50, y], 75, 25
      end

      y -= 30
      fill_color "000000"
      text_box blend_mode.to_s, at: [x, y]
    end
  end

  def fill_rules
    pentagram = [[181, 95], [0, 36], [111, 190], [111, 0], [0, 154]]

    stroke_color "ff0000"
    line_width 2.0

    text_box "Nonzero Winding Number",
      at: [50, 215],
      width: 170,
      align: :center

    polygon(*pentagram.map { |x, y| [x + 50, y] })
    fill_and_stroke

    text_box "Even-Odd", at: [330, 215], width: 170, align: :center
    polygon(*pentagram.map { |x, y| [x + 330, y] })
    fill_and_stroke(fill_rule: :even_odd)
  end

  ## TRANSFORMATIONS

  def transform_rotate
    fill_circle [250, 200], 2
    12.times do |i|
      rotate(i * 30, origin: [250, 200]) do
        stroke_rectangle [350, 225], 100, 50
        draw_text "Rotated #{i * 30}°", size: 10, at: [360, 205]
      end
    end
  end

  def transform_translate
    1.upto(3) do |i|
      x = i * 50
      y = i * 100
      translate(x, y) do
        # Draw a point on the new origin
        fill_circle [0, 0], 2
        draw_text "New origin after translation to [#{x}, #{y}]",
          at: [5, -2], size: 8
        stroke_rectangle [100, 75], 100, 50
        text_box "Top left corner at [100,75]",
          at: [110, 65],
          width: 80,
          size: 8
      end
    end
  end

  def transform_scale
    width = 100
    height = 50

    x = 50
    y = 200

    stroke_rectangle [x, y], width, height
    text_box "reference rectangle", at: [x + 10, y - 10], width: width - 20

    fill_color "ff0000"
    transparent(0.5) { fill_circle [x, y], 4 }
    fill_color "000000"
    scale(2, origin: [x, y]) do
      stroke_rectangle [x, y], width, height
      text_box "rectangle scaled from upper-left corner",
        at: [x, y - height - 5],
        width: width
    end

    x = 350
    stroke_rectangle [x, y], width, height
    text_box "reference rectangle", at: [x + 10, y - 10], width: width - 20
    fill_color "ff0000"
    transparent(0.5) { fill_circle [x + width / 2, y - height / 2], 4 }
    fill_color "000000"
    scale(2, origin: [x + width / 2, y - height / 2]) do
      stroke_rectangle [x, y], width, height
      text_box "rectangle scaled from center",
        at: [x, y - height - 5],
        width: width
    end
  end
end
