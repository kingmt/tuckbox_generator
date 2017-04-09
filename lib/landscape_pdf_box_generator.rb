require "prawn"
require "prawn/measurement_extensions"
require "prawn_shapes"
require 'yaml'

data = YAML.load_file ARGV[0]
# change page layout from string to symbol
data['box']['page_layout'] = data['box']['page_layout'].to_sym

text =<<-EOT
  This tuckbox was generated by software written by Michael King.
  Source code is available at http://github.com/kingmt/tuckbox_generator and is licensed under the GPL

  This implementation is inspired by the generator written by Craig P. Forbes at http://www.cpforbes.net/tuckbox.

  The box is based on a design by Elliott C. Evans. See his page, http://www.ee0r.com/boxes/ for more information and assembly instructions.

  Go to
  http://www.tuckbox-generator.net to generate more box templates.
  --Michael
  EOT

height = data['box']['height']
width = data['box']['width']
thickness = data['box']['thickness']
if thickness > width
  # need to flip them
  width = data['box']['thickness']
  thickness = data['box']['width']
end
unit = data['box']['unit']
bottom_style = data['box']['bottom_style']

info_data = { 'faces' => {
                'dimensions' => {
                  'font_size' => 10,
                  'text' => "#{width}#{unit} x #{height}#{unit} x #{thickness}#{unit}"
                },
                'url' => {
                  'text' => 'http://www.tuckbox-generator.net',
                  'text_orientation' => 'sideways_left',
                  'font_size' => 5,
                  'text_align' => 'left',
                  'text_valign' => 'top'
                },
                'credits' => {
                  'text' => text,
                  'font_size' => 10,
                  'text_align' => 'left',
                  'text_valign' => 'top'
                }
              }
            }

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
EIGHTH_INCH = 0.125.in
QUARTER_INCH = 0.25.in
THREE_QUARTER_INCH = 0.75.in
ONE_INCH = 1.in
ONE_CENTIMETER = 1.cm
flap_height = if t > THREE_QUARTER_INCH
                THREE_QUARTER_INCH
              elsif t < QUARTER_INCH
                QUARTER_INCH
              else
                t/2
              end
tuck_flap_height = if t > THREE_QUARTER_INCH
                     THREE_QUARTER_INCH
                   else
                     t - 5
                   end
bounding_box_width = w*2 + t*3
bounding_box_height = if bottom_style == 'glued'
                        t*2 + flap_height + h
                      else
                        t*2 + flap_height*2 + h
                      end
points = []
widths = {}
heights = {}
cut_lines = []
fold_lines = []
glue_boxes = []
reverse_points = []
reverse_cut_lines = []
face_points = {}

reference_starting_x = 0
reference_starting_y = if bottom_style == 'glued'
                         t
                       else
                         t + flap_height
                       end

widths[:left_edge] = 0
widths[:left_edge_tuck_flap_indent] = EIGHTH_INCH
widths[:left_edge_tuck_flap_indent_2] = QUARTER_INCH
widths[:back_face_left_side] = t
widths[:left_side_flap_cut] = t + QUARTER_INCH
widths[:right_side_flap_cut] = t + w - QUARTER_INCH
widths[:left_side_flap_corner] = t + EIGHTH_INCH
widths[:right_side_flap_corner] = t + w - EIGHTH_INCH
widths[:back_face_right_side] = t + w
widths[:right_side_tuck_flap_indent] = 2*t + w - QUARTER_INCH
widths[:right_side_tuck_flap_indent_2] = 2*t + w - EIGHTH_INCH
widths[:front_face_left_edge] = 2*t + w
widths[:front_face_right_edge] = 2*t + 2*w
widths[:notch_center] = 2*t + 1.5*w
widths[:side_glue_flap_right_edge] = 3*t + 2*w
widths[:back_left_side_bottom_flap_glue_point] = EIGHTH_INCH
widths[:back_right_side_bottom_flap_glue_point] = EIGHTH_INCH + t + w
widths[:bottom_glue_flap_glue_point] = EIGHTH_INCH + 2*t + w
widths[:side_glue_flap_glue_point] = 2*t + 2*w + EIGHTH_INCH

