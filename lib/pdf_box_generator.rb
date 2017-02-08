require "prawn"
require "prawn/measurement_extensions"
require "prawn_shapes"





PAPER_WIDTH = 850
PAPER_HEIGHT = 1100
#  given
height = 3.5
width = 1.5
thickness = 0.8
unit = '"'
#bottom_style = :glued
bottom_style = :tuck
offset = {}

if unit == 'mm'
  h = height.send :mm
  w = width.send :mm
  t = thickness.send :mm
else
  h = height.send :in
  w = width.send :in
  t = thickness.send :in
end

right_margin = 7.5.in
top_margin = 10.in
EIGHTH_INCH = 0.125.in
QUARTER_INCH = 0.25.in
THREE_EIGHTHS_INCH = 0.375.in
HALF_INCH = 0.5.in
THREE_QUARTER_INCH = 0.75.in
flap_height = 0
if t > THREE_QUARTER_INCH
  flap_height = THREE_QUARTER_INCH
elsif t < QUARTER_INCH
  flap_height = QUARTER_INCH
else
  flap_height = t
end
tuck_flap_height = [t, flap_height, QUARTER_INCH].min

offset[:green] = 0
offset[:red] = 9
# take blue/green offset into account
horizontal_offset = 0
if offset[:green]
  horizontal_offset = offset[:green].send(:mm)
elsif offset[:blue]
  horizontal_offset = offset[:blue].send(:mm)
end

#take red/black offset into account
vertical_offset = 0
if offset[:black]
  vertical_offset = offset[:black].send(:mm)
elsif offset[:red]
  vertical_offset = offset[:red].send(:mm)
end

total_box_height = h + 2*t + flap_height + EIGHTH_INCH + horizontal_offset
if bottom_style == :tuck
  if total_box_height + flap_height > right_margin
    bottom_style = :glued
  else
    total_box_height += flap_height
  end
end
if total_box_height > right_margin
  puts "ERROR! box is too tall!"
end
total_box_width = 2*w + 3*t + EIGHTH_INCH + vertical_offset
if total_box_width > top_margin
  puts "ERROR! box is too wide!"
end

reference_starting_x = if bottom_style == :glued
                         EIGHTH_INCH + t
                       else
                         EIGHTH_INCH + t + flap_height
                       end
reverse_starting_x = right_margin - reference_starting_x

reference_starting_y = EIGHTH_INCH
reverse_starting_y = EIGHTH_INCH

# take blue/green offset into account
if offset[:green]
  reference_starting_x += horizontal_offset
elsif offset[:blue]
  reverse_starting_x -= horizontal_offset
end

#take red/black offset into account
if offset[:black]
  reference_starting_y += vertical_offset
elsif offset[:red]
  reverse_starting_y += vertical_offset
end

points = []
heights = {}
widths = {}
cut_lines = []
fold_lines = []
glue_boxes = []
reverse_points = []
reverse_cut_lines = []


heights[:left_edge] = reference_starting_y
heights[:left_edge_tuck_flap_indent] = reference_starting_y + EIGHTH_INCH
heights[:left_edge_tuck_flap_indent_2] = reference_starting_y + tuck_flap_height
heights[:back_face_left_side] = reference_starting_y + t
heights[:left_side_flap_cut] = reference_starting_y + t + QUARTER_INCH
heights[:right_side_flap_cut] = reference_starting_y + t + w - QUARTER_INCH
heights[:back_face_right_side] = reference_starting_y + t + w
heights[:right_side_tuck_flap_indent] = reference_starting_y + 2*t + w - tuck_flap_height
heights[:right_side_tuck_flap_indent_2] = reference_starting_y + 2*t + w - EIGHTH_INCH
heights[:front_face_left_edge] = reference_starting_y + 2*t + w
heights[:front_face_right_edge] = reference_starting_y + 2*t + 2*w
heights[:notch_center] = reference_starting_y + 2*t + 1.5*w
heights[:side_glue_flap_right_edge] = reference_starting_y + 3*t + 2*w
heights[:back_left_side_bottom_flap_glue_point] = reference_starting_y - EIGHTH_INCH + t
heights[:back_right_side_bottom_flap_glue_point] = reference_starting_y - EIGHTH_INCH + 2*t + w
heights[:bottom_glue_flap_glue_point] = reference_starting_y - EIGHTH_INCH + 2*t + 2*w
heights[:side_glue_flap_glue_point] = reference_starting_y - EIGHTH_INCH + 3*t + 2*w

