class Gen < Object

PAPER_WIDTH = 1100
PAPER_HEIGHT = 850
#  given
h = 325
w = 250
t =  55
margin_x =  50
margin_x1 =  PAPER_WIDTH - 50
margin_y = PAPER_HEIGHT - 50
margin_y1 = PAPER_HEIGHT * 2 - 50

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
# key point is X margin + 10, y margin -10 -->
# cx=" 60" cy="735"
points[ 0] = [margin_x + 10, margin_y - 10]

widths[:glue_thick] = t - 20
widths[:glue_width] = w - 20
widths[:left_edge] = margin_x + 10
widths[:left_edge_tuck_flap_indent] = margin_x + 20
widths[:left_edge_tuck_flap_indent_2] = margin_x + 30
widths[:left_side_back] = margin_x + 10 + t
widths[:left_side_top_cut] = margin_x + 35 + t
widths[:right_side_top_cut] = margin_x - 10 + t + w
widths[:back_right_side] = margin_x + 10 + t + w
widths[:back_right_side_glue_flap] = margin_x + 20 + t + w
widths[:right_side_tuck_flap_indent] = margin_x - 10 + 2*t + w
widths[:right_side_tuck_flap_indent_2] = margin_x + 2*t + w
widths[:right_side_right_edge] = margin_x + 10 + 2*t + w
widths[:bottom_right_side_glue_box] = margin_x + 20 + 2*t + w
widths[:notch_center] = margin_x + 10 + 2*t + 1.5*w
widths[:front_right_edge] = margin_x + 10 + 2*t + 2*w
widths[:left_edge_tuck_flap_indent0] = margin_x + 20 + 2*t + 2*w
widths[:side_glue_flap_right_edge] = margin_x + 10 + 3*t + 2*w

widths[:reverse_left_edge] = margin_x1 - 10
widths[:reverse_left_edge_tuck_flap_indent] = margin_x1 - 20
widths[:reverse_left_edge_tuck_flap_indent_2] = margin_x1 - 30
widths[:reverse_left_side_back] = margin_x1 - 10 - t
widths[:reverse_left_side_top_cut] = margin_x1 - 35 - t
widths[:reverse_right_side_top_cut] = margin_x - 10 - t - w
widths[:reverse_back_right_side] = margin_x1 - 10 - t - w
widths[:reverse_back_right_side_glue_flap] = margin_x1 - 20 - t - w
widths[:reverse_right_side_tuck_flap_indent] = margin_x - 10 - 2*t - w
widths[:reverse_right_side_tuck_flap_indent_2] = margin_x1 - 2*t - w
widths[:reverse_right_side_right_edge] = margin_x1 - 10 - 2*t - w
widths[:reverse_bottom_right_side_glue_box] = margin_x1 - 20 - 2*t - w
widths[:reverse_notch_center] = margin_x1 - 10 - 2*t - 1.5*w
widths[:reverse_front_right_edge] = margin_x1 - 10 - 2*t - 2*w
widths[:reverse_left_edge_tuck_flap_indent0] = margin_x1 - 20 - 2*t - 2*w
widths[:reverse_side_glue_flap_right_edge] = margin_x1 - 10 - 3*t - 2*w


heights[:glue_side] = h - 20
heights[:glue_thick] = t - 20
heights[:glue_flap_thick] = t - 30
heights[:h140] = margin_y - 85 - 2*t - h
heights[:h165] = margin_y - 60 - 2*t - h
heights[:h215] = margin_y - 10 - 2*t - h
heights[:h225] = margin_y - 75 - t - h
heights[:h275] = margin_y - 35 - t - h
heights[:h290] = margin_y - 20 - t - h
heights[:h300] = margin_y - 10 - t - h
heights[:h310] = margin_y - t - h
heights[:h650] = margin_y - 10 - t
heights[:h660] = margin_y - t
heights[:h725] = margin_y - 20
heights[:h735] = margin_y - 10
heights[:reverse_h140] = margin_y1 - 85 - 2*t - h
heights[:reverse_h165] = margin_y1 - 60 - 2*t - h
heights[:reverse_h215] = margin_y1 - 10 - 2*t - h
heights[:reverse_h225] = margin_y1 - 75 - t - h
heights[:reverse_h275] = margin_y1 - 35 - t - h
heights[:reverse_h290] = margin_y1 - 20 - t - h
heights[:reverse_h300] = margin_y1 - 10 - t - h
heights[:reverse_h310] = margin_y1 - t - h
heights[:reverse_h650] = margin_y1 - 10 - t
heights[:reverse_h660] = margin_y1 - t
heights[:reverse_h725] = margin_y1 - 20
heights[:reverse_h735] = margin_y1 - 10

