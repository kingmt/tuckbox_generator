require "prawn"
require "prawn/measurement_extensions"
require "prawn_shapes"





PAPER_WIDTH = 1100
PAPER_HEIGHT = 850
#  given
height = 3.5
width = 1.5
thickness = 0.75
h = height.send :in
w = width.send :in
t = thickness.send :in
margin_x =  0

margin_x1 = 720
margin_y = 0
margin_y1 = 7.5 * 72

points = []
widths = {}
heights = {}
cut_lines = []
fold_lines = []
glue_boxes = []
reverse_points = []
reverse_cut_lines = []
reverse_fold_lines = []
reverse_glue_boxes = []
# key point is X margin + 7.2, y margin -7.2 -->
# cx=" 60" cy="735"
points[ 0] = [margin_x + 7.2, margin_y - 7.2]

widths[:glue_thick] = t - 21.6
widths[:glue_flap_thick] = t - 14.4
widths[:glue_width] = w - 14.4
widths[:left_edge] = margin_x + 7.2
widths[:left_edge_tuck_flap_indent] = margin_x + 14.4
widths[:left_edge_tuck_flap_indent_2] = margin_x + 21.6
widths[:left_side_back] = margin_x + 7.2 + t
widths[:left_side_glue_flap_back] = margin_x + t
widths[:left_side_top_cut] = margin_x + 25.2 + t
widths[:right_side_top_cut] = margin_x - 10.8 + t + w
widths[:back_right_side] = margin_x + 7.2 + t + w
widths[:back_right_side_glue_flap] = margin_x + 2*t + w
widths[:right_side_tuck_flap_indent] = margin_x - 7.2 + 2*t + w
widths[:right_side_tuck_flap_indent_2] = margin_x + 2*t + w
widths[:right_side_right_edge] = margin_x + 7.2 + 2*t + w
widths[:bottom_right_side_glue_box] = margin_x + 2*t + 2*w
widths[:notch_center] = margin_x + 7.2 + 2*t + 1.5*w
widths[:front_right_edge] = margin_x + 7.2 + 2*t + 2*w
widths[:left_edge_tuck_flap_indent0] = margin_x + 14.4 + 2*t + 2*w
widths[:side_glue_flap_right_edge] = margin_x + 3*t + 2*w
widths[:side_glue_flap_glue_point] = margin_x + 3*t + 2*w - 7.2

widths[:reverse_left_edge] = margin_x1 - 7.2
widths[:reverse_left_edge_tuck_flap_indent] = margin_x1 - 14.4
widths[:reverse_left_edge_tuck_flap_indent_2] = margin_x1 - 21.6
widths[:reverse_left_side_back] = margin_x1 - 7.2 - t
widths[:reverse_left_side_top_cut] = margin_x1 - 25.2 - t
widths[:reverse_right_side_top_cut] = margin_x - 7.2 - t - w
widths[:reverse_back_right_side] = margin_x1 - 7.2 - t - w
widths[:reverse_back_right_side_glue_flap] = margin_x1 - 14.4 - t - w
widths[:reverse_right_side_tuck_flap_indent] = margin_x - 7.2 - 2*t - w
widths[:reverse_right_side_tuck_flap_indent_2] = margin_x1 - 2*t - w
widths[:reverse_right_side_right_edge] = margin_x1 - 7.2 - 2*t - w
widths[:reverse_bottom_right_side_glue_box] = margin_x1 - 14.4 - 2*t - w
widths[:reverse_notch_center] = margin_x1 - 7.2 - 2*t - 1.5*w
widths[:reverse_front_right_edge] = margin_x1 - 7.2 - 2*t - 2*w
widths[:reverse_left_edge_tuck_flap_indent0] = margin_x1 - 14.4 - 2*t - 2*w
widths[:reverse_side_glue_flap_right_edge] = margin_x1 - 7.2 - 3*t - 2*w


