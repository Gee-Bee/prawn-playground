class PrawnExamples::Text
  include Prawn::View

  def initialize
    stroke_axis
  end

  ## BASICS

  def free_flowing_text
    move_cursor_to 50
    text "This text will flow to the next page. " * 20

    y_position = cursor - 50
    bounding_box([0, y_position], width: 200, height: 150) do
      transparent(0.5) { stroke_bounds }
      text "This text will flow along this bounding box we created for it. " * 5
    end

    bounding_box([300, y_position], width: 200, height: 150) do
      transparent(0.5) { stroke_bounds } # This will stroke on one page
      text "Now look what happens when the free flowing text reaches the end " \
        "of a bounding box that is narrower than the margin box." +
        " . " * 200 +
        "It continues on the next page as if the previous bounding box " \
        "was cloned. If we want it to have the same border as the one on " \
        "the previous page we will need to stroke the boundaries again."
      transparent(0.5) { stroke_bounds } # And this will stroke on the next
    end

    move_cursor_to 200
    span(350, position: :center) do
      text "Span is a different kind of bounding box as it lets the text " \
        "flow gracefully onto the next page. It doesn't matter if the text " \
        "started on the middle of the previous page, when it flows to the " \
        "next page it will start at the beginning." + " _ " * 500 +
        "I told you it would start on the beginning of this page."
    end
  end

  def positioned_text
    draw_text "This draw_text line is absolute positioned. However don't " \
      "expect it to flow even if it hits the document border",
      at: [200, 300]

    text_box "This is a text box, you can control where it will flow by " \
      "specifying the :height and :width options" * 2,
      at: [100, 250],
      height: 100,
      width: 100

    text_box "Another text box with no :width option passed, so it will " \
      "flow to a new line whenever it reaches the right margin. ",
      at: [200, 100]
  end

  def text_box_overflow
    string = "This is the sample text used for the text boxes. See how it " \
      "behave with the various overflow options used."

    text string

    y_position = cursor - 20
    [:truncate, :expand, :shrink_to_fit].each_with_index do |mode, i|
      text_box string,
        at: [i * 150, y_position],
        width: 100,
        height: 50,
        overflow: mode
    end

    string = "If the box is too small for the text, :shrink_to_fit " \
      "can render the text in a really small font size."

    move_down 120
    text string
    y_position = cursor - 20
    [nil, 8, 10, 12].each_with_index do |value, index|
      text_box string,
        at: [index * 150, y_position],
        width: 50,
        height: 50,
        overflow: :shrink_to_fit,
        min_font_size: value
    end
  end

  def text_box_excess
    string = "This is the beginning of the text. It will be cut somewhere and " \
      "the rest of the text will procede to be rendered this time by " \
      "calling another method." + " . " * 50

    y_position = cursor - 20
    excess_text = text_box string,
      width: 300,
      height: 50,
      overflow: :truncate,
      at: [100, y_position],
      size: 18

    text_box excess_text,
      width: 300,
      at: [100, y_position - 50]
  end

  def column_boks
    text "The Prince", align: :center, size: 18
    text "Niccolò Machiavelli", align: :center, size: 14
    move_down 12

    column_box([0, cursor], columns: 2, width: bounds.width) do
      string = <<-END
        All the States and Governments by which men are or ever have been ruled,
        have been and are either Republics or Princedoms. Princedoms are either
        hereditary, in which the sovereignty is derived through an ancient line
        of ancestors, or they are new. New Princedoms are either wholly new, as
        that of Milan to Francesco Sforza; or they are like limbs joined on to
        the hereditary possessions of the Prince who acquires them, as the
        Kingdom of Naples to the dominions of the King of Spain. The States thus
        acquired have either been used to live under a Prince or have been free;
        and he who acquires them does so either by his own arms or by the arms of
        others, and either by good fortune or by merit.
      END
      text((string.gsub(/\s+/, " ") + "\n\n") * 4)
    end
  end

end
