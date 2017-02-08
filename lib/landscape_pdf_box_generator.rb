require "prawn"
require "prawn/measurement_extensions"
require "prawn_shapes"





PAPER_WIDTH = 1100
PAPER_HEIGHT = 850
#  given
height = 3.5
width = 2.5
thickness = 1.00
unit = '"'
bottom_style = :glued
#bottom_style = :tuck


if unit == 'mm'
  h = height.send :mm
  w = width.send :mm
  t = thickness.send :mm
else
  h = height.send :in
  w = width.send :in
  t = thickness.send :in
end
margin_x =  0

right_margin = 720
margin_y = 0
margin_y1 = 7.5 * 72
eighth_inch = 0.125.in
quarter_inch = 0.25.in
three_eighths_inch = 0.375.in
half_inch = 0.5.in
three_quarter_inch = 0.75.in
flap_height = if t > 0.75
                three_quarter_inch
              elsif t < 0.25
                quarter_inch
              else
                t
              end

points = []
widths = {}
heights = {}
cut_lines = []
fold_lines = []
glue_boxes = []
reverse_points = []
reverse_cut_lines = []

reference_starting_x = eighth_inch
reference_starting_y = if bottom_style == :glued
                         eighth_inch + t
                       else
                         eighth_inch + t + flap_height
                       end

widths[:left_edge] = eighth_inch
widths[:left_edge_tuck_flap_indent] = quarter_inch
widths[:left_edge_tuck_flap_indent_2] = three_eighths_inch
widths[:back_face_left_side] = eighth_inch + t
widths[:left_side_flap_cut] = eighth_inch + t + quarter_inch
widths[:right_side_flap_cut] = eighth_inch + t + w - quarter_inch
widths[:back_face_right_side] = eighth_inch + t + w
widths[:right_side_tuck_flap_indent] = 2*t + w - eighth_inch
widths[:right_side_tuck_flap_indent_2] = 2*t + w
widths[:front_face_left_edge] = eighth_inch + 2*t + w
widths[:front_face_right_edge] = eighth_inch + 2*t + 2*w
widths[:notch_center] = eighth_inch + 2*t + 1.5*w
widths[:side_glue_flap_right_edge] = eighth_inch + 3*t + 2*w
widths[:back_left_side_bottom_flap_glue_point] = quarter_inch
widths[:back_right_side_bottom_flap_glue_point] = quarter_inch + t + w
widths[:bottom_glue_flap_glue_point] = quarter_inch + 2*t + w
widths[:side_glue_flap_glue_point] = 2*t + 2*w + quarter_inch

widths[:reverse_left_edge] = right_margin - eighth_inch
widths[:reverse_left_edge_tuck_flap_indent] = right_margin - quarter_inch
widths[:reverse_left_edge_tuck_flap_indent_2] = right_margin - three_eighths_inch
widths[:reverse_back_face_left_side] = right_margin - eighth_inch - t
widths[:reverse_left_side_flap_cut] = right_margin - eighth_inch - t - quarter_inch
widths[:reverse_right_side_flap_cut] = right_margin - eighth_inch - t - w + quarter_inch
widths[:reverse_back_face_right_side] = right_margin - eighth_inch - t - w
widths[:reverse_right_side_tuck_flap_indent] = right_margin - 2*t - w + eighth_inch
widths[:reverse_right_side_tuck_flap_indent_2] = right_margin - 2*t - w
widths[:reverse_front_face_left_edge] = right_margin - eighth_inch - 2*t - w
widths[:reverse_front_face_right_edge] = right_margin - eighth_inch - 2*t - 2*w
widths[:reverse_notch_center] = right_margin - eighth_inch - 2*t - 1.5*w
widths[:reverse_side_glue_flap_right_edge] = right_margin - eighth_inch - 3*t - 2*w
widths[:reverse_back_left_side_bottom_flap_glue_point] = right_margin - quarter_inch
widths[:reverse_back_right_side_bottom_flap_glue_point] = right_margin - quarter_inch - t - w
widths[:reverse_bottom_glue_flap_glue_point] = right_margin - quarter_inch - 2*t - w
widths[:reverse_side_glue_flap_glue_point] = right_margin - 2*t - 2*w - quarter_inch