heights[:glue_side] = h - 14.4
heights[:glue_thick] = t - 14.4
heights[:glue_flap_thick] = t - 21.6
heights[:h140] = margin_y + 61.2 + 2*t + h
heights[:h165] = margin_y + 43.2 + 2*t + h
heights[:h215] = margin_y + 7.2 + 2*t + h
heights[:h225] = margin_y + 54 + t + h
heights[:h275] = margin_y + 25.2 + t + h
heights[:h290] = margin_y + 14.4 + t + h
heights[:h300] = margin_y + 7.2 + t + h
heights[:h310] = margin_y + t + h
heights[:h320] = margin_y + t + h - 14.2
heights[:h640] = margin_y + 14.4 + t
heights[:h650] = margin_y + 7.2 + t
heights[:h660] = margin_y + t
heights[:h715] = margin_y + 21.6
heights[:h725] = margin_y + 14.4
heights[:h735] = margin_y + 7.2
heights[:reverse_h140] = margin_y1 - 61.2 - 2*t - h
heights[:reverse_h165] = margin_y1 - 43.2 - 2*t - h
heights[:reverse_h215] = margin_y1 - 7.2 - 2*t - h
heights[:reverse_h225] = margin_y1 - 54 - t - h
heights[:reverse_h275] = margin_y1 - 25.2 - t - h
heights[:reverse_h290] = margin_y1 - 14.4 - t - h
heights[:reverse_h300] = margin_y1 - 7.2 - t - h
heights[:reverse_h310] = margin_y1 - t - h
heights[:reverse_h650] = margin_y1 - 7.2 - t
heights[:reverse_h660] = margin_y1 - t
heights[:reverse_h725] = margin_y1 - 14.4
heights[:reverse_h735] = margin_y1 - 7.2

points[ 1] = [margin_x + 14.4, margin_y + 7.2]
points[ 2] = heights[:h650], widths[:left_edge]
points[ 3] = heights[:h300], widths[:left_edge]
points[ 4] = heights[:h290], widths[:left_edge]
points[ 5] = heights[:h275], widths[:left_edge_tuck_flap_indent]
points[ 6] = heights[:h225], widths[:left_edge_tuck_flap_indent_2]
points[ 7] = heights[:h165], widths[:left_side_back]
points[ 8] = heights[:h215], widths[:left_side_back]
points[ 9] = heights[:h225], widths[:left_side_back]
points[10] = heights[:h300], widths[:left_side_back]
points[11] = heights[:h725], widths[:left_side_back]
points[12] = heights[:h735], widths[:left_side_back]
points[13] = heights[:h650], widths[:left_side_back]
points[14] = heights[:h140], widths[:left_side_top_cut]
points[15] = heights[:h215], widths[:left_side_top_cut]
points[16] = heights[:h140], widths[:right_side_top_cut]
points[17] = heights[:h215], widths[:right_side_top_cut]
points[18] = heights[:h165], widths[:back_right_side]
points[19] = heights[:h215], widths[:back_right_side]
points[20] = heights[:h225], widths[:back_right_side]
points[21] = heights[:h300], widths[:back_right_side]
points[22] = heights[:h725], widths[:back_right_side]
points[23] = heights[:h735], widths[:back_right_side]
points[24] = heights[:h650], widths[:back_right_side]
points[25] = heights[:h225], widths[:right_side_tuck_flap_indent]
points[26] = heights[:h275], widths[:right_side_tuck_flap_indent_2]
points[27] = heights[:h290], widths[:right_side_right_edge]
points[28] = heights[:h300], widths[:right_side_right_edge]
points[29] = heights[:h650], widths[:right_side_right_edge]
points[30] = heights[:h725], widths[:right_side_right_edge]
points[31] = heights[:h735], widths[:right_side_right_edge]
points[32] = heights[:h300], widths[:front_right_edge]
points[33] = heights[:h650], widths[:front_right_edge]
points[34] = heights[:h735], widths[:front_right_edge]
points[35] = heights[:h300], widths[:side_glue_flap_right_edge]
points[36] = heights[:h650], widths[:side_glue_flap_right_edge]
points[37] = heights[:h300], widths[:notch_center]
points[38] = heights[:h715], widths[:left_side_glue_flap_back]
points[39] = heights[:h715], widths[:back_right_side_glue_flap]
points[40] = heights[:h725], widths[:bottom_right_side_glue_box]
points[41] = heights[:h640], widths[:side_glue_flap_glue_point]
points[42] = heights[:h320], widths[:back_right_side]
points[43] = heights[:h320], widths[:left_side_back]
points[44] = heights[:h165], widths[:right_side_top_cut]
points[45] = heights[:h165], widths[:left_side_top_cut]