points[ 1] = [margin_x + 10, margin_y - 20]
points[ 2] = widths[:left_edge], heights[:h650]
points[ 3] = widths[:left_edge], heights[:h300]
points[ 4] = widths[:left_edge], heights[:h290]
points[ 5] = widths[:left_edge_tuck_flap_indent], heights[:h275]
points[ 6] = widths[:left_edge_tuck_flap_indent_2], heights[:h225]
points[ 7] = widths[:left_side_back], heights[:h165]
points[ 8] = widths[:left_side_back], heights[:h215]
points[ 9] = widths[:left_side_back], heights[:h225]
points[10] = widths[:left_side_back], heights[:h300]
points[11] = widths[:left_side_back], heights[:h725]
points[12] = widths[:left_side_back], heights[:h735]
points[13] = widths[:left_side_back], heights[:h650]
points[14] = widths[:left_side_top_cut], heights[:h140]
points[15] = widths[:left_side_top_cut], heights[:h215]
points[16] = widths[:right_side_top_cut], heights[:h140]
points[17] = widths[:right_side_top_cut], heights[:h215]
points[18] = widths[:back_right_side], heights[:h165]
points[19] = widths[:back_right_side], heights[:h215]
points[20] = widths[:back_right_side], heights[:h225]
points[21] = widths[:back_right_side], heights[:h300]
points[22] = widths[:back_right_side], heights[:h725]
points[23] = widths[:back_right_side], heights[:h735]
points[24] = widths[:back_right_side], heights[:h650]
points[25] = widths[:right_side_tuck_flap_indent], heights[:h225]
points[26] = widths[:right_side_tuck_flap_indent_2], heights[:h275]
points[27] = widths[:right_side_right_edge], heights[:h290]
points[28] = widths[:right_side_right_edge], heights[:h300]
points[29] = widths[:right_side_right_edge], heights[:h650]
points[30] = widths[:right_side_right_edge], heights[:h725]
points[31] = widths[:right_side_right_edge], heights[:h735]
points[32] = widths[:front_right_edge], heights[:h300]
points[33] = widths[:front_right_edge], heights[:h650]
points[34] = widths[:front_right_edge], heights[:h735]
points[35] = widths[:side_glue_flap_right_edge], heights[:h300]
points[36] = widths[:side_glue_flap_right_edge], heights[:h650]
points[37] = widths[:notch_center], heights[:h300]
points[38] = widths[:left_edge_tuck_flap_indent], heights[:h660]
points[39] = widths[:back_right_side_glue_flap], heights[:h660]
points[40] = widths[:bottom_right_side_glue_box], heights[:h660]
points[41] = widths[:left_edge_tuck_flap_indent0], heights[:h310]
points[42] = [widths[:reverse_left_edge], heights[:reverse_h650]]
points[43] = [widths[:reverse_left_edge], heights[:reverse_h300]]
points[44] = [widths[:reverse_left_edge], heights[:reverse_h290]]
points[45] = [widths[:reverse_left_edge_tuck_flap_indent], heights[:reverse_h275]]
points[46] = [widths[:reverse_left_edge_tuck_flap_indent_2], heights[:reverse_h225]]
points[47] = [widths[:reverse_left_side_back], heights[:reverse_h165]]
points[48] = [widths[:reverse_left_side_back], heights[:reverse_h215]]
points[49] = [widths[:reverse_left_side_back], heights[:reverse_h225]]
points[50] = [widths[:reverse_left_side_back], heights[:reverse_h300]]
points[51] = [widths[:reverse_left_side_back], heights[:reverse_h725]]
points[52] = [widths[:reverse_left_side_back], heights[:reverse_h735]]
points[53] = [widths[:reverse_left_side_back], heights[:reverse_h650]]
points[54] = [widths[:reverse_left_side_top_cut], heights[:reverse_h140]]
points[55] = [widths[:reverse_left_side_top_cut], heights[:reverse_h215]]
points[56] = [widths[:reverse_right_side_top_cut], heights[:reverse_h140]]
points[57] = [widths[:reverse_right_side_top_cut], heights[:reverse_h215]]
points[58] = [widths[:reverse_back_right_side], heights[:reverse_h165]]
points[59] = [widths[:reverse_back_right_side], heights[:reverse_h215]]
points[60] = [widths[:reverse_back_right_side], heights[:reverse_h225]]
points[61] = [widths[:reverse_back_right_side], heights[:reverse_h300]]
points[62] = [widths[:reverse_back_right_side], heights[:reverse_h725]]
points[63] = [widths[:reverse_back_right_side], heights[:reverse_h735]]
points[64] = [widths[:reverse_back_right_side], heights[:reverse_h650]]
points[65] = [widths[:reverse_right_side_tuck_flap_indent], heights[:reverse_h225]]
points[66] = [widths[:reverse_right_side_tuck_flap_indent_2], heights[:reverse_h275]]
points[67] = [widths[:reverse_right_side_right_edge], heights[:reverse_h290]]
points[68] = [widths[:reverse_right_side_right_edge], heights[:reverse_h300]]
points[69] = [widths[:reverse_right_side_right_edge], heights[:reverse_h650]]
points[70] = [widths[:reverse_right_side_right_edge], heights[:reverse_h725]]
points[71] = [widths[:reverse_right_side_right_edge], heights[:reverse_h735]]
points[72] = [widths[:reverse_front_right_edge], heights[:reverse_h300]]
points[73] = [widths[:reverse_front_right_edge], heights[:reverse_h650]]