heights[:reverse_left_edge] = reverse_starting_y
heights[:reverse_left_edge_tuck_flap_indent] = reverse_starting_y + EIGHTH_INCH
heights[:reverse_left_edge_tuck_flap_indent_2] = reverse_starting_y + tuck_flap_height
heights[:reverse_back_face_left_side] = reverse_starting_y + t
heights[:reverse_left_side_flap_cut] = reverse_starting_y + t + QUARTER_INCH
heights[:reverse_right_side_flap_cut] = reverse_starting_y + t + w - QUARTER_INCH
heights[:reverse_back_face_right_side] = reverse_starting_y + t + w
heights[:reverse_right_side_tuck_flap_indent] = reverse_starting_y + 2*t + w - tuck_flap_height
heights[:reverse_right_side_tuck_flap_indent_2] = reverse_starting_y + 2*t + w - EIGHTH_INCH
heights[:reverse_front_face_left_edge] = reverse_starting_y + 2*t + w
heights[:reverse_front_face_right_edge] = reverse_starting_y + 2*t + 2*w
heights[:reverse_notch_center] = reverse_starting_y + 2*t + 1.5*w
heights[:reverse_side_glue_flap_right_edge] = reverse_starting_y + 3*t + 2*w
heights[:reverse_back_left_side_bottom_flap_glue_point] = reverse_starting_y - EIGHTH_INCH + t
heights[:reverse_back_right_side_bottom_flap_glue_point] = reverse_starting_y - EIGHTH_INCH + 2*t + w
heights[:reverse_bottom_glue_flap_glue_point] = reverse_starting_y - EIGHTH_INCH + 2*t + 2*w
heights[:reverse_side_glue_flap_glue_point] = reverse_starting_y - EIGHTH_INCH + 3*t + 2*w

widths[:glue_patch_on_thickness_sides] = t - QUARTER_INCH
widths[:glue_patch_on_width_sides] = w - QUARTER_INCH
widths[:glue_patch_on_height_sides] = h - QUARTER_INCH

widths[:bottom_edge] = reference_starting_x - t
widths[:faces_bottom_edge] = reference_starting_x
widths[:faces_lower_tuck_flap_fold] = reference_starting_x + h - QUARTER_INCH
widths[:faces_top_edge] = reference_starting_x + h
widths[:side_tuck_flap_before_indent_1] = reference_starting_x + h + EIGHTH_INCH
widths[:side_tuck_flap_at_indent_1] = reference_starting_x + h + tuck_flap_height
widths[:side_tuck_flap_at_indent_2] = reference_starting_x + h + flap_height
widths[:top_of_top_face] = reference_starting_x + t + h
widths[:start_tuck_flap_corner_rounding] = reference_starting_x + t + h + flap_height
widths[:top_of_tuck_flap] = reference_starting_x + t + h + flap_height + QUARTER_INCH
widths[:top_of_tuck_flap_face] = reference_starting_x + t + 2*h
widths[:bottom_glue_flap_glue_point] = reference_starting_x - t + EIGHTH_INCH
widths[:side_glue_flap_glue_point] = reference_starting_x + EIGHTH_INCH
widths[:bottom_of_bottom_tuck_flap] = reference_starting_x - t - flap_height - QUARTER_INCH
widths[:start_bottom_tuck_flap_corner_rounding] = reference_starting_x - t - flap_height
widths[:bottom_side_tuck_flap_before_indent_1] = reference_starting_x - EIGHTH_INCH
widths[:bottom_side_tuck_flap_at_indent_1] = reference_starting_x - tuck_flap_height
widths[:bottom_side_tuck_flap_at_indent_2] = reference_starting_x - flap_height

widths[:reverse_bottom_edge] = reverse_starting_x + t
widths[:reverse_faces_bottom_edge] = reverse_starting_x
widths[:reverse_faces_lower_tuck_flap_fold] = reverse_starting_x - h + QUARTER_INCH
widths[:reverse_faces_top_edge] = reverse_starting_x - h
widths[:reverse_side_tuck_flap_before_indent_1] = reverse_starting_x - h - EIGHTH_INCH
widths[:reverse_side_tuck_flap_at_indent_1] = reverse_starting_x - h - tuck_flap_height
widths[:reverse_side_tuck_flap_at_indent_2] = reverse_starting_x - h - flap_height
widths[:reverse_top_of_top_face] = reverse_starting_x - t - h
widths[:reverse_start_tuck_flap_corner_rounding] = reverse_starting_x - t - h - flap_height
widths[:reverse_top_of_tuck_flap] = reverse_starting_x - t - h - flap_height - QUARTER_INCH
widths[:reverse_top_of_tuck_flap_face] = reverse_starting_x - t - 2*h
widths[:reverse_bottom_glue_flap_glue_point] = reverse_starting_x + EIGHTH_INCH
widths[:reverse_side_glue_flap_glue_point] = reverse_starting_x + EIGHTH_INCH - h
widths[:reverse_bottom_of_bottom_tuck_flap] = reverse_starting_x + t + flap_height + QUARTER_INCH
widths[:reverse_start_bottom_tuck_flap_corner_rounding] = reverse_starting_x + t + flap_height
widths[:reverse_bottom_side_tuck_flap_before_indent_1] = reverse_starting_x + EIGHTH_INCH
widths[:reverse_bottom_side_tuck_flap_at_indent_1] = reverse_starting_x + tuck_flap_height
widths[:reverse_bottom_side_tuck_flap_at_indent_2] = reverse_starting_x + flap_height