reverse_points[ 0] = heights[:reverse_h650], widths[:left_edge]
reverse_points[ 1] = heights[:reverse_h650], widths[:left_edge]
reverse_points[ 2] = heights[:reverse_h650], widths[:left_edge]
reverse_points[ 3] = heights[:reverse_h300], widths[:left_edge]
reverse_points[ 4] = heights[:reverse_h290], widths[:left_edge]
reverse_points[ 5] = heights[:reverse_h275], widths[:left_edge_tuck_flap_indent]
reverse_points[ 6] = heights[:reverse_h225], widths[:left_edge_tuck_flap_indent_2]
reverse_points[ 7] = heights[:reverse_h165], widths[:left_side_back]
reverse_points[ 8] = heights[:reverse_h215], widths[:left_side_back]
reverse_points[ 9] = heights[:reverse_h225], widths[:left_side_back]
reverse_points[10] = heights[:reverse_h300], widths[:left_side_back]
reverse_points[11] = heights[:reverse_h725], widths[:left_side_back]
reverse_points[12] = heights[:reverse_h735], widths[:left_side_back]
reverse_points[13] = heights[:reverse_h650], widths[:left_side_back]
reverse_points[14] = heights[:reverse_h140], widths[:left_side_top_cut]
reverse_points[15] = heights[:reverse_h215], widths[:left_side_top_cut]
reverse_points[16] = heights[:reverse_h140], widths[:right_side_top_cut]
reverse_points[17] = heights[:reverse_h215], widths[:right_side_top_cut]
reverse_points[18] = heights[:reverse_h165], widths[:back_right_side]
reverse_points[19] = heights[:reverse_h215], widths[:back_right_side]
reverse_points[20] = heights[:reverse_h225], widths[:back_right_side]
reverse_points[21] = heights[:reverse_h300], widths[:back_right_side]
reverse_points[22] = heights[:reverse_h725], widths[:back_right_side]
reverse_points[23] = heights[:reverse_h735], widths[:back_right_side]
reverse_points[24] = heights[:reverse_h650], widths[:back_right_side]
reverse_points[25] = heights[:reverse_h225], widths[:right_side_tuck_flap_indent]
reverse_points[26] = heights[:reverse_h275], widths[:right_side_tuck_flap_indent_2]
reverse_points[27] = heights[:reverse_h290], widths[:right_side_right_edge]
reverse_points[28] = heights[:reverse_h300], widths[:right_side_right_edge]
reverse_points[29] = heights[:reverse_h650], widths[:right_side_right_edge]
reverse_points[30] = heights[:reverse_h725], widths[:right_side_right_edge]
reverse_points[31] = heights[:reverse_h735], widths[:right_side_right_edge]
reverse_points[32] = heights[:reverse_h300], widths[:front_right_edge]
reverse_points[33] = heights[:reverse_h650], widths[:front_right_edge]

cut_lines << points[1] + points[4]
cut_lines << points[4] + points[5]
cut_lines << points[5] + points[6]
cut_lines << points[6] + points[9]
cut_lines << points[8] + points[15]
cut_lines << points[1] + points[11]
cut_lines << points[12] + points[13]
cut_lines << points[7] + points[43]
#cut_lines << points[7] + points[14]
cut_lines << points[14] + points[16]
# cut_lines << points[16] + points[18]
cut_lines << points[18] + points[42]
cut_lines << points[20] + points[25]
cut_lines << points[25] + points[26]
cut_lines << points[26] + points[27]
cut_lines << points[27] + points[28]
cut_lines << points[28] + points[35]
cut_lines << points[35] + points[36]
cut_lines << points[33] + points[36]
cut_lines << points[33] + points[34]
cut_lines << points[31] + points[34]
cut_lines << points[29] + points[31]
cut_lines << points[24] + points[23]
cut_lines << points[22] + points[30]
cut_lines << points[12] + points[23]
cut_lines << points[17] + points[19]

fold_lines << points[2] + points[33]
fold_lines << points[3] + points[28]
fold_lines << points[15] + points[17]
fold_lines << points[10] + points[13]
fold_lines << points[21] + points[24]
fold_lines << points[28] + points[29]
fold_lines << points[32] + points[33]
fold_lines << points[42] + points[43]