cut_lines << points[1] + points[4]
cut_lines << points[4] + points[5]
cut_lines << points[5] + points[6]
cut_lines << points[6] + points[9]
cut_lines << points[8] + points[15]
cut_lines << points[1] + points[11]
cut_lines << points[12] + points[13]
cut_lines << points[7] + points[10]
cut_lines << points[7] + points[14]
cut_lines << points[14] + points[16]
cut_lines << points[16] + points[18]
cut_lines << points[18] + points[21]
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

glue_boxes << points[41] + [widths[:glue_thick], heights[:glue_side] ]
glue_boxes << points[40] + [widths[:glue_width], heights[:glue_thick] ]
glue_boxes << points[38] + [widths[:glue_thick], heights[:glue_flap_thick] ]
glue_boxes << points[39] + [widths[:glue_thick], heights[:glue_flap_thick] ]


File.open "../boxes/#{w}x#{h}x#{t}_box.svg",'w' do |f|
    svg_header =<<EOSVG
<?xml version="1.0" encoding="UTF-8"?>
<svg
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  width="#{PAPER_WIDTH}"
  height="#{PAPER_HEIGHT*2}"
  id="svg2">
  <g>
    <rect x="50" y="50" width="#{PAPER_WIDTH - 100}" height="#{PAPER_HEIGHT-100}" stroke-width="1" stroke="black" fill="white" />"
  </g>