points[ 0] = widths[:start_tuck_flap_corner_rounding], heights[:front_face_right_edge]
points[ 1] = widths[:bottom_edge], heights[:left_edge]
points[ 2] = widths[:faces_bottom_edge], heights[:left_edge]
points[ 3] = widths[:faces_top_edge], heights[:left_edge]
points[ 4] = widths[:side_tuck_flap_before_indent_1], heights[:left_edge]
points[ 5] = widths[:side_tuck_flap_at_indent_1], heights[:left_edge_tuck_flap_indent]
points[ 6] = widths[:side_tuck_flap_at_indent_2], heights[:left_edge_tuck_flap_indent_2]
points[ 7] = widths[:start_tuck_flap_corner_rounding], heights[:back_face_left_side]
points[ 8] = widths[:top_of_top_face], heights[:back_face_left_side]
points[ 9] = widths[:side_tuck_flap_at_indent_2], heights[:back_face_left_side]
points[10] = widths[:faces_top_edge], heights[:back_face_left_side]
points[11] = widths[:bottom_edge], heights[:left_side_flap_cut]
points[12] = widths[:bottom_edge], heights[:back_face_left_side]
points[13] = widths[:faces_bottom_edge], heights[:back_face_left_side]
points[14] = widths[:top_of_tuck_flap], heights[:left_side_flap_cut]
points[15] = widths[:top_of_top_face], heights[:left_side_flap_cut]
points[16] = widths[:top_of_tuck_flap], heights[:right_side_flap_cut]
points[17] = widths[:top_of_top_face], heights[:right_side_flap_cut]
points[18] = widths[:start_tuck_flap_corner_rounding], heights[:back_face_right_side]
points[19] = widths[:top_of_top_face], heights[:back_face_right_side]
points[20] = widths[:side_tuck_flap_at_indent_2], heights[:back_face_right_side]
points[21] = widths[:faces_top_edge], heights[:back_face_right_side]
points[22] = widths[:bottom_edge], heights[:right_side_flap_cut]
points[23] = widths[:bottom_edge], heights[:back_face_right_side]
points[24] = widths[:faces_bottom_edge], heights[:back_face_right_side]
points[25] = widths[:side_tuck_flap_at_indent_2], heights[:right_side_tuck_flap_indent]
points[26] = widths[:side_tuck_flap_at_indent_1], heights[:right_side_tuck_flap_indent_2]
points[27] = widths[:side_tuck_flap_before_indent_1], heights[:front_face_left_edge]
points[28] = widths[:faces_top_edge], heights[:front_face_left_edge]
points[29] = widths[:faces_bottom_edge], heights[:front_face_left_edge]
points[30] = widths[:bottom_edge], heights[:front_face_left_edge]
points[31] = widths[:start_tuck_flap_corner_rounding], heights[:notch_center]
points[32] = widths[:faces_top_edge], heights[:front_face_right_edge]
points[33] = widths[:faces_bottom_edge], heights[:front_face_right_edge]
points[34] = widths[:bottom_edge], heights[:front_face_right_edge]
points[35] = widths[:faces_top_edge], heights[:side_glue_flap_right_edge]
points[36] = widths[:faces_bottom_edge], heights[:side_glue_flap_right_edge]
points[37] = widths[:faces_top_edge], heights[:notch_center]
points[38] = widths[:bottom_glue_flap_glue_point], heights[:back_left_side_bottom_flap_glue_point]
points[39] = widths[:bottom_glue_flap_glue_point], heights[:back_right_side_bottom_flap_glue_point]
points[40] = widths[:bottom_glue_flap_glue_point], heights[:bottom_glue_flap_glue_point]
points[41] = widths[:side_glue_flap_glue_point], heights[:side_glue_flap_glue_point]
points[42] = widths[:faces_lower_tuck_flap_fold], heights[:back_face_right_side]
points[43] = widths[:faces_lower_tuck_flap_fold], heights[:back_face_left_side]
points[44] = widths[:start_tuck_flap_corner_rounding], heights[:right_side_flap_cut]
points[45] = widths[:start_tuck_flap_corner_rounding], heights[:left_side_flap_cut]
points[46] = widths[:faces_lower_tuck_flap_fold] - EIGHTH_INCH, heights[:front_face_right_edge] - EIGHTH_INCH
points[47] = widths[:faces_top_edge] + EIGHTH_INCH, heights[:back_face_right_side]-EIGHTH_INCH
points[48] = widths[:start_bottom_tuck_flap_corner_rounding], heights[:right_side_flap_cut]
points[49] = widths[:start_bottom_tuck_flap_corner_rounding], heights[:left_side_flap_cut]
points[50] = widths[:bottom_of_bottom_tuck_flap], heights[:left_side_flap_cut]
points[51] = widths[:bottom_of_bottom_tuck_flap], heights[:right_side_flap_cut]
points[52] = widths[:start_bottom_tuck_flap_corner_rounding], heights[:back_face_right_side]
points[53] = widths[:start_bottom_tuck_flap_corner_rounding], heights[:back_face_left_side]
points[54] = widths[:bottom_side_tuck_flap_before_indent_1], heights[:left_edge]
points[55] = widths[:bottom_side_tuck_flap_at_indent_1], heights[:left_edge_tuck_flap_indent]
points[56] = widths[:bottom_side_tuck_flap_at_indent_2], heights[:left_edge_tuck_flap_indent_2]
points[57] = widths[:bottom_side_tuck_flap_at_indent_2], heights[:back_face_left_side]
points[58] = widths[:bottom_side_tuck_flap_at_indent_2], heights[:back_face_right_side]
points[59] = widths[:bottom_side_tuck_flap_at_indent_2], heights[:right_side_tuck_flap_indent]
points[60] = widths[:bottom_side_tuck_flap_at_indent_1], heights[:right_side_tuck_flap_indent_2]
points[61] = widths[:bottom_side_tuck_flap_before_indent_1], heights[:front_face_left_edge]



