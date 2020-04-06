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

  ## STYLING

  def change_font
    text "Let's see which font we are using: #{font.inspect}"
    move_down 20

    font "Times-Roman"
    text "Written in Times."
    move_down 20

    font("Courier") do
      text "Written in Courier because we are inside the block."
    end
    move_down 20

    text "Written in Times again as we left the previous block."
    move_down 20
    text "Let's see which font we are using again: #{font.inspect}"
    move_down 20

    font "Helvetica"
    text "Back to normal."
  end

  def change_font_size
    text "Let's see which is the current font_size: #{font_size.inspect}"
    move_down 10

    font_size 16
    text "Yeah, something bigger!"
    move_down 10

    font_size(25) { text "Even bigger!" }
    move_down 10

    text "Back to 16 again."
    move_down 10

    text "Single line on 20 using the :size option.", size: 20
    move_down 10

    text "Back to 16 once more."
    move_down 10

    font("Courier", size: 10) do
      text "Yeah, using Courier 10 courtesy of the font method."
    end
    move_down 10

    font("Helvetica", size: 12)
    text "Back to normal"
  end

  def change_font_style
    ["Courier", "Helvetica", "Times-Roman"].each do |example_font|
      move_down 20
      [:bold, :bold_italic, :italic, :normal].each do |style|
        font example_font, style: style
        text "I'm writing in #{example_font} (#{style})"
      end
    end
  end

  def change_color
    text "Default color is black"
    move_down 25

    text "Changed to red", color: "FF0000"
    move_down 25

    text "CMYK color", color: [22, 55, 79, 30]
    move_down 25

    text "Also works with <color rgb='ff0000'>inline</color> formatting",
      color: "0000FF",
      inline_format: true
  end

  def alignment
    text "This text should be left aligned"
    text "This text should be centered", align: :center
    text "This text should be right aligned", align: :right

    bounding_box([0, 220], width: 250, height: 220) do
      text "This text is flowing from the left. " * 4
      move_down 15
      text "This text is flowing from the center. " * 3, align: :center
      move_down 15
      text "This text is flowing from the right. " * 4, align: :right
      move_down 15
      text "This text is justified. " * 6, align: :justify
      transparent(0.5) { stroke_bounds }
    end

    bounding_box([300, 220], width: 250, height: 220) do
      text "This text should be vertically top aligned"
      text "This text should be vertically centered", valign: :center
      text "This text should be vertically bottom aligned", valign: :bottom
      transparent(0.5) { stroke_bounds }
    end
  end

  def leading
    string = "Hey, what did you do with the space between my lines? " * 10
    text string, leading: 0
    move_down 20

    default_leading 5
    text string

    move_down 20
    text string, leading: 10
  end

  def kerning_and_character_spacing
    font_size(30) do
      text_box "With kerning:", kerning: true, at: [0, y - 40]
      text_box "Without kerning:", kerning: false, at: [0, y - 80]
      text_box "Tomato", kerning: true, at: [250, y - 40]
      text_box "Tomato", kerning: false, at: [250, y - 80]
      text_box "WAR", kerning: true, at: [400, y - 40]
      text_box "WAR", kerning: false, at: [400, y - 80]
      text_box "F.", kerning: true, at: [500, y - 40]
      text_box "F.", kerning: false, at: [500, y - 80]
    end
    move_down 80
    string = "What have you done to the space between the characters?"
    [-2, -1, 0, 0.5, 1, 2].each do |spacing|
      move_down 20
      text "#{string} (character_spacing: #{spacing})", character_spacing: spacing
    end
  end

  def paragraph_indentation
    # Using non-breaking spaces
    text " " * 10 + "This paragraph won't be indented. " * 10 +
      "\n#{Prawn::Text::NBSP * 10}" + "This one will with NBSP. " * 10
    move_down 20

    text "This paragraph will be indented. " * 10 +
      "\n" + "This one will too. " * 10,
      indent_paragraphs: 60
    move_down 20

    text "FROM RIGHT TO LEFT:"
    text "This paragraph will be indented. " * 10 +
      "\n" + "This one will too. " * 10,
      indent_paragraphs: 60, direction: :rtl
  end

  def rotation
    width = 100
    height = 60
    angle = 30
    x = 200
    y = cursor - 30

    stroke_rectangle [0, y], width, height
    text_box("This text was not rotated",
      at: [0, y], width: width, height: height)

    stroke_rectangle [0, y - 100], width, height
    text_box("This text was rotated around the center",
      at: [0, y - 100], width: width, height: height,
      rotate: angle, rotate_around: :center)

    [:lower_left, :upper_left, :lower_right, :upper_right].each_with_index do |corner, index|
      y -= 100 if index == 2
      stroke_rectangle [x + (index % 2) * 200, y], width, height
      text_box("This text was rotated around the #{corner} corner.",
        at: [x + (index % 2) * 200, y],
        width: width,
        height: height,
        rotate: angle,
        rotate_around: corner)
    end
  end

  ## Advanced styling

  def inline_formatting
    %w[b i u strikethrough sub sup].each do |tag|
      text "Just your regular text <#{tag}>except this portion</#{tag}> " \
        "is using the #{tag} tag",
        inline_format: true
      move_down 10
    end

    text "This <font size='18'>line</font> uses " \
      "<font name='Courier'>all the font tag</font> attributes in " \
      "<font character_spacing='2'>a single line</font>. ",
      inline_format: true
    move_down 10

    text "Coloring in <color rgb='FF00FF'>both RGB</color> " \
      "<color c='100' m='0' y='0' k='0'>and CMYK</color>",
      inline_format: true
    move_down 10

    text "This an external link to the " \
      "<u><link href='https://github.com/prawnpdf/prawn/wiki'>Prawn wiki" \
      "</link></u>",
      inline_format: true
  end

  def formatted
    formatted_text [
      {text: "Some bold. ", styles: [:bold]},
      {text: "Some italic. ", styles: [:italic]},
      {text: "Bold italic. ", styles: [:bold, :italic]},
      {text: "Bigger Text. ", size: 20},
      {text: "More spacing. ", character_spacing: 3},
      {text: "Different Font. ", font: "Courier"},
      {text: "Some coloring. ", color: "FF00FF"},
      {text: "Link to the wiki. ", color: "0000FF", link: "https://github.com/prawnpdf/prawn/wiki"},
      {text: "Link to a local file. ", color: "0000FF", local: "./local_file.txt"}
    ]

    formatted_text_box [
      {text: "Just your regular"},
      {text: " text_box ", font: "Courier"},
      {text: "with some additional formatting options " \
        "added to the mix.", color: [50, 100, 0, 0], styles: [:italic]}
    ], at: [100, 100], width: 200, height: 100
  end

  class HighlightCallback
    def initialize(options)
      @color = options[:color]
      @document = options[:document]
    end

    def render_behind(fragment)
      original_color = @document.fill_color
      @document.fill_color = @color
      @document.fill_rectangle(
        fragment.top_left,
        fragment.width,
        fragment.height
      )
      @document.fill_color = original_color
    end
  end

  class ConnectedBorderCallback
    def initialize(options)
      @radius = options[:radius]
      @document = options[:document]
    end

    def render_in_front(fragment)
      @document.stroke_polygon(
        fragment.top_left, fragment.top_right,
        fragment.bottom_right, fragment.bottom_left
      )
      @document.fill_circle(fragment.top_left, @radius)
      @document.fill_circle(fragment.top_right, @radius)
      @document.fill_circle(fragment.bottom_right, @radius)
      @document.fill_circle(fragment.bottom_left, @radius)
    end
  end

  def formatted_callback
    highlight = HighlightCallback.new(color:  "ffff00", document: self)
    border = ConnectedBorderCallback.new(radius: 2.5, document: self)

    formatted_text [
      {text: "hello", callback: highlight},
      {text: "     "},
      {text: "world", callback: border},
      {text: "     "},
      {text: "hello world", callback: [highlight, border]}
    ], size: 20
  end

  def rendering_and_color
    fill_color "00ff00"
    stroke_color "0000ff"

    font_size(40) do
      # normal rendering mode: fill
      text "This text is filled with green."
      move_down 20

      # inline rendering mode: stroke
      text "This text is stroked with blue", mode: :stroke
      move_down 20

      # block rendering mode: fill and stroke
      text_rendering_mode(:fill_stroke) do
        text "This text is filled with green and stroked with blue"
      end
    end
  end

  module TriangleBox
    def available_width
      height + 25
    end
  end

  def text_box_extensions
    y_position = cursor - 10
    width = 100
    height = 100

    Prawn::Text::Box.extensions << TriangleBox
    stroke_rectangle([0, y_position], width, height)
    text_box("A" * 100,
      at: [0, y_position],
      width: width,
      height: height
    )

    Prawn::Text::Formatted::Box.extensions << TriangleBox
    stroke_rectangle([200, y_position], width, height)
    formatted_text_box([text: "A" * 100, color: "009900"],
      at: [200, y_position],
      width: width,
      height: height
    )

    # Here we clear the extensions array
    Prawn::Text::Box.extensions.clear
    Prawn::Text::Formatted::Box.extensions.clear
  end

  ## External Fonts

  def external_font_single_usage
    font("#{PrawnExamples::DATADIR}/fonts/DejaVuSans.ttf") do
      text "Written with the DejaVu Sans TTF font."
    end
    move_down 20

    text "Written with the default font."
    move_down 20

    # Using an DFONT font file
    font("#{PrawnExamples::DATADIR}/fonts/Panic Sans.dfont") do
      text "Written with the Panic Sans DFONT font"
    end
    move_down 20

    text "Written with the default font once more."
  end

  def external_font_registering_families
    # Registering a single TTF font
    font_families.update(
      "DejaVu Sans" => {
        normal: "#{PrawnExamples::DATADIR}/fonts/DejaVuSans.ttf"
      }
    )
    font("DejaVu Sans") do
      text "Using the DejaVu Sans font providing only its name to the font method"
    end
    move_down 20

    # Registering a DFONT package
    font_path = "#{PrawnExamples::DATADIR}/fonts/Panic Sans.dfont"
    font_families.update(
      "Panic Sans" => {
        normal: {file: font_path, font: "PanicSans"},
        italic: {file: font_path, font: "PanicSans-Italic"},
        bold: {file: font_path, font: "PanicSans-Bold"},
        bold_italic: {file: font_path, font: "PanicSans-BoldItalic"}
      }
    )
    font "Panic Sans"
    text "Also using Panic Sans by providing only its name"
    move_down 20

    text "Taking <b>advantage</b> of the <i>inline formatting</i>",
      inline_format: true
    move_down 20

    [:bold, :bold_italic, :italic, :normal].each do |style|
      text "Using the #{style} style option.", style: style
      move_down 10
    end
  end

  def utf8
    text "Take this example, a simple Euro sign:"
    text "€", size: 32
    move_down 20

    text "This works, because € is one of the few " \
      "non-ASCII glyphs supported in PDF built-in fonts."
    move_down 20

    text "For full internationalized text support, we need to use TTF fonts:"
    move_down 20
    font("#{PrawnExamples::DATADIR}/fonts/DejaVuSans.ttf") do
      text "ὕαλον φαγεῖν δύναμαι· τοῦτο οὔ με βλάπτει."
      text "Gżegżółka"
      text "There you go."
    end
  end

  def line_wrapping
    text "Hard hyphens:\n" \
      "Slip-sliding away, slip sliding awaaaay. You know the " \
      "nearer your destination the more you're slip-sliding away."
    move_down 20

    shy = Prawn::Text::SHY
    text "Soft hyphens:\n" \
      "Slip slid#{shy}ing away, slip slid#{shy}ing away. You know the " \
      "nearer your destinat#{shy}ion the more you're slip slid#{shy}ing away."
    move_down 20

    nbsp = Prawn::Text::NBSP
    text "Non-breaking spaces:\n" \
      "Slip#{nbsp}sliding away, slip#{nbsp}sliding awaaaay. You know the " \
      "nearer your destination the more you're slip#{nbsp}sliding away."
    move_down 20

    font("#{PrawnExamples::DATADIR}/fonts/gkai00mp.ttf", size: 16) do
      long_text = "No word boundaries:\n更可怕的是,同质化竞争对手可以按照URL中后面这个
      ID来遍历您的DB中的内容,写个小爬虫把你的页面上的关键信息顺次爬下来也不是什么难事,这样的话,你就
      非常被动了。更可怕的是,同质化竞争对手可以按照URL中后面这个ID来遍历您的DB中的内容,写个小爬虫把
      你的页面上的关键信息顺次爬下来也不是什么难事,这样的话,你就非常被动了。".gsub(/\s+/, "")
      text long_text
      move_down 20

      zwsp = Prawn::Text::ZWSP
      long_text = "Invisible word boundaries:\n更#{zwsp}可怕的#{zwsp}是,#{zwsp}同质化#{zwsp}竞争
      #{zwsp}对#{zwsp}手#{zwsp}可以#{zwsp}按照#{zwsp}URL#{zwsp}中#{zwsp}后
      面#{zwsp}这个#{zwsp}ID#{zwsp}来#{zwsp}遍历#{zwsp}您的#{zwsp}DB#{zwsp}中的#{zwsp}内容
      ,#{zwsp}写个#{zwsp}小爬虫#{zwsp}把#{zwsp}你的#{zwsp}页面#{zwsp}上的#{zwsp}关#{zwsp}
      键#{zwsp}信#{zwsp}息顺#{zwsp}次#{zwsp}爬#{zwsp}下来#{zwsp}也#{zwsp}不是#{zwsp}什么
      #{zwsp}难事,#{zwsp}这样的话,#{zwsp}你#{zwsp}就#{zwsp}非常#{zwsp}被动了。#{zwsp}更
      #{zwsp}可怕的#{zwsp}是,#{zwsp}同质化#{zwsp}竞争#{zwsp}对#{zwsp}手#{zwsp}可以#{zwsp}按
      照#{zwsp}URL#{zwsp}中#{zwsp}后面#{zwsp}这个#{zwsp}ID#{zwsp}来#{zwsp}遍历#{zwsp}您的#{zwsp}
      DB#{zwsp}中的#{zwsp}内容,#{zwsp}写个#{zwsp}小爬虫#{zwsp}把#{zwsp}你的#{zwsp}页面#{zwsp}上
      的#{zwsp}关#{zwsp}键#{zwsp}信#{zwsp}息顺#{zwsp}次#{zwsp}爬#{zwsp}下来#{zwsp}也#{zwsp}不
      是#{zwsp}什么#{zwsp}难事,#{zwsp}这样的话,#{zwsp}你#{zwsp}就#{zwsp}非常#{zwsp}被动了。".gsub(/\s+/, "")
      text long_text
    end
  end

  def rtl
    # set the direction document-wide
    self.text_direction = :rtl
    font("#{PrawnExamples::DATADIR}/fonts/gkai00mp.ttf", size: 16) do
      long_text =
        "写个小爬虫把你的页面上的关键信息顺次爬下来也不是什么难事写个小爬虫把你的页面上的关键信息顺次爬
        下来也不是什么难事写个小爬虫把你的页面上的关键信息顺次爬下来也不是什么难事写个小"
      text long_text
      move_down 20

      text "You can override the document direction.", direction: :ltr
      move_down 20
      formatted_text [
        {text: "更可怕的是,同质化竞争对手可以按照"},
        {text: "URL", direction: :ltr},
        {text: "中后面这个"},
        {text: "ID", direction: :ltr},
        {text: "来遍历您的"},
        {text: "DB", direction: :ltr},
        {text: "中的内容,写个小爬虫把你的页面上的关键信息顺次爬下来也不是什么难事,这样的话,你就非常被动。"}
      ]

      formatted_text [
        {text: "更可怕的是,同质化竞争对手可以按照"},
        {text: "this", direction: :ltr},
        {text: "won't", direction: :ltr, size: 24},
        {text: "work", direction: :ltr},
        {text: "中的内容,写个小爬虫把你的页面上的关键信息顺次爬下来也不是什么难事"}
      ]
    end
  end

  def set_fallback_fonts
    file = "#{PrawnExamples::DATADIR}/fonts/gkai00mp.ttf"
    font_families["Kai"] = {
      normal: {file: file, font: "Kai"}
    }

    file = "#{PrawnExamples::DATADIR}/fonts/Panic Sans.dfont"
    font_families["Panic Sans"] = {
      normal: {file: file, font: "PanicSans"}
    }

    font("Panic Sans") do
      text(
        "When fallback fonts are included, each glyph will be rendered " \
        "using the first font that includes the glyph, starting with the " \
        "current font and then moving through the fallback fonts from left " \
        "to right." \
        "\n\n" \
        "hello ƒ 你好\n再见 ƒ goodbye",
        fallback_fonts: ["Times-Roman", "Kai"]
      )
    end
    move_down 20

    self.fallback_fonts = ["Kai"]
    formatted_text([
      {text: "Fallback fonts can even override"},
      {text: "fragment fonts (你好)", font: "Times-Roman"}
    ])
  end
end