glue_boxes << points[41] + [widths[:glue_thick], heights[:glue_side] ]
glue_boxes << points[40] + [widths[:glue_width], heights[:glue_thick] ]
glue_boxes << points[38] + [widths[:glue_thick], heights[:glue_flap_thick] ]
glue_boxes << points[39] + [widths[:glue_thick], heights[:glue_flap_thick] ]


# box_orientation valid values are:
#     vertical = point is upper left, no rotation
#     upside_down = point is lower left, needs 180 rotation
#     sideways_right = point is upper left, needs 90 rotation ccw
#     sideways_left = point is upper right, needs 90 rotation cw
# text_orientation
#     vertical = point is upper left, from page view text flows from upper right to lower left
#     upside_down = point is lower left, needs 180 rotation, from page view text flows from bottom to top
#     sideways_right = point is upper left, needs 90 rotation ccw, top of text is left, bottom of text is right
#     sideways_left = point is upper right, needs 90 rotation cw, top of text is right, bottom of test is left
# background_color
#     can be nil, otherwise expected to be 6 hex char
# image
#     can be nil
# image_orientation - only valid if image is present
#     vertical = point is upper left, text flows from upper right to lower left
#     upside_down = point is lower left, needs 180 rotation
#     sideways_right = point is upper left, needs 90 rotation ccw
#     sideways_left = point is upper right, needs 90 rotation cw
# image can be fit to size or forced height or forced width
# z indexing is background color is on the bottom, image is in the middle, text is on top
#
def render_box_face point_upper_left, point_lower_right, args
  box_orientation = args[:box_orientation] || :vertical
  width = point_lower_right.first - point_upper_left.first
  height = point_upper_left.last - point_lower_right.last
  point_upper_right = point_lower_right.first, point_upper_left.last
  point_lower_left = point_upper_left.first, point_lower_right.last
  if args[:background_color]
    save_graphics_state do
      fill_color args[:background_color]
      fill_rectangle point_upper_left, width, height
    end
  end

  if args[:image]
    case args[:image_orientation]
    when :sideways_right
      angle = 90
      point = point_lower_left
      w = height
      h = width
    when :sideways_left
      point = point_upper_right
      angle = 270
      w = height
      h = width
    when :upside_down
      point = point_lower_right
      angle = 180
      w = width
      h = height
    else
      angle = 0
      point = point_upper_left
      w = width
      h = height
    end
    rotate angle, origin: point do
      bounding_box point, width: w, height: h do
        if args[:image_fit_or_native] == :stretch
          image args[:image], at: point, width: w, height: h
        else
          # :fit
          image args[:image], position: :center, vposition: :center, fit: [w, h]
        end
      end
    end
  end

  if args[:text]
    save_graphics_state do
      text_mode = :fill
      if args[:text_fill_color] && args[:text_stroke_color]
        fill_color args[:text_fill_color]
        stroke_color args[:text_stroke_color]
        text_mode = :fill_stroke
      elsif !args[:text_fill_color] && args[:text_stroke_color]
        stroke_color args[:text_stroke_color]
        text_mode = :stroke
      elsif args[:text_fill_color]
        fill_color args[:text_fill_color]
      end

      case args[:text_orientation]
      when :sideways_right
        angle = 90
        point = point_lower_left
        w = height
        h = width
      when :sideways_left
        point = point_upper_right
        angle = 270
        w = height
        h = width
      when :upside_down
        point = point_lower_right
        angle = 180
        w = width
        h = height
      else
        angle = 0
        point = point_upper_left
        w = width
        h = height
      end
      rotate angle, origin: point do
        font(args[:font] || "Helvetica") do
          text_box args[:text], at: point, width: w, height: h, mode: text_mode,
                   align: :center, valign: :center, overflow: :shrink_to_fit
        end
      end
    end
  end
end



Prawn::Document.generate("../boxes/#{width}x#{height}x#{thickness}_box.pdf",
                           :page_size   => "LETTER",
                           :print_scaling => :none,
                           :page_layout => :portrait) do