reverse_points[ 0] = widths[:reverse_start_tuck_flap_corner_rounding], heights[:reverse_front_face_right_edge]
reverse_points[ 1] = widths[:reverse_bottom_edge], heights[:reverse_left_edge]
reverse_points[ 2] = widths[:reverse_faces_bottom_edge], heights[:reverse_left_edge]
reverse_points[ 3] = widths[:reverse_faces_top_edge], heights[:reverse_left_edge]
reverse_points[ 4] = widths[:reverse_side_tuck_flap_before_indent_1], heights[:reverse_left_edge]
reverse_points[ 5] = widths[:reverse_side_tuck_flap_at_indent_1], heights[:reverse_left_edge_tuck_flap_indent]
reverse_points[ 6] = widths[:reverse_side_tuck_flap_at_indent_2], heights[:reverse_left_edge_tuck_flap_indent_2]
reverse_points[ 7] = widths[:reverse_start_tuck_flap_corner_rounding], heights[:reverse_back_face_left_side]
reverse_points[ 8] = widths[:reverse_top_of_top_face], heights[:reverse_back_face_left_side]
reverse_points[ 9] = widths[:reverse_side_tuck_flap_at_indent_2], heights[:reverse_back_face_left_side]
reverse_points[10] = widths[:reverse_faces_top_edge], heights[:reverse_back_face_left_side]
reverse_points[11] = widths[:reverse_bottom_edge], heights[:reverse_left_side_flap_cut]
reverse_points[12] = widths[:reverse_bottom_edge], heights[:reverse_back_face_left_side]
reverse_points[13] = widths[:reverse_faces_bottom_edge], heights[:reverse_back_face_left_side]
reverse_points[14] = widths[:reverse_top_of_tuck_flap], heights[:reverse_left_side_flap_cut]
reverse_points[15] = widths[:reverse_top_of_top_face], heights[:reverse_left_side_flap_cut]
reverse_points[16] = widths[:reverse_top_of_tuck_flap], heights[:reverse_right_side_flap_cut]
reverse_points[17] = widths[:reverse_top_of_top_face], heights[:reverse_right_side_flap_cut]
reverse_points[18] = widths[:reverse_start_tuck_flap_corner_rounding], heights[:reverse_back_face_right_side]
reverse_points[19] = widths[:reverse_top_of_top_face], heights[:reverse_back_face_right_side]
reverse_points[20] = widths[:reverse_side_tuck_flap_at_indent_2], heights[:reverse_back_face_right_side]
reverse_points[21] = widths[:reverse_faces_top_edge], heights[:reverse_back_face_right_side]
reverse_points[22] = widths[:reverse_bottom_edge], heights[:reverse_right_side_flap_cut]
reverse_points[23] = widths[:reverse_bottom_edge], heights[:reverse_back_face_right_side]
reverse_points[24] = widths[:reverse_faces_bottom_edge], heights[:reverse_back_face_right_side]
reverse_points[25] = widths[:reverse_side_tuck_flap_at_indent_2], heights[:reverse_right_side_tuck_flap_indent]
reverse_points[26] = widths[:reverse_side_tuck_flap_at_indent_1], heights[:reverse_right_side_tuck_flap_indent_2]
reverse_points[27] = widths[:reverse_side_tuck_flap_before_indent_1], heights[:reverse_front_face_left_edge]
reverse_points[28] = widths[:reverse_faces_top_edge], heights[:reverse_front_face_left_edge]
reverse_points[29] = widths[:reverse_faces_bottom_edge], heights[:reverse_front_face_left_edge]
reverse_points[30] = widths[:reverse_bottom_edge], heights[:reverse_front_face_left_edge]
reverse_points[31] = widths[:reverse_start_tuck_flap_corner_rounding], heights[:reverse_notch_center]
reverse_points[32] = widths[:reverse_faces_top_edge], heights[:reverse_front_face_right_edge]
reverse_points[33] = widths[:reverse_faces_bottom_edge], heights[:reverse_front_face_right_edge]
reverse_points[34] = widths[:reverse_bottom_edge], heights[:reverse_front_face_right_edge]
reverse_points[35] = widths[:reverse_faces_top_edge], heights[:reverse_side_glue_flap_right_edge]
reverse_points[36] = widths[:reverse_faces_bottom_edge], heights[:reverse_side_glue_flap_right_edge]
reverse_points[37] = widths[:reverse_faces_top_edge], heights[:reverse_notch_center]
reverse_points[38] = widths[:reverse_bottom_glue_flap_glue_point], heights[:reverse_back_left_side_bottom_flap_glue_point]
reverse_points[39] = widths[:reverse_bottom_glue_flap_glue_point], heights[:reverse_back_right_side_bottom_flap_glue_point]
reverse_points[40] = widths[:reverse_bottom_glue_flap_glue_point], heights[:reverse_bottom_glue_flap_glue_point]
reverse_points[41] = widths[:reverse_side_glue_flap_glue_point], heights[:reverse_side_glue_flap_glue_point]
reverse_points[42] = widths[:reverse_faces_lower_tuck_flap_fold], heights[:reverse_back_face_right_side]
reverse_points[43] = widths[:reverse_faces_lower_tuck_flap_fold], heights[:reverse_back_face_left_side]
reverse_points[44] = widths[:reverse_start_tuck_flap_corner_rounding], heights[:reverse_right_side_flap_cut]
reverse_points[45] = widths[:reverse_start_tuck_flap_corner_rounding], heights[:reverse_left_side_flap_cut]
reverse_points[46] = widths[:reverse_faces_lower_tuck_flap_fold], heights[:reverse_front_face_left_edge]+EIGHTH_INCH
reverse_points[47] = widths[:reverse_faces_top_edge] + EIGHTH_INCH, heights[:reverse_back_face_left_side]+EIGHTH_INCH
reverse_points[48] = widths[:reverse_start_bottom_tuck_flap_corner_rounding], heights[:reverse_right_side_flap_cut]
reverse_points[49] = widths[:reverse_start_bottom_tuck_flap_corner_rounding], heights[:reverse_left_side_flap_cut]
reverse_points[50] = widths[:reverse_bottom_of_bottom_tuck_flap], heights[:reverse_left_side_flap_cut]
reverse_points[51] = widths[:reverse_bottom_of_bottom_tuck_flap], heights[:reverse_right_side_flap_cut]
reverse_points[52] = widths[:reverse_start_bottom_tuck_flap_corner_rounding], heights[:reverse_back_face_right_side]
reverse_points[53] = widths[:reverse_start_bottom_tuck_flap_corner_rounding], heights[:reverse_back_face_left_side]
reverse_points[54] = widths[:reverse_bottom_side_tuck_flap_before_indent_1], heights[:reverse_left_edge]
reverse_points[55] = widths[:reverse_bottom_side_tuck_flap_at_indent_1], heights[:reverse_left_edge_tuck_flap_indent]
reverse_points[56] = widths[:reverse_bottom_side_tuck_flap_at_indent_2], heights[:reverse_left_edge_tuck_flap_indent_2]
reverse_points[57] = widths[:reverse_bottom_side_tuck_flap_at_indent_2], heights[:reverse_back_face_left_side]
reverse_points[58] = widths[:reverse_bottom_side_tuck_flap_at_indent_2], heights[:reverse_back_face_right_side]
reverse_points[59] = widths[:reverse_bottom_side_tuck_flap_at_indent_2], heights[:reverse_right_side_tuck_flap_indent]
reverse_points[60] = widths[:reverse_bottom_side_tuck_flap_at_indent_1], heights[:reverse_right_side_tuck_flap_indent_2]
reverse_points[61] = widths[:reverse_bottom_side_tuck_flap_before_indent_1], heights[:reverse_front_face_left_edge]