heights[:glue_patch_on_thickness_sides] = t - quarter_inch
heights[:glue_patch_on_width_sides] = w - quarter_inch
heights[:glue_patch_on_height_sides] = h - quarter_inch

heights[:bottom_edge] = reference_starting_y - t
heights[:faces_bottom_edge] = reference_starting_y
heights[:faces_lower_tuck_flap_fold] = reference_starting_y + h - quarter_inch
heights[:faces_top_edge] = reference_starting_y + h
heights[:side_tuck_flap_before_indent_1] = reference_starting_y + h + eighth_inch
heights[:side_tuck_flap_at_indent_1] = reference_starting_y + h + quarter_inch
heights[:side_tuck_flap_at_indent_2] = reference_starting_y + h + three_quarter_inch
heights[:top_of_top_face] = reference_starting_y + t + h
heights[:start_tuck_flap_corner_rounding] = reference_starting_y + t + h + half_inch
heights[:top_of_tuck_flap] = reference_starting_y + t + h + half_inch + quarter_inch
heights[:top_of_tuck_flap_face] = reference_starting_y + t + 2*h
heights[:bottom_glue_flap_glue_point] = reference_starting_y - eighth_inch
heights[:side_glue_flap_glue_point] = reference_starting_y - eighth_inch + h
heights[:bottom_of_bottom_tuck_flap] = reference_starting_y -t - half_inch - quarter_inch
heights[:start_bottom_tuck_flap_corner_rounding] = reference_starting_y - t - half_inch
heights[:bottom_side_tuck_flap_before_indent_1] = reference_starting_y - eighth_inch
heights[:bottom_side_tuck_flap_at_indent_1] = reference_starting_y - quarter_inch
heights[:bottom_side_tuck_flap_at_indent_2] = reference_starting_y - three_quarter_inch