font_families.update "Pacifico"      => { :normal => "../Pacifico.ttf" },
                     "IceCream Soda" => { :normal => "../ICE-CS__.ttf" },
                     "FFF Tusj"      => { :normal => "../FFF_Tusj.ttf" }

  #points.each_with_index do |p, i|
  #  fill_circle p, 3
  #  draw_text i, at: p
  #end
  # page 1, outline box with cut and fold lines
  stroke do
    cut_lines.each do |x1,y1,x2,y2|
      line [x1, y1], [x2, y2]
    end
  end
  stroke_arc_around points[44], radius: heights[:h165] - heights[:h140], start_angle: 180, end_angle: 270
  stroke_arc_around points[45], radius: heights[:h165] - heights[:h140], start_angle: 90, end_angle: 180

  # notch circle
  fill_color 'FFFFFF'
  stroke_color '000000'
  #bounding_box points[33], width: h, height: w do
    fill_and_stroke_half_circle points[37], radius: 21.6, side: :left
  #end

  stroke do
    dash 5, :space => 5, :phase => 0
    fold_lines.each do |x1,y1,x2,y2|
      line [x1, y1], [x2, y2]
    end
    undash
  end

  # glue boxes
  fill_color 'CCCCCC'
  fill_rectangle points[41], heights[:glue_side], widths[:glue_thick]
  fill_rectangle points[40], heights[:glue_thick], widths[:glue_width]
  fill_rectangle points[38], heights[:glue_flap_thick], widths[:glue_flap_thick]
  fill_rectangle points[39], heights[:glue_flap_thick], widths[:glue_flap_thick]
  fill_color '000000'

  # page 2 with the images
  start_new_page

  font_size 150
  # front image
  render_box_face reverse_points[32], reverse_points[29], background_color: 'CCCCCC',
                  text: "This is the text for the front of the box",
                  text_fill_color: '00FF00',
                  text_stroke_color: 'FF0000',
                  font: 'IceCream Soda',
                  image: "../how_high_can_I_go.png",
                  image_orientation: :sideways_right,
                  text_orientation: :vertical
  #rotate 90, origin: reverse_points[28] do
  #  text_box front_string, at: reverse_points[28], width: w, height: h, align: :center, valign: :center, overflow: :shrink_to_fit
  #end

  # back image - point 61 is the top left corner
  rotate 90, origin: reverse_points[10] do
    # image "../how_high_can_I_go.png", at: reverse_points[10], width: w, height: h
    front_string = "This is the text for the back of the box"
    text_box front_string, at: reverse_points[10], width: w, height: h, align: :center, valign: :center, overflow: :shrink_to_fit
  end

  # bottom - point 13
  rotate 90, origin: reverse_points[13] do
    # image "../logo_golem_arcana_wide.png", at: reverse_points[13], width: w, height: t
    front_string = "This is the Bottom"
    font("Times-Roman") do
      text_box front_string, at: reverse_points[13], width: w, height: t, align: :center, valign: :center, overflow: :shrink_to_fit
    end
  end

  # side 1
  #   vertical image to be rotated - top left is 3
  #rotate 90, origin: points[ 3] do
  #   image filename, at: points[68], width: t, height: h
  #end
  # horizontal image - point 10 is top left
    # image "../logo_golem_arcana_wide.png", at: reverse_points[10], width: h, height: t
    front_string = "This is the Side"
    fill_color "#000000"
    fill_rectangle reverse_points[10], h, t
    fill_color "#FFFFFF"
    font("../ICE-CS__.ttf") do
      text_box front_string, at: reverse_points[10], width: h, height: t, align: :center, valign: :center, overflow: :shrink_to_fit
    end


  # side 2
  #   vertical image - top left is 50
  #   image filename, at: points[50], width: t, height: h
  # horizontal image to be rotated - point 43 is top left
  #rotate 270, origin: points[43] do
    image "../logo_golem_arcana_wide.png", at: reverse_points[28], width: h, height: t
  #end
  # top - point 21
  rotate 270, origin: reverse_points[21] do
    image "../logo_golem_arcana_wide.png", at: reverse_points[21], width: w, height: t
  end

  # flap image - point 19 is the top left corner
  rotate 270, origin: reverse_points[19] do
    image "../cropped_front.png", at: reverse_points[19], width: w, height: h*0.375
  end
  font_size 10
  fill_color '000000'
  #reverse_points.each_with_index do |p, i|
  #  fill_circle p, 3
  #  draw_text i, at: p
  #end
end