face_points = {}
face_points[:back] = reverse_points[21], reverse_points[13]
face_points[:front]  = reverse_points[32], reverse_points[29]
face_points[:left_side]  = reverse_points[10], reverse_points[2]
face_points[:right_side]  = reverse_points[28], reverse_points[24]
face_points[:bottom]  = reverse_points[24], reverse_points[12]
face_points[:top]  = reverse_points[19], reverse_points[10]
center_of_the_top = (reverse_points[19].first + reverse_points[10].first)/2,
                    (reverse_points[19].last + reverse_points[10].last)/2
center_of_the_bottom = (reverse_points[24].first + reverse_points[12].first)/2,
                       (reverse_points[24].last + reverse_points[12].last)/2
face_points[:tuck_flap] = reverse_points[19], reverse_points[13]
face_points[:hidden_tuck_flap] = reverse_points[47], reverse_points[46]

if bottom_style == :glued
  cut_lines << points[1] + points[11]
  cut_lines << points[1] + points[2]
  cut_lines << points[33] + points[34]
  cut_lines << points[30] + points[34]
  cut_lines << points[29] + points[30]
  cut_lines << points[22] + points[30]
  cut_lines << points[12] + points[23]
else
  cut_lines << points[33] + points[29]
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

# reverse_cut_lines << reverse_points[1]  + reverse_points[4]
# reverse_cut_lines << reverse_points[4]  + reverse_points[5]
# reverse_cut_lines << reverse_points[5]  + reverse_points[6]
# reverse_cut_lines << reverse_points[6]  + reverse_points[9]
# reverse_cut_lines << reverse_points[8]  + reverse_points[15]
# reverse_cut_lines << reverse_points[1]  + reverse_points[11]
# reverse_cut_lines << reverse_points[12] + reverse_points[13]
# reverse_cut_lines << reverse_points[7]  + reverse_points[43]
# reverse_cut_lines << reverse_points[14] + reverse_points[16]
# reverse_cut_lines << reverse_points[18] + reverse_points[42]
# reverse_cut_lines << reverse_points[20] + reverse_points[25]
# reverse_cut_lines << reverse_points[25] + reverse_points[26]
# reverse_cut_lines << reverse_points[26] + reverse_points[27]
# reverse_cut_lines << reverse_points[27] + reverse_points[28]
# reverse_cut_lines << reverse_points[28] + reverse_points[35]
# reverse_cut_lines << reverse_points[35] + reverse_points[36]
# reverse_cut_lines << reverse_points[33] + reverse_points[36]
# reverse_cut_lines << reverse_points[33] + reverse_points[34]
# reverse_cut_lines << reverse_points[30] + reverse_points[34]
# reverse_cut_lines << reverse_points[29] + reverse_points[31]
# reverse_cut_lines << reverse_points[24] + reverse_points[23]
# reverse_cut_lines << reverse_points[22] + reverse_points[30]
# reverse_cut_lines << reverse_points[12] + reverse_points[23]
# reverse_cut_lines << reverse_points[17] + reverse_points[19]

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