widths[:reverse_left_edge] = bounding_box_width
widths[:reverse_left_edge_tuck_flap_indent] = bounding_box_width - EIGHTH_INCH
widths[:reverse_left_edge_tuck_flap_indent_2] = bounding_box_width - QUARTER_INCH
widths[:reverse_back_face_left_side] = bounding_box_width - t
widths[:reverse_left_side_flap_cut] = bounding_box_width - t - QUARTER_INCH
widths[:reverse_right_side_flap_cut] = bounding_box_width - t - w + QUARTER_INCH
widths[:reverse_back_face_right_side] = bounding_box_width - t - w
widths[:reverse_right_side_tuck_flap_indent] = bounding_box_width - 2*t - w + QUARTER_INCH
widths[:reverse_right_side_tuck_flap_indent_2] = bounding_box_width - 2*t - w + EIGHTH_INCH
widths[:reverse_front_face_left_edge] = bounding_box_width - 2*t - w
widths[:reverse_front_face_right_edge] = bounding_box_width - 2*t - 2*w
widths[:reverse_notch_center] = bounding_box_width - 2*t - 1.5*w
widths[:reverse_side_glue_flap_right_edge] = bounding_box_width - 3*t - 2*w
widths[:reverse_back_left_side_bottom_flap_glue_point] = bounding_box_width - EIGHTH_INCH
widths[:reverse_back_right_side_bottom_flap_glue_point] = bounding_box_width - EIGHTH_INCH - t - w
widths[:reverse_bottom_glue_flap_glue_point] = bounding_box_width - EIGHTH_INCH - 2*t - w
widths[:reverse_side_glue_flap_glue_point] = bounding_box_width - 2*t - 2*w - EIGHTH_INCH

heights[:glue_patch_on_thickness_sides] = t - QUARTER_INCH
heights[:glue_patch_on_width_sides] = w - QUARTER_INCH
heights[:glue_patch_on_height_sides] = h - QUARTER_INCH

heights[:bottom_edge] = reference_starting_y - t
heights[:faces_bottom_edge] = reference_starting_y
heights[:faces_lower_tuck_flap_fold] = reference_starting_y + h - QUARTER_INCH
heights[:faces_top_edge] = reference_starting_y + h
heights[:side_tuck_flap_before_indent_1] = reference_starting_y + h + EIGHTH_INCH
heights[:side_tuck_flap_at_indent_1] = reference_starting_y + h + QUARTER_INCH
heights[:side_tuck_flap_at_indent_2] = reference_starting_y + h + tuck_flap_height
heights[:top_of_top_face] = reference_starting_y + t + h
heights[:start_tuck_flap_corner_rounding] = reference_starting_y + t + h + flap_height - QUARTER_INCH
heights[:top_of_tuck_flap] = reference_starting_y + t + h + flap_height
heights[:top_of_tuck_flap_face] = reference_starting_y + t + 2*h
heights[:bottom_glue_flap_glue_point] = reference_starting_y - EIGHTH_INCH
heights[:side_glue_flap_glue_point] = reference_starting_y - EIGHTH_INCH + h
heights[:bottom_of_bottom_tuck_flap] = reference_starting_y -t - flap_height
heights[:start_bottom_tuck_flap_corner_rounding] = reference_starting_y - t - flap_height + QUARTER_INCH
heights[:bottom_side_tuck_flap_before_indent_1] = reference_starting_y - EIGHTH_INCH
heights[:bottom_side_tuck_flap_at_indent_1] = reference_starting_y - QUARTER_INCH
heights[:bottom_side_tuck_flap_at_indent_2] = reference_starting_y - tuck_flap_height

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
points[44] = 0,0
points[45] = 0,0
#points[44] = widths[:right_side_flap_cut], heights[:start_tuck_flap_corner_rounding]
#points[45] = widths[:left_side_flap_cut],  heights[:start_tuck_flap_corner_rounding]
points[46] = widths[:front_face_left_edge]+3,  heights[:faces_lower_tuck_flap_fold]-EIGHTH_INCH
#points[46] = widths[:front_face_left_edge]+EIGHTH_INCH,  heights[:faces_lower_tuck_flap_fold]
points[47] = widths[:back_face_right_side]+3,  heights[:faces_lower_tuck_flap_fold]-EIGHTH_INCH
#points[47] = widths[:back_face_left_side]+EIGHTH_INCH,  heights[:faces_top_edge] + EIGHTH_INCH
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
reverse_points[63] = widths[:reverse_back_face_left_side] + w, heights[:top_of_top_face] - h