#points[ 0] = widths[:left_edge], heights[:faces_bottom_edge]
points[ 0] = 0, 0
points[ 1] = widths[:left_edge], heights[:bottom_edge]
points[ 2] = widths[:left_edge], heights[:faces_bottom_edge]
points[ 3] = widths[:left_edge], heights[:faces_top_edge]
points[ 4] = widths[:left_edge], heights[:side_tuck_flap_before_indent_1]
points[ 5] = widths[:left_edge_tuck_flap_indent],   heights[:side_tuck_flap_at_indent_1]
points[ 6] = widths[:left_edge_tuck_flap_indent_2], heights[:side_tuck_flap_at_indent_2]
points[ 7] = widths[:back_face_left_side], heights[:start_tuck_flap_corner_rounding]
points[ 8] = widths[:back_face_left_side], heights[:top_of_top_face]
points[ 9] = widths[:back_face_left_side], heights[:side_tuck_flap_at_indent_2]
points[10] = widths[:back_face_left_side], heights[:faces_top_edge]
points[11] = widths[:left_side_flap_cut], heights[:bottom_edge]
points[12] = widths[:back_face_left_side], heights[:bottom_edge]
points[13] = widths[:back_face_left_side], heights[:faces_bottom_edge]
points[14] = widths[:left_side_flap_cut], heights[:top_of_tuck_flap]
points[15] = widths[:left_side_flap_cut], heights[:top_of_top_face]
points[16] = widths[:right_side_flap_cut], heights[:top_of_tuck_flap]
points[17] = widths[:right_side_flap_cut], heights[:top_of_top_face]
points[18] = widths[:back_face_right_side], heights[:start_tuck_flap_corner_rounding]
points[19] = widths[:back_face_right_side], heights[:top_of_top_face]
points[20] = widths[:back_face_right_side], heights[:side_tuck_flap_at_indent_2]
points[21] = widths[:back_face_right_side], heights[:faces_top_edge]
points[22] = widths[:right_side_flap_cut], heights[:bottom_edge]
points[23] = widths[:back_face_right_side], heights[:bottom_edge]
points[24] = widths[:back_face_right_side], heights[:faces_bottom_edge]
points[25] = widths[:right_side_tuck_flap_indent], heights[:side_tuck_flap_at_indent_2]
points[26] = widths[:right_side_tuck_flap_indent_2], heights[:side_tuck_flap_at_indent_1]
points[27] = widths[:front_face_left_edge], heights[:side_tuck_flap_before_indent_1]
points[28] = widths[:front_face_left_edge], heights[:faces_top_edge]
points[29] = widths[:front_face_left_edge], heights[:faces_bottom_edge]
points[30] = widths[:front_face_left_edge], heights[:bottom_edge]
#points[31] = widths[:front_face_left_edge], heights[:bottom_edge]
points[31] = widths[:front_face_left_edge], 0
points[32] = widths[:front_face_right_edge], heights[:faces_top_edge]
points[33] = widths[:front_face_right_edge], heights[:faces_bottom_edge]
points[34] = widths[:front_face_right_edge], heights[:bottom_edge]
points[35] = widths[:side_glue_flap_right_edge], heights[:faces_top_edge]
points[36] = widths[:side_glue_flap_right_edge], heights[:faces_bottom_edge]
points[37] = widths[:notch_center], heights[:faces_top_edge]
points[38] = widths[:back_left_side_bottom_flap_glue_point] , heights[:bottom_glue_flap_glue_point]
points[39] = widths[:back_right_side_bottom_flap_glue_point], heights[:bottom_glue_flap_glue_point]
points[40] = widths[:bottom_glue_flap_glue_point]           , heights[:bottom_glue_flap_glue_point]
points[41] = widths[:side_glue_flap_glue_point]             , heights[:side_glue_flap_glue_point]
points[42] = widths[:back_face_right_side], heights[:faces_lower_tuck_flap_fold]
points[43] = widths[:back_face_left_side],  heights[:faces_lower_tuck_flap_fold]
points[44] = widths[:right_side_flap_cut], heights[:start_tuck_flap_corner_rounding]
points[45] = widths[:left_side_flap_cut],  heights[:start_tuck_flap_corner_rounding]
points[46] = widths[:front_face_left_edge]+eighth_inch,  heights[:faces_lower_tuck_flap_fold]
points[47] = widths[:back_face_left_side]+eighth_inch,  heights[:faces_top_edge] + eighth_inch
points[48] = widths[:right_side_flap_cut],  heights[:start_bottom_tuck_flap_corner_rounding]
points[49] = widths[:left_side_flap_cut],   heights[:start_bottom_tuck_flap_corner_rounding]
points[50] = widths[:left_side_flap_cut],   heights[:bottom_of_bottom_tuck_flap]
points[51] = widths[:right_side_flap_cut],  heights[:bottom_of_bottom_tuck_flap]
points[52] = widths[:back_face_right_side], heights[:start_bottom_tuck_flap_corner_rounding]
points[53] = widths[:back_face_left_side],  heights[:start_bottom_tuck_flap_corner_rounding]

points[54] = widths[:left_edge],                     heights[:bottom_side_tuck_flap_before_indent_1]
points[55] = widths[:left_edge_tuck_flap_indent],    heights[:bottom_side_tuck_flap_at_indent_1]
points[56] = widths[:left_edge_tuck_flap_indent_2],  heights[:bottom_side_tuck_flap_at_indent_2]
points[57] = widths[:back_face_left_side],           heights[:bottom_side_tuck_flap_at_indent_2]
points[58] = widths[:back_face_right_side],          heights[:bottom_side_tuck_flap_at_indent_2]
points[59] = widths[:right_side_tuck_flap_indent],   heights[:bottom_side_tuck_flap_at_indent_2]
points[60] = widths[:right_side_tuck_flap_indent_2], heights[:bottom_side_tuck_flap_at_indent_1]
points[61] = widths[:front_face_left_edge],          heights[:bottom_side_tuck_flap_before_indent_1]