EOSVG

  f.puts svg_header
  f.puts "  <g>"
  points.each_with_index do |(cx,cy),index|
    f.puts "<circle cx=\"#{cx}\" cy=\"#{cy}\" r=\"5\" fill=\"green\" />"
    f.puts "<text x=\"#{cx+10}\" y=\"#{cy}\" style=\"font-family:Verdana;font-size:12\" fill=\"green\">#{index}</text>"
  end
  # flap image - point 19 is the top left corner
  #f.puts "  <image x=\"#{points[19].first}\" y=\"#{points[19].last}\" width=\"#{w}\" height=\"#{h}\" xlink:href=\"../how_high_can_I_go.png\" transform=\"rotate(180 #{points[19].first} #{points[19].last})\"/>"
  f.puts "  </g>"
  f.puts '  <g id="cut lines">'
  cut_lines.each do |x1,y1,x2,y2|
    f.puts "  <line x1=\"#{x1}\" y1=\"#{y1}\" x2=\"#{x2}\" y2=\"#{y2}\" stroke-width=\"1.5\" stroke=\"black\" />"
  end
  f.puts "  </g>"
  f.puts '  <g id="fold lines">'
  fold_lines.each do |x1,y1,x2,y2|
    f.puts "  <line x1=\"#{x1}\" y1=\"#{y1}\" x2=\"#{x2}\" y2=\"#{y2}\" stroke-width=\"1.5\" stroke=\"black\" stroke-dasharray=\"2,4\" />"
  end
  f.puts "  </g>"
  f.puts '  <g id="glue boxes">'
  glue_boxes.each do |x1,y1,w,h|
    f.puts "  <rect x=\"#{x1}\" y=\"#{y1}\" width=\"#{w}\" height=\"#{h}\" fill=\"#CCC\" stroke=\"none\" />"
  end
  f.puts "  </g>"
  f.puts '  <g id="images">'
  # front image - point 72 is the top left corner
  f.puts "    <image x=\"#{points[72].first}\" y=\"#{points[72].last}\" width=\"#{w}\" height=\"#{h}\"  preserveAspectRatio=\"none\" xlink:href=\"../how_high_can_I_go.png\" />"
  # back image - point 61 is the top left corner
  f.puts "    <image x=\"#{points[61].first}\" y=\"#{points[61].last}\" width=\"#{w}\" height=\"#{h}\" xlink:href=\"../how_high_can_I_go.png\" />"
  # # side 1
  f.puts "    <rect x=\"#{points[50].first}\" y=\"#{points[50].last}\" width=\"#{t}\" height=\"#{h}\" fill=\"none\" stroke=\"black\" />"
  # #   assuming given an image that needs to be rotated - point 2 is top left
  # f.puts "    <image x=\"#{points[ 2].first}\" y=\"#{points[ 2].last}\" width=\"#{h}\" height=\"#{t}\" xlink:href=\"../logo_golem_arcana_wide.png\" transform=\"rotate(270 #{points[ 2].first} #{points[ 2].last})\"/>"
  # #   image not rotated - point 3 is top left
  # # side 2
  f.puts "    <rect x=\"#{points[68].first}\" y=\"#{points[68].last}\" width=\"#{t}\" height=\"#{h}\" fill=\"none\" stroke=\"black\" />"
  # #   assuming given an image that needs to be rotated - point 28 is top left
  # f.puts "    <image x=\"#{points[28].first}\" y=\"#{points[28].last}\" width=\"#{h}\" height=\"#{t}\" xlink:href=\"../logo_golem_arcana_wide.png\" transform=\"rotate(90 #{points[28].first} #{points[28].last})\"/>"
  # #   image not rotated - point 21 is top left
  # # top - point 8
  f.puts "    <rect x=\"#{points[59].first}\" y=\"#{points[59].last}\" width=\"#{w}\" height=\"#{t}\" fill=\"none\" stroke=\"black\" />"
  # f.puts "    <image x=\"#{points[21].first}\" y=\"#{points[21].last}\" width=\"#{w}\" height=\"#{t}\" xlink:href=\"../logo_golem_arcana_wide.png\" transform=\"rotate(180 #{points[21].first} #{points[21].last})\"/>"
  # bottom - point 64
  f.puts "    <image x=\"#{points[64].first}\" y=\"#{points[64].last}\" width=\"#{w}\" height=\"#{t}\" xlink:href=\"../logo_golem_arcana_wide.png\" />"
  # tuck flap with top of front image
  f.puts "    <rect x=\"#{points[59].first}\" y=\"#{points[59].last-2*t}\" width=\"#{w}\" height=\"#{2*t}\" fill=\"none\" stroke=\"black\" />"
  f.puts "  </g>"
  f.puts "</svg>"
end

# File.open "../boxes/reverse_#{w}x#{h}x#{t}_box.svg",'w' do |f|
#     svg_header =<<EOSVG
# <?xml version="1.0" encoding="UTF-8"?>
# <svg
#   xmlns="http://www.w3.org/2000/svg"
#   xmlns:xlink="http://www.w3.org/1999/xlink"
#   width="#{PAPER_WIDTH}"
#   height="#{PAPER_HEIGHT}"
#   id="svg2">
#   <g>
#     <rect x="50" y="50" width="#{PAPER_WIDTH - 100}" height="#{PAPER_HEIGHT-100}" stroke-width="1" stroke="black" fill="white" />"
#   </g>
# EOSVG
#
#   f.puts svg_header
#   f.puts "  <g>"
#   reverse_points.each_with_index do |(cx,cy),index|
#     f.puts "<circle cx=\"#{cx}\" cy=\"#{cy}\" r=\"5\" fill=\"green\" />"
#     f.puts "<text x=\"#{cx+10}\" y=\"#{cy}\" style=\"font-family:Verdana;font-size:12\" fill=\"green\">#{index}</text>"
#   end
#   reverse_cut_lines.each do |x1,y1,x2,y2|
#     f.puts "<line x1=\"#{x1}\" y1=\"#{y1}\" x2=\"#{x2}\" y2=\"#{y2}\" stroke-width=\"1.5\" stroke=\"black\" />"
#   end
#   reverse_fold_lines.each do |x1,y1,x2,y2|
#     f.puts "<line x1=\"#{x1}\" y1=\"#{y1}\" x2=\"#{x2}\" y2=\"#{y2}\" stroke-width=\"1.5\" stroke=\"black\" stroke-dasharray=\"2,4\" />"
#   end
#   reverse_glue_boxes.each do |x1,y1,w,h|
#     f.puts "<rect x=\"#{x1}\" y=\"#{y1}\" width=\"#{w}\" height=\"#{h}\" fill=\"#CCC\" stroke=\"none\" />"
#   end
#   f.puts "  </g>"
#   f.puts "</svg>"
# end

end