face_points[:front_upper_left]  = reverse_points[32]
face_points[:front_lower_right] = reverse_points[29]
face_points[:back_upper_left]  = reverse_points[21]
face_points[:back_lower_right] = reverse_points[13]
face_points[:left_side_upper_left]  = reverse_points[10]
face_points[:left_side_lower_right] = reverse_points[2]
face_points[:glue_flap_upper_left]  = reverse_points[35]
face_points[:glue_flap_lower_right] = reverse_points[33]
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
face_points[:credits_upper_left] = points[46]
face_points[:credits_lower_right] = [points[33].first-6 , points[33].last  ]
face_points[:dimensions_upper_left] = points[43]
face_points[:dimensions_lower_right] = points[24]
face_points[:url_upper_left] = points[47]
face_points[:url_lower_right] = [points[29].first - 3, points[29].last]

if bottom_style == 'glued'
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
  cut_lines << points[53] + points[50]
  cut_lines << points[51] + points[52]
end

cut_lines << points[7] + points[14]
cut_lines << points[16] + points[18]
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

if bottom_style == 'glued'
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

# tuck flap masks
tuck_flap_masks = {}
tuck_flap_masks[:top] = [reverse_points[8],reverse_points[7],reverse_points[14],reverse_points[16],reverse_points[18],reverse_points[19]]
tuck_flap_masks[:bottom] = [reverse_points[12],reverse_points[53],reverse_points[50],reverse_points[51],reverse_points[52],reverse_points[23]]

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
  box_orientation = args['box_orientation'] || 'vertical'
  font_face = args['font'] || "Helvetica"
  font_size = args['font_size'] || 150
  width  = point_lower_right.first - point_upper_left.first
  height = point_upper_left.last - point_lower_right.last
  text_align = args['text_align'] && args['text_align'].to_sym || :center
  text_valign = args['text_valign'] && args['text_valign'].to_sym || :center
  point_upper_right = point_lower_right.first, point_upper_left.last
  point_lower_left = point_upper_left.first, point_lower_right.last
  if args['background_color']
    save_graphics_state do
      fill_color args['background_color']
      stroke_color args['background_color']
      fill_and_stroke_rectangle point_upper_left, width, height
    end
  end

  if args['image']
    case args['image_orientation']
    when 'sideways_right'
      angle = 90
      point = point_lower_left
      w = height
      h = width
    when 'sideways_left'
      point = point_upper_right
      angle = 270
      w = height
      h = width
    when 'upside_down'
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
        if args['image_fit_or_native'] == 'stretch'
          image args['image'], at: point, width: w, height: h
        else
          # 'fit'
          image args['image'], position: :center, vposition: :center, fit: [w, h]
        end
      end
    end
  end

  if args['text']
    save_graphics_state do
      text_mode = :fill
      if args['text_fill_color'] && args['text_stroke_color']
        fill_color args['text_fill_color']
        stroke_color args['text_stroke_color']
        text_mode = :fill_stroke
      elsif args['text_stroke_color']
        stroke_color args['text_stroke_color']
        text_mode = :stroke
      elsif args['text_fill_color']
        fill_color args['text_fill_color']
      end

      case args['text_orientation']
      when 'sideways_right'
        angle = 90
        point = point_lower_left
        w = height
        h = width
      when 'sideways_left'
        point = point_upper_right
        angle = 270
        w = height
        h = width
      when 'upside_down'
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
        font font_face, size: font_size do
          text_box args['text'], at: point, width: w, height: h, mode: text_mode,
                   align: text_align, valign: text_valign, overflow: :shrink_to_fit,
                   min_font_size: 1, disable_wrap_by_char: true, kerning: true
        end
      end
    end
  end