reverse_points[ 0] = widths[:reverse_left_edge], heights[:bottom_edge]
reverse_points[ 1] = widths[:reverse_left_edge], heights[:bottom_edge]
reverse_points[ 2] = widths[:reverse_left_edge], heights[:faces_bottom_edge]
reverse_points[ 3] = widths[:reverse_left_edge], heights[:faces_top_edge]
reverse_points[ 4] = widths[:reverse_left_edge], heights[:side_tuck_flap_before_indent_1]
reverse_points[ 5] = widths[:reverse_left_edge_tuck_flap_indent],   heights[:side_tuck_flap_at_indent_1]
reverse_points[ 6] = widths[:reverse_left_edge_tuck_flap_indent_2], heights[:side_tuck_flap_at_indent_2]
reverse_points[ 7] = widths[:reverse_back_face_left_side], heights[:start_tuck_flap_corner_rounding]
reverse_points[ 8] = widths[:reverse_back_face_left_side], heights[:top_of_top_face]
reverse_points[ 9] = widths[:reverse_back_face_left_side], heights[:side_tuck_flap_at_indent_2]
reverse_points[10] = widths[:reverse_back_face_left_side], heights[:faces_top_edge]
reverse_points[11] = widths[:reverse_back_face_left_side], heights[:bottom_edge]
reverse_points[12] = widths[:reverse_back_face_left_side], heights[:bottom_edge]
reverse_points[13] = widths[:reverse_back_face_left_side], heights[:faces_bottom_edge]
reverse_points[14] = widths[:reverse_left_side_flap_cut], heights[:top_of_tuck_flap]
reverse_points[15] = widths[:reverse_left_side_flap_cut], heights[:top_of_top_face]
reverse_points[16] = widths[:reverse_right_side_flap_cut], heights[:top_of_tuck_flap]
reverse_points[17] = widths[:reverse_right_side_flap_cut], heights[:top_of_top_face]
reverse_points[18] = widths[:reverse_back_face_right_side], heights[:start_tuck_flap_corner_rounding]
reverse_points[19] = widths[:reverse_back_face_right_side], heights[:top_of_top_face]
reverse_points[20] = widths[:reverse_back_face_right_side], heights[:side_tuck_flap_at_indent_2]
reverse_points[21] = widths[:reverse_back_face_right_side], heights[:faces_top_edge]
reverse_points[22] = widths[:reverse_back_face_right_side], heights[:bottom_edge]
reverse_points[23] = widths[:reverse_back_face_right_side], heights[:bottom_edge]
reverse_points[24] = widths[:reverse_back_face_right_side], heights[:faces_bottom_edge]
reverse_points[25] = widths[:reverse_right_side_tuck_flap_indent], heights[:side_tuck_flap_at_indent_2]
reverse_points[26] = widths[:reverse_right_side_tuck_flap_indent_2], heights[:side_tuck_flap_at_indent_1]
reverse_points[27] = widths[:reverse_front_face_left_edge], heights[:side_tuck_flap_before_indent_1]
reverse_points[28] = widths[:reverse_front_face_left_edge], heights[:faces_top_edge]
reverse_points[29] = widths[:reverse_front_face_left_edge], heights[:faces_bottom_edge]
reverse_points[30] = widths[:reverse_front_face_left_edge], heights[:bottom_edge]
reverse_points[31] = widths[:reverse_front_face_left_edge], heights[:bottom_edge]
reverse_points[32] = widths[:reverse_front_face_right_edge], heights[:faces_top_edge]
reverse_points[33] = widths[:reverse_front_face_right_edge], heights[:faces_bottom_edge]
reverse_points[34] = widths[:reverse_front_face_right_edge], heights[:bottom_edge]
reverse_points[35] = widths[:reverse_side_glue_flap_right_edge], heights[:faces_top_edge]
reverse_points[36] = widths[:reverse_side_glue_flap_right_edge], heights[:faces_bottom_edge]
reverse_points[37] = widths[:reverse_notch_center], heights[:faces_top_edge]
reverse_points[38] = widths[:reverse_back_left_side_bottom_flap_glue_point] , heights[:bottom_glue_flap_glue_point]
reverse_points[39] = widths[:reverse_back_right_side_bottom_flap_glue_point], heights[:bottom_glue_flap_glue_point]
reverse_points[40] = widths[:reverse_bottom_glue_flap_glue_point]           , heights[:bottom_glue_flap_glue_point]
reverse_points[41] = widths[:reverse_side_glue_flap_glue_point]             , heights[:side_glue_flap_glue_point]
reverse_points[42] = widths[:reverse_back_face_right_side], heights[:faces_lower_tuck_flap_fold]
reverse_points[43] = widths[:reverse_back_face_left_side],  heights[:faces_lower_tuck_flap_fold]
reverse_points[44] = widths[:reverse_right_side_flap_cut], heights[:start_tuck_flap_corner_rounding]
reverse_points[45] = widths[:reverse_left_side_flap_cut],  heights[:start_tuck_flap_corner_rounding]
reverse_points[46] = widths[:reverse_back_face_left_side],  heights[:top_of_tuck_flap]
reverse_points[47] = widths[:reverse_back_face_right_side],  heights[:top_of_tuck_flap_face]
reverse_points[48] = widths[:reverse_right_side_flap_cut],  heights[:start_bottom_tuck_flap_corner_rounding]
reverse_points[49] = widths[:reverse_left_side_flap_cut],   heights[:start_bottom_tuck_flap_corner_rounding]
reverse_points[50] = widths[:reverse_left_side_flap_cut],   heights[:bottom_of_bottom_tuck_flap]
reverse_points[51] = widths[:reverse_right_side_flap_cut],  heights[:bottom_of_bottom_tuck_flap]
reverse_points[52] = widths[:reverse_back_face_right_side], heights[:start_bottom_tuck_flap_corner_rounding]
reverse_points[53] = widths[:reverse_back_face_left_side],  heights[:start_bottom_tuck_flap_corner_rounding]
reverse_points[54] = widths[:reverse_left_edge],                     heights[:bottom_side_tuck_flap_before_indent_1]
reverse_points[55] = widths[:reverse_left_edge_tuck_flap_indent],    heights[:bottom_side_tuck_flap_at_indent_1]
reverse_points[56] = widths[:reverse_left_edge_tuck_flap_indent_2],  heights[:bottom_side_tuck_flap_at_indent_2]
reverse_points[57] = widths[:reverse_back_face_left_side],           heights[:bottom_side_tuck_flap_at_indent_2]
reverse_points[58] = widths[:reverse_back_face_right_side],          heights[:bottom_side_tuck_flap_at_indent_2]
reverse_points[59] = widths[:reverse_right_side_tuck_flap_indent],   heights[:bottom_side_tuck_flap_at_indent_2]
reverse_points[60] = widths[:reverse_right_side_tuck_flap_indent_2], heights[:bottom_side_tuck_flap_at_indent_1]
reverse_points[61] = widths[:reverse_front_face_left_edge],          heights[:bottom_side_tuck_flap_before_indent_1]
reverse_points[62] = widths[:reverse_back_face_right_side] - w, heights[:bottom_edge] + h