glue_boxes << points[41] + [heights[:glue_thick], widths[:glue_side] ]
glue_boxes << points[40] + [heights[:glue_width], widths[:glue_thick] ]
glue_boxes << points[38] + [heights[:glue_thick], widths[:glue_flap_thick] ]
glue_boxes << points[39] + [heights[:glue_thick], widths[:glue_flap_thick] ]


# box_orientation valid values are:
#     vertical = point is upper left, no rotation
#     upside_down = point is lower left, needs 180 rotation
#     sideways_right = point is upper left, needs 90 rotation ccw
#     sideways_left = point is upper right, needs 90 rotation cw
# orientation
#     vertical = point is upper left, from page view text flows from upper right to lower left
#     upside_down = point is lower left, needs 180 rotation, from page view text flows from bottom to top
#     sideways_right = point is upper left, needs 90 rotation ccw, top of text is left, bottom of text is right
#     sideways_left = point is upper right, needs 90 rotation cw, top of text is right, bottom of test is left
# background_color
#     can be nil, otherwise expected to be 6 hex char
# image
#     can be nil
# image can be fit to size or forced height or forced width
# z indexing is background color is on the bottom, image is in the middle, text is on top
#
def render_box_face point, args={}
  box_orientation = args[:box_orientation] || :vertical
  point_lower_right = point.last
  point_upper_left = point.first
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

  # orientation specified as if for landscape
  # which is what is shown to the user in the UI
  case args[:orientation]
  when :sideways_right
    point = point_upper_left
    angle = 0
    w = width
    h = height
  when :sideways_left
    point = point_lower_right
    angle = 180
    w = width
    h = height
  when :upside_down
    point = point_upper_right
    angle = 270
    w = height
    h = width
  else
    angle = 90
    point = point_lower_left
    w = height
    h = width
  end

  if args[:image]
    rotate angle, origin: point do
      bounding_box point, width: w, height: h do
        if args[:image_fit_or_native] == :stretch
          image args[:image], width: w, height: h
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
      rotate angle, origin: point do
        font (args[:font] || "Helvetica"), size: (args[:font_size] || 150) do
          text_box args[:text], at: point, width: w, height: h, mode: text_mode,
                   align: :center, valign: :center, overflow: :shrink_to_fit
        end
      end
    end
  end
end

def render_horizontal_offset_registration center_point
  center_point_x = center_point.first
  center_point_y = center_point.last
  rotate 90, origin: center_point do
    stroke do
      stroke_color '000000'
      horizontal_line center_point_x - 6.mm, center_point_x + 6.mm, at: center_point_y
      font 'Helvetica', size: 10 do
        text_box 'GREEN', at: [center_point_x + 3.mm, center_point_y - 3.mm],
                        width: 12.mm, height: 6.mm, overflow: :shrink_to_fit
        text_box 'BLUE', at: [center_point_x + 3.mm, center_point_y + 6.mm],
                          width: 12.mm, height: 6.mm, overflow: :shrink_to_fit
      end
    end
  end
  stroke do
    stroke_color '00FF00'
    horizontal_line center_point_x, center_point_x + 8.mm, at: center_point_y
    (1..6).each do |i|
      if i.even?
        # wide line
        vertical_line center_point_y - 2.mm, center_point_y + 2.mm, at: center_point_x + i.send(:mm)
      else
        # narrow line
        vertical_line center_point_y - 1.mm, center_point_y + 1.mm, at: center_point_x + i.send(:mm)
      end
    end
  end

  stroke do
    stroke_color '0000FF'
    horizontal_line center_point_x, center_point_x - 8.mm, at: center_point_y
    (1..6).each do |i|
      if i.even?
        # wide line
        vertical_line center_point_y - 2.mm, center_point_y + 2.mm, at: center_point_x - i.send(:mm)
      else
        # narrow line
        vertical_line center_point_y - 1.mm, center_point_y + 1.mm, at: center_point_x - i.send(:mm)
      end
    end
  end