end

def opposite_direction direction
  case direction
  when 'vertical'
    'upside_down'
  when 'upside_down'
    'vertical'
  when 'sideways_left'
    'sideways_right'
  when 'sideways_right'
    'sideways_left'
  end
end

# draw a ruler so the person looking at the prints can see if shrink to fit was enabled
# also allows person looking at the prints to make sure the cut lines line up with the images
def draw_master_edge_ruler
  rotate 270, origin: [0.25.in, 1.25.in] do
    text_box 'Master', at: [0.25.in, 1.25.in],
                     width: 1.in,
                     height: 0.25.in,
                     align: :right,
                     valign: :center,
                     overflow: :shrink_to_fit
  end
  text_box 'Corner', at: [0.25.in,0.25.in],
                     width: 1.in,
                     height: 0.25.in,
                     valign: :center,
                     overflow: :shrink_to_fit

  vertical_line 0.25.in, 5.in, at: 0.25.in
    [2,3,4,5].each do |x|
      horizontal_line 0.125.in, 0.25.in, at: ONE_INCH * x - 0.5.in
      distance = ONE_INCH * x - 0.55.in
      rotate 270, origin: [0.25.in, distance] do
        text_box "#{x} in", at: [0.25.in, distance],
                         width: 1.in,
                         height: 0.25.in,
                         valign: :center,
                         overflow: :shrink_to_fit
      end
    end
    [4,6,8,10,12].each do |x|
      horizontal_line 0.25.in, 0.375.in, at: ONE_CENTIMETER * x - 0.5.in
      distance = ONE_CENTIMETER*x - 0.55.in
      rotate 270, origin: [0.5.in, distance] do
        text_box "#{x} cm", at: [0.5.in, distance],
                         width: 1.in,
                         height: 0.25.in,
                         valign: :center,
                         overflow: :shrink_to_fit
      end
    end
  horizontal_line 0.25.in, 5.in, at: 0.25.in
    [2,3,4,5].each do |x|
      vertical_line 0.125.in, 0.25.in, at: ONE_INCH * x - 0.5.in
      text_box "#{x} in", at: [ONE_INCH * x - 0.45.in, 0.25.in],
                       width: 1.in,
                       height: 0.25.in,
                       valign: :center,
                       overflow: :shrink_to_fit
    end
    [4,6,8,10,12].each do |x|
      vertical_line 0.25.in, 0.375.in, at: ONE_CENTIMETER * x - 0.5.in
      text_box "#{x} cm", at: [( ONE_CENTIMETER*x - 0.45.in), 0.5.in],
                       width: 1.in,
                       height: 0.25.in,
                       valign: :center,
                       overflow: :shrink_to_fit
    end
end
def draw_master_edge_ruler_faces
  rotate 90, origin: [9.75.in, 0.25.in] do
    text_box 'Corner', at: [9.75.in, 0.25.in],
                     width: ONE_INCH,
                     height: 0.25.in,
                     valign: :center,
                     overflow: :shrink_to_fit
  end
  text_box 'Master', at: [8.75.in,0.25.in],
                     width: ONE_INCH,
                     height: 0.25.in,
                     align: :right,
                     valign: :center,
                     overflow: :shrink_to_fit
  vertical_line 0.25.in, 5.in, at: 9.75.in
  horizontal_line 5.in, 9.75.in, at: 0.25.in
end

Prawn::Document.generate("../boxes/landscape_#{width}#{unit}x#{height}#{unit}x#{thickness}#{unit}_box.pdf",
                           :page_size   => data['box']['page_size'],
                           :print_scaling => :none,
                           :page_layout => data['box']['page_layout']) do