face_points = {}
face_points[:front_upper_left]  = reverse_points[32]
face_points[:front_lower_right] = reverse_points[29]
face_points[:back_upper_left]  = reverse_points[21]
face_points[:back_lower_right] = reverse_points[13]
face_points[:left_side_upper_left]  = reverse_points[10]
face_points[:left_side_lower_right] = reverse_points[2]
face_points[:right_side_upper_left]  = reverse_points[28]
face_points[:right_side_lower_right] = reverse_points[24]
face_points[:bottom_upper_left]  = reverse_points[24]
face_points[:bottom_lower_right] = reverse_points[12]
face_points[:top_upper_left]  = reverse_points[19]
face_points[:top_lower_right] = reverse_points[10]
face_points[:tuck_flap_upper_left] = reverse_points[47]
face_points[:tuck_flap_lower_right] = reverse_points[8]
face_points[:hidden_tuck_flap_upper_left] = reverse_points[47]
face_points[:hidden_tuck_flap_lower_right] = reverse_points[46]

if bottom_style == :glued
  cut_lines << points[1] + points[11]
  cut_lines << points[1] + points[2]
  cut_lines << points[33] + points[34]
  cut_lines << points[30] + points[34]
  cut_lines << points[29] + points[30]
  cut_lines << points[22] + points[30]
  cut_lines << points[12] + points[23]