end

def render_reverse_vertical_offset_registration center_point
  center_point_x = center_point.first
  center_point_y = center_point.last
  # labels
  stroke do
    stroke_color '000000'
    horizontal_line center_point_x - 6.mm, center_point_x + 6.mm, at: center_point_y
    font 'Helvetica', size: 10 do
      text_box 'RED', at: [center_point_x - 10.mm, center_point_y - 3.mm],
                      width: 12.mm, height: 6.mm, overflow: :shrink_to_fit
      text_box 'BLACK', at: [center_point_x - 14.mm, center_point_y + 6.mm],
                        width: 12.mm, height: 6.mm, overflow: :shrink_to_fit
    end
  end
  render_vertical_offset_registration center_point
end

def render_front_vertical_offset_registration center_point
  center_point_x = center_point.first
  center_point_y = center_point.last
  # labels
  stroke do
    stroke_color '000000'
    horizontal_line center_point_x - 6.mm, center_point_x + 6.mm, at: center_point_y
    font 'Helvetica', size: 10 do
      text_box 'RED', at: [center_point_x + 3.mm, center_point_y - 3.mm],
                      width: 12.mm, height: 6.mm, overflow: :shrink_to_fit
      text_box 'BLACK', at: [center_point_x + 3.mm, center_point_y + 6.mm],
                        width: 12.mm, height: 6.mm, overflow: :shrink_to_fit
    end
  end
  render_vertical_offset_registration center_point
end

def render_vertical_offset_registration center_point
  center_point_x = center_point.first
  center_point_y = center_point.last
  stroke do
    stroke_color '000000'
    vertical_line center_point_y, center_point_y + 8.mm, at: center_point_x
    (1..6).each do |i|
      if i.even?
        # wide line
        horizontal_line center_point_x - 2.mm, center_point_x + 2.mm, at: center_point_y + i.send(:mm)
      else
        # narrow line
        horizontal_line center_point_x - 1.mm, center_point_x + 1.mm, at: center_point_y + i.send(:mm)
      end
    end
  end

  stroke do
    stroke_color 'FF0000'
    vertical_line center_point_y, center_point_y - 8.mm, at: center_point_x
    (1..6).each do |i|
      if i.even?
        # wide line
        horizontal_line center_point_x - 2.mm, center_point_x + 2.mm, at: center_point_y - i.send(:mm)
      else
        # narrow line
        horizontal_line center_point_x - 1.mm, center_point_x + 1.mm, at: center_point_y - i.send(:mm)
      end
    end
  end
end

file_name = "../boxes/landscape_#{width}x#{height}x#{thickness}_box.pdf"
puts "  Generating #{file_name}"
Prawn::Document.generate(file_name,
                           :page_size   => "LETTER",
                           :print_scaling => :none,
                           :page_layout => :portrait) do
font_families.update "Pacifico"      => { :normal => "../Pacifico.ttf" },
                     "IceCream Soda" => { :normal => "../ICE-CS__.ttf" },
                     "FFF Tusj"      => { :normal => "../FFF_Tusj.ttf" }

  # page 1, outline box with cut and fold lines
  font_size 10
    text =<<EOT
This tuckbox was generated by software written by Michael King.
Source code is available at http://github.com/kingmt/tuckbox_generator and is licensed under the GPL

This implementation is inspired by the generator written by Craig P. Forbes at http://www.cpforbes.net/tuckbox.

The box is based on a design by Elliott C. Evans. See his page, http://www.ee0r.com/boxes/ for more information and assembly instructions.