font_families.update "Pacifico"      => { :normal => "../fonts/Pacifico.ttf" },
                     "Engebrechtre"  => { :normal => "../fonts/engebrechtre.regular.ttf",
                                          :italic => "../fonts/engebrechtre.italic.ttf",
                                          :bold   => "../fonts/engebrechtre.bold.ttf" },
                     "IceCream Soda" => { :normal => "../fonts/ICE-CS__.ttf" },
                     "FFF Tusj"      => { :normal => "../fonts/FFF_Tusj.ttf" }

  # how many boxes to draw?
  gutter = EIGHTH_INCH
  num_boxes = (720/(bounding_box_width+gutter)).to_i
  # puts "I think I can fit #{num_boxes} on a page"

  # page 1, outline box with cut and fold lines
  draw_master_edge_ruler

  # create bounding box
  bounding_box [0.5.in,0.5.in+bounding_box_height], width: bounding_box_width, height: bounding_box_height do
    stroke_bounds
    render_box_face face_points[:credits_upper_left], face_points[:credits_lower_right],
                    info_data['faces']['credits']
    render_box_face face_points[:url_upper_left], face_points[:url_lower_right],
                    info_data['faces']['url']
    render_box_face face_points[:dimensions_upper_left], face_points[:dimensions_lower_right],
                    info_data['faces']['dimensions']



    if data['debug_points']
      points.each_with_index do |p, i|
        # puts "Point #{i} = #{p.inspect}"
        fill_circle p, 3
        draw_text i, at: p
      end
    end
    stroke do
      cut_lines.each do |x1,y1,x2,y2|
        line [x1, y1], [x2, y2]
      end
    end

    # notch circle
    fill_color 'FFFFFF'
    stroke_color '000000'
    #bounding_box points[33], width: h, height: w do
     pie_slice points[37], :radius => QUARTER_INCH,
               :start_angle => 180, :end_angle => 0

    #end

    save_graphics_state do
      self.line_width = 0.5
      dash 2, :space => 2, :phase => 0
      stroke do
        fold_lines.each do |x1,y1,x2,y2|
          line [x1, y1], [x2, y2]
        end
      end
      undash
    end


    # glue boxes
    fill_color 'CCCCCC'
    fill_rectangle points[41], heights[:glue_patch_on_thickness_sides], heights[:glue_patch_on_height_sides]
    if bottom_style == 'glued'
      fill_rectangle points[40], heights[:glue_patch_on_width_sides], heights[:glue_patch_on_thickness_sides]
      fill_rectangle points[38], heights[:glue_patch_on_thickness_sides], heights[:glue_patch_on_thickness_sides]
      fill_rectangle points[39], heights[:glue_patch_on_thickness_sides], heights[:glue_patch_on_thickness_sides]
    end
    fill_color '000000'
  end

  # create bounding box
  bounding_box [0.75.in+bounding_box_width,0.5.in+bounding_box_height],
               width: bounding_box_width, height: bounding_box_height do
    #stamp 'inside_box'
  end

  # page 2 with the images
  start_new_page
  draw_master_edge_ruler_faces

  bounding_box [9.5.in-bounding_box_width,0.5.in+bounding_box_height], width: bounding_box_width, height: bounding_box_height do
    stroke_bounds
    font_size 150
    # FRONT
    render_box_face face_points[:front_upper_left], face_points[:front_lower_right],
                    data['faces']['front']
        ## reflect the front onto the tuck flap
    save_graphics_state do
      soft_mask do
        fill_color 0,0,0,0
        stroke_color 0,0,0,0
        fill_and_stroke_polygon *tuck_flap_masks[:top]
      end
        rotate 180, origin: reverse_points[8] do
          render_box_face reverse_points[8], reverse_points[63],
                          data['faces']['front']
        end
        #fill_color 'ff0000'
        #fill_rectangle [0,bounds.height],bounds.width, bounds.height
    end

    if bottom_style == 'tucked'
      # reflect the bottom of the face onto the bottom tuckflap
      save_graphics_state do
        soft_mask do
          fill_color 0,0,0,0
          stroke_color 0,0,0,0
          fill_and_stroke_polygon *tuck_flap_masks[:bottom]
        end
        rotate 180, origin: reverse_points[23] do
          render_box_face reverse_points[62], reverse_points[23],
                          data['faces']['front']
        end
      end
    end

    # BACK
    render_box_face face_points[:back_upper_left], face_points[:back_lower_right],
                    data['faces']['back']
    # BOTTOM
    render_box_face face_points[:bottom_upper_left], face_points[:bottom_lower_right],
                    data['faces']['bottom']
    ## LEFT SIDE
    render_box_face face_points[:left_side_upper_left], face_points[:left_side_lower_right],
                    data['faces']['left_side']
    ## Copy LEFT SIDE to the glue flap
    render_box_face face_points[:glue_flap_upper_left], face_points[:glue_flap_lower_right],
                    data['faces']['left_side']
    ## RIGHT SIDE
    render_box_face face_points[:right_side_upper_left], face_points[:right_side_lower_right],
                    data['faces']['right_side']
    ## TOP
    render_box_face face_points[:top_upper_left], face_points[:top_lower_right],
                    data['faces']['top']

    ## SIDE TUCK FLAPS
    # left side
    if fill_color data['faces']['left_side']['background_color']
      fill_color data['faces']['left_side']['background_color']
    end
    fill_polygon reverse_points[ 9],
                 reverse_points[ 6],
                 reverse_points[ 5],
                 reverse_points[ 4],
                 reverse_points[ 3],
                 reverse_points[10]
    # right side
    if fill_color data['faces']['right_side']['background_color']
      fill_color data['faces']['right_side']['background_color']
    end
    fill_polygon reverse_points[25],
                 reverse_points[26],
                 reverse_points[27],
                 reverse_points[28],
                 reverse_points[21],
                 reverse_points[20]
    if bottom_style == 'tucked'
      # left side
      if fill_color data['faces']['left_side']['background_color']
        fill_color data['faces']['left_side']['background_color']
      end
      fill_polygon reverse_points[ 2],
                   reverse_points[54],
                   reverse_points[55],
                   reverse_points[56],
                   reverse_points[57],
                   reverse_points[13]
      # right side
      if fill_color data['faces']['right_side']['background_color']
        fill_color data['faces']['right_side']['background_color']
      end
      fill_polygon reverse_points[24],
                   reverse_points[58],
                   reverse_points[59],
                   reverse_points[60],
                   reverse_points[61],
                   reverse_points[29]
    else
      # bottom style glued
      # left side
      if fill_color data['faces']['left_side']['background_color']
        fill_color data['faces']['left_side']['background_color']
        stroke_color data['faces']['left_side']['background_color']
      end
      fill_rectangle reverse_points[13], t, t
      # fill_and_stroke_rectangle reverse_points[13], t, t
      # right side
      if fill_color data['faces']['right_side']['background_color']
        fill_color data['faces']['right_side']['background_color']
        stroke_color data['faces']['right_side']['background_color']
      end
      fill_rectangle reverse_points[29], t, t
      # fill_and_stroke_rectangle reverse_points[29], t, t
      # front
      if fill_color data['faces']['front']['background_color']
        fill_color data['faces']['front']['background_color']
        stroke_color data['faces']['front']['background_color']
      end
      fill_and_stroke_rectangle reverse_points[33], w, t
    end


    font_size 10
    fill_color '000000'
    if data['debug_points']
      reverse_points.each_with_index do |p, i|
        # puts "Reverse Point #{i} = #{p.inspect}"
        fill_circle p, 3
        draw_text i, at: p
      end
    end
  end

  bounding_box [9.25.in-2*bounding_box_width,0.5.in+bounding_box_height],
               width: bounding_box_width, height: bounding_box_height do
    # stamp 'box_faces'
  end
end