else
  cut_lines << points[12] + points[53]
  cut_lines << points[23] + points[52]
  cut_lines << points[50] + points[51]
  cut_lines << points[ 2] + points[54]
  cut_lines << points[54] + points[55]
  cut_lines << points[55] + points[56]
  cut_lines << points[56] + points[57]
  cut_lines << points[58] + points[59]
  cut_lines << points[59] + points[60]
  cut_lines << points[60] + points[61]
  cut_lines << points[61] + points[29]
end
cut_lines << points[2] + points[4]
cut_lines << points[4] + points[5]
cut_lines << points[5] + points[6]
cut_lines << points[6] + points[9]
cut_lines << points[8] + points[15]
cut_lines << points[12] + points[13]
cut_lines << points[7] + points[43]
cut_lines << points[14] + points[16]
cut_lines << points[18] + points[42]
cut_lines << points[20] + points[25]
cut_lines << points[25] + points[26]
cut_lines << points[26] + points[27]
cut_lines << points[27] + points[28]
cut_lines << points[28] + points[35]
cut_lines << points[35] + points[36]
cut_lines << points[33] + points[36]
cut_lines << points[24] + points[23]
cut_lines << points[17] + points[19]
cut_lines << points[11] + points[12]
cut_lines << points[22] + points[23]

reverse_cut_lines << reverse_points[1]  + reverse_points[4]
reverse_cut_lines << reverse_points[4]  + reverse_points[5]
reverse_cut_lines << reverse_points[5]  + reverse_points[6]
reverse_cut_lines << reverse_points[6]  + reverse_points[9]
reverse_cut_lines << reverse_points[8]  + reverse_points[15]
reverse_cut_lines << reverse_points[1]  + reverse_points[11]
reverse_cut_lines << reverse_points[12] + reverse_points[13]
reverse_cut_lines << reverse_points[7]  + reverse_points[43]
reverse_cut_lines << reverse_points[14] + reverse_points[16]
reverse_cut_lines << reverse_points[18] + reverse_points[42]
reverse_cut_lines << reverse_points[20] + reverse_points[25]
reverse_cut_lines << reverse_points[25] + reverse_points[26]
reverse_cut_lines << reverse_points[26] + reverse_points[27]
reverse_cut_lines << reverse_points[27] + reverse_points[28]
reverse_cut_lines << reverse_points[28] + reverse_points[35]
reverse_cut_lines << reverse_points[35] + reverse_points[36]
reverse_cut_lines << reverse_points[33] + reverse_points[36]
reverse_cut_lines << reverse_points[33] + reverse_points[34]
reverse_cut_lines << reverse_points[31] + reverse_points[34]
reverse_cut_lines << reverse_points[29] + reverse_points[31]
reverse_cut_lines << reverse_points[24] + reverse_points[23]
reverse_cut_lines << reverse_points[22] + reverse_points[30]
reverse_cut_lines << reverse_points[12] + reverse_points[23]
reverse_cut_lines << reverse_points[17] + reverse_points[19]

if bottom_style == :glued
else
  fold_lines << points[11] + points[22]
end
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
      stroke_color args[:background_color]
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
        font (args[:font] || "Helvetica"), size: (args[:font_size] || 150) do
          text_box args[:text], at: point, width: w, height: h, mode: text_mode,
                   align: :center, valign: :center, overflow: :shrink_to_fit
        end
      end
    end
  end
end



Prawn::Document.generate("../boxes/landscape_#{width}x#{height}x#{thickness}_box.pdf",
                           :page_size   => "LETTER",
                           :print_scaling => :none,
                           :page_layout => :landscape) do