Go to
http://www.tuckbox-generator.net to generate more box templates.
--Michael
EOT
  rotate 270, origin: points[46] do
    text_box text, at: points[46], width: w - QUARTER_INCH, height: h - 1.in, overflow: :shrink_to_fit
  end
  rotate 270, origin: points[21] do
    text_box "#{width}#{unit} x #{height}#{unit} x #{thickness}#{unit}", at: points[21], width: w, height: h, overflow: :shrink_to_fit,
                     align: :center, valign: :center
  end
  rotate 270, origin: points[47] do
    font 'Helvetica', size: 5 do
      text_box 'http://www.tuckbox-generator.net', at: points[47], width: w, height: EIGHTH_INCH, overflow: :shrink_to_fit
    end
  end
    stroke_color = 'FF0000'
    fill_color = 'FF0000'
   stroke do
     points.each_with_index do |p, i|
       # puts "Point #{i} = #{p.inspect}"
       fill_circle p, 1
       font 'Helvetica', size: 5 do
         draw_text i, at: p
       end
     end
   end
  stroke do
    cut_lines.each do |x1,y1,x2,y2|
      line [x1, y1], [x2, y2]
    end
  end
  stroke_arc_around points[44], radius: QUARTER_INCH, start_angle: 0, end_angle: 90
  stroke_arc_around points[45], radius: QUARTER_INCH, start_angle: 270, end_angle: 0
  if bottom_style == :glued
  else
    stroke_arc_around points[49], radius: QUARTER_INCH, start_angle: 180, end_angle: 270
    stroke_arc_around points[48], radius: QUARTER_INCH, start_angle: 90, end_angle: 180
  end

  # notch circle
  fill_color 'FFFFFF'
  stroke_color '000000'
  #bounding_box points[33], width: h, height: w do
   stroke_half_circle points[37], radius: QUARTER_INCH, side: :left

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
  fill_rectangle points[41], widths[:glue_patch_on_height_sides], widths[:glue_patch_on_thickness_sides]
  if bottom_style == :glued
    fill_rectangle points[40], widths[:glue_patch_on_thickness_sides], widths[:glue_patch_on_width_sides]
    fill_rectangle points[38], widths[:glue_patch_on_thickness_sides], widths[:glue_patch_on_thickness_sides]
    fill_rectangle points[39], widths[:glue_patch_on_thickness_sides], widths[:glue_patch_on_thickness_sides]
  end
  fill_color '000000'

  render_front_vertical_offset_registration points[31]
  render_horizontal_offset_registration points[0]

  # page 2 with the images
  start_new_page

  render_reverse_vertical_offset_registration reverse_points[31]
  render_horizontal_offset_registration reverse_points[0]

    font 'Helvetica', size: 15 do
      text_box 'Outside of the box, laminating recommended', at: [bounds.left,bounds.top], width: right_margin, height: QUARTER_INCH, overflow: :shrink_to_fit,
                     align: :center, valign: :center
    end

  ## FRONT
  front_face_args = { background_color: 'CCCCCC',
                      text: "F.TOP FRONT FRONT F.END",
                      #text_fill_color: '00FF00',
                      #text_stroke_color: 'FF0000',
                      #font: 'IceCream Soda',
                      #image: "../how_high_can_I_go.png",
                      orientation: :vertical }
  render_box_face face_points[:front], front_face_args
      ## reflect the front onto the tuck flap
  upper_left = face_points[:back].first
  rotate 180, origin: center_of_the_top do
      render_box_face face_points[:back], front_face_args
      save_graphics_state do
        fill_color 'FFFFFF'
        stroke_color 'FFFFFF'
        fill_rectangle [upper_left.first+flap_height+QUARTER_INCH,upper_left.last], h - flap_height, w
      end
  end
  if bottom_style == :tuck
    rotate 180, origin: center_of_the_bottom do
      render_box_face face_points[:back], front_face_args
      save_graphics_state do
        fill_color 'FFFFFF'
        stroke_color 'FFFFFF'
        fill_rectangle upper_left, h - flap_height - QUARTER_INCH, w
      end
    end
  end

  ## BACK
  render_box_face face_points[:back],
                  background_color: 'CCCCCC',
                  text: "TOP BACK BACK BACK BACK BACK BACK END",
                  #text_fill_color: '00FF00',
                  #text_stroke_color: 'FF0000',
                  #font: 'IceCream Soda',
                  #image: "../how_high_can_I_go.png",
                  font_size: 95,
                  image_fit_or_native: :stretch,
                  orientation: :vertical

  ### BOTTOM
  render_box_face face_points[:bottom],
                  background_color: 'CC0000',
                  #text: "This is the BOTTOM",
                  #text_fill_color: '00FF00',
                  #text_stroke_color: 'FF0000',
                  #font: 'Pacifico',
                  #font_size: 150,
                  #image: "../logo_GolemArcana.png",
                  orientation: :vertical

  #### SIDE 1
  render_box_face face_points[:left_side],
                  background_color: '00CC00',
                  text: "This is the LEFT SIDE",
                  #text_fill_color: '00FF00',
                  #text_stroke_color: 'FF0000',
                  #font: 'Pacifico',
                  #image: "../logo_golem_arcana_wide.png",
                  image_fit_or_native: :stretch,
                  orientation: :sideways_left


  #### SIDE 2
  render_box_face face_points[:right_side],
                  background_color: '00CC00',
                  text: "This is the RIGHT SIDE",
                  #text_fill_color: '00FF00',
                  #text_stroke_color: 'FF0000',
                  #font: 'Pacifico',
                  #image: "../logo_golem_arcana_wide.png",
                  orientation: :sideways_right

  #### TOP
  render_box_face face_points[:top],
                  background_color: 'CC0000',
                  text: "This is the TOP",
                  #text_fill_color: '00FF00',
                  #text_stroke_color: 'FF0000',
                  #font: 'FFF Tusj',
                  font_size: 15,
                  #image: "../logo_GolemArcana.png",
                  orientation: :upside_down

  ### SIDE TUCK FLAPS
  fill_color '0000FF'
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

  #stroke do
  #  reverse_cut_lines.each do |x1,y1,x2,y2|
  #    line [x1, y1], [x2, y2]
  #  end
  #end

  font_size 4
  fill_color '000000'
  reverse_points.each_with_index do |p, i|
    # puts "Reverse Point #{i} = #{p.inspect}"
    fill_circle p, 1
    draw_text i, at: p
  end
end


