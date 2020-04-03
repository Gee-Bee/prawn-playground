class PrawnExamples::BasicConcepts
  include Prawn::View

  def initialize
    # @document = Prawn::Document.new(left_margin: 500)
    stroke_axis
  end

  def origin
    stroke_circle [0, 0], 10
    bounding_box([100, 300], width: 300, height: 200) do
      stroke_bounds
      stroke_circle [0, 0], 10
    end
  end

  def cursor
    text "the cursor is here: #{cursor}"
    text "now it is here: #{cursor}"
    move_down 200
    text "on the first move the cursor went down to: #{cursor}"
    move_up 100
    text "on the second move the cursor went up to: #{cursor}"
    move_cursor_to 400
    text "on the last move the cursor went directly to: #{cursor}"

    stroke_horizontal_rule
    pad(20) { text "Text padded both before and after." }
    stroke_horizontal_rule
    pad_top(20) { text "Text padded on the top." }
    stroke_horizontal_rule
    pad_bottom(20) { text "Text padded on the bottom." }
    stroke_horizontal_rule
    move_down 30
    text "Text written before the float block."
    float do
      move_down 30
      bounding_box([0, cursor], width: 200) do
        text "Text written inside the float block that is way to long. 1"
        text "Text written inside the float block that is way to long. 2"
        stroke_bounds
      end
    end
    text "Text written after the float block."
  end

  def adding_pages
    text "We are still on the initial page for this example. Now I'll ask " +
      "Prawn to gently start a new page. Please follow me to the next page." * 100
    start_new_page
    text "See. We've left the previous page behind..."
  end

  def measurements
    require "prawn/measurement_extensions"
    [:mm, :cm, :dm, :m, :in, :yd, :ft].each do |measurement|
      text "1 #{measurement} in PDF Points: #{1.send(measurement)} pt"
      move_down 0.8.cm
    end
  end
end