font_families.update "Pacifico"      => { :normal => "../Pacifico.ttf" },
                     "IceCream Soda" => { :normal => "../ICE-CS__.ttf" },
                     "FFF Tusj"      => { :normal => "../FFF_Tusj.ttf" }

  # page 1, outline box with cut and fold lines
  font_size 10
    text =<<EOT
This tuckbox was generated by software written by Michael King.
Source code is available at http://github.com/kingmt/tuckbox_generator and is licensed under the GPL

This implementation is inspired by the generator written by Craig P.  Forbes at http://www.cpforbes.net/tuckbox.

The box is based on a design by Elliott C. Evans. See his page, http://www.ee0r.com/boxes/ for more information and assembly instructions.

Go to
http://www.tuckbox-generator.net to generate more box templates.
--Michael
EOT
  text_box text, at: points[46], width: w - quarter_inch, height: h - 1.in, overflow: :shrink_to_fit
  text_box "#{width}#{unit} x #{height}#{unit} x #{thickness}#{unit}", at: points[10], width: w, height: h,
                   align: :center, valign: :center
  font 'Helvetica', size: 5 do
    text_box 'http://www.tuckbox-generator.net', at: points[47], width: w, height: eighth_inch, overflow: :shrink_to_fit
  end
   points.each_with_index do |p, i|
     # puts "Point #{i} = #{p.inspect}"
     fill_circle p, 3
     draw_text i, at: p
   end
  stroke do
    cut_lines.each do |x1,y1,x2,y2|
      line [x1, y1], [x2, y2]
    end
  end
  stroke_arc_around points[44], radius: quarter_inch, start_angle: 0, end_angle: 90
  stroke_arc_around points[45], radius: quarter_inch, start_angle: 90, end_angle: 180
  if bottom_style == :glued
  else
    stroke_arc_around points[49], radius: quarter_inch, start_angle: 180, end_angle: 270
    stroke_arc_around points[48], radius: quarter_inch, start_angle: 270, end_angle: 0
  end

  # notch circle
  fill_color 'FFFFFF'
  stroke_color '000000'
  #bounding_box points[33], width: h, height: w do
   pie_slice points[37], :radius => quarter_inch,
             :start_angle => 180, :end_angle => 0

  #end

    dash 5, :space => 5, :phase => 0
  stroke do
    fold_lines.each do |x1,y1,x2,y2|
      line [x1, y1], [x2, y2]
    end
  end
    undash


  # glue boxes
  fill_color 'CCCCCC'
  fill_rectangle points[41], heights[:glue_patch_on_thickness_sides], heights[:glue_patch_on_height_sides]
  if bottom_style == :glued
    fill_rectangle points[40], heights[:glue_patch_on_width_sides], heights[:glue_patch_on_thickness_sides]
    fill_rectangle points[38], heights[:glue_patch_on_thickness_sides], heights[:glue_patch_on_thickness_sides]
    fill_rectangle points[39], heights[:glue_patch_on_thickness_sides], heights[:glue_patch_on_thickness_sides]
  end
  fill_color '000000'

  # page 2 with the images
  start_new_page

  font_size 150
  # FRONT
  render_box_face face_points[:front_upper_left], face_points[:front_lower_right], background_color: 'CCCCCC',
                  text: "FROMT FRONT FRONT FRONT",
                  text_fill_color: '00FF00',
                  text_stroke_color: 'FF0000',
                  font: 'IceCream Soda',
                  #image: "../how_high_can_I_go.png",
                  image_orientation: :vertical,
                  text_orientation: :vertical
      ## reflect the front onto the tuck flap
  render_box_face face_points[:tuck_flap_upper_left], face_points[:tuck_flap_lower_right], background_color: 'CCCCCC',
                  text: "FROMT FRONT FRONT FRONT",
                  text_fill_color: '00FF00',
                  text_stroke_color: 'FF0000',
                  font: 'IceCream Soda',
                  #image: "../how_high_can_I_go.png",
                  # these orientations must be opposite of the front
                  image_orientation: :upside_down,
                  text_orientation:  :upside_down
  ## hide remainder
  fill_color 'FFFFFF'
  fill_rectangle face_points[:tuck_flap_upper_left], w, h-t

  if bottom_style == :tuck
    # reflect the bottom of the face onto the bottom tuckflap
    rotate 180, origin: reverse_points[23] do
      render_box_face reverse_points[62],
                      reverse_points[23],
                      background_color: 'CCCCCC',
                      text: "FROMT FRONT FRONT FRONT",
                      text_fill_color: '00FF00',
                      text_stroke_color: 'FF0000',
                      font: 'IceCream Soda',
                      #image: "../how_high_can_I_go.png",
                      # these orientations must be opposite of the front
                      image_orientation: :vertical,
                      text_orientation:  :vertical
        ## hide remainder
        fill_color 'FFFFFF'
        fill_rectangle reverse_points[62], w, h-t
    end
  end

  # BACK
  render_box_face face_points[:back_upper_left], face_points[:back_lower_right], background_color: 'CCCCCC',
                  text: "TOP BACK BACK BACK BACK BACK BACK END",
                  text_fill_color: '00FF00',
                  text_stroke_color: 'FF0000',
                  font: 'IceCream Soda',
                  #image: "../how_high_can_I_go.png",
                  image_orientation: :vertical,
                  text_orientation: :vertical

  # BOTTOM
  render_box_face face_points[:bottom_upper_left], face_points[:bottom_lower_right], background_color: 'CC0000',
                  text: "This is the BOTTOM",
                  text_fill_color: '00FF00',
                  #text_stroke_color: 'FF0000',
                  font: 'Pacifico',
                  font_size: 15,
                  #image: "../how_high_can_I_go.png",
                  image_orientation: :vertical,
                  text_orientation: :vertical

  ## SIDE 1
  render_box_face face_points[:left_side_upper_left], face_points[:left_side_lower_right], background_color: 'CCCCCC',
                  text: "This is the LEFT SIDE",
                  text_fill_color: '00FF00',
                  text_stroke_color: 'FF0000',
                  font: 'Pacifico',
                  #image: "../how_high_can_I_go.png",
                  image_orientation: :vertical,
                  text_orientation: :sideways_left


  ## SIDE 2
  render_box_face face_points[:right_side_upper_left], face_points[:right_side_lower_right], background_color: 'CCCCCC',
                  text: "This is the RIGHT SIDE",
                  text_fill_color: '00FF00',
                  text_stroke_color: 'FF0000',
                  font: 'Pacifico',
                  #image: "../how_high_can_I_go.png",
                  image_orientation: :vertical,
                  text_orientation: :sideways_right

  ## TOP
  render_box_face face_points[:top_upper_left], face_points[:top_lower_right], background_color: 'CC0000',
                  text: "This is the TOP",
                  text_fill_color: '00FF00',
                  #text_stroke_color: 'FF0000',
                  font: 'FFF Tusj',
                  # font_size: 15,
                  #image: "../how_high_can_I_go.png",
                  image_orientation: :vertical,
                  text_orientation: :upside_down

  ## SIDE TUCK FLAPS
  fill_color '0000CC'
  fill_polygon reverse_points[ 9],
               reverse_points[ 6],
               reverse_points[ 5],
               reverse_points[ 4],
               reverse_points[ 3],
               reverse_points[10]
  fill_polygon reverse_points[25],
               reverse_points[26],
               reverse_points[27],
               reverse_points[28],
               reverse_points[21],
               reverse_points[20]
  if bottom_style == :tuck
    fill_polygon reverse_points[ 2],
                 reverse_points[54],
                 reverse_points[55],
                 reverse_points[56],
                 reverse_points[57],
                 reverse_points[13]
    fill_polygon reverse_points[24],
                 reverse_points[58],
                 reverse_points[59],
                 reverse_points[60],
                 reverse_points[61],
                 reverse_points[29]
  end


  font_size 10
  fill_color '000000'
  reverse_points.each_with_index do |p, i|
    # puts "Reverse Point #{i} = #{p.inspect}"
    fill_circle p, 3
    draw_text i, at: p
  end
end


