library envy;

import 'dart:async';
import 'dart:html';
import 'dart:collection';
import 'dart:math' as Math;
import 'package:logging/logging.dart';
import 'package:observe/observe.dart';
import 'package:quantity/quantity.dart';
import 'package:quantity/quantity_ext.dart' show angle0, angle90, angle180, angle270;
import 'package:quantity/quantity_range.dart';
import 'package:vector_math/vector_math.dart';
import 'package:collection/wrappers.dart';

// Make components available
export 'wc/envy_div.dart';

part 'src/envy/envy_scene_graph.dart';
part 'src/envy/dynamic_node.dart';
part 'src/envy/envy_property.dart';
part 'src/envy/group_node.dart';
part 'src/envy/envy_node.dart';
part 'src/envy/envy_root.dart';

// Animation
part 'src/envy/animation/animation_group.dart';
part 'src/envy/animation/fill_mode.dart';
part 'src/envy/animation/playback_direction.dart';
part 'src/envy/animation/player.dart';
part 'src/envy/animation/timed_item_group.dart';
part 'src/envy/animation/timeline.dart';
part 'src/envy/animation/timing.dart';
part 'src/envy/animation/timing_group.dart';
part 'src/envy/animation/timing_function.dart';

// Color
part 'src/envy/color/color.dart';

// CSS
part 'src/envy/css/css_adapter.dart';
part 'src/envy/css/css_property.dart';
part 'src/envy/css/css_style.dart';

// CSS - Enumerations
part 'src/envy/css/enum/css_font_style.dart';
part 'src/envy/css/enum/css_length_units.dart';

// Data
part 'src/envy/data/data_accessor.dart';
part 'src/envy/data/data_group.dart';
part 'src/envy/data/keyed_dataset.dart';

// Data - Sources
part 'src/envy/data/source/data_source.dart';

// Data - Sources - Anchor2d
part 'src/envy/data/source/anchor2d/anchor2d_data.dart';
part 'src/envy/data/source/anchor2d/anchor2d_source.dart';

// Data - Sources - Angle
part 'src/envy/data/source/angle/angle_data.dart';
part 'src/envy/data/source/angle/angle_source.dart';

// Data - Sources - Boolean
part 'src/envy/data/source/boolean/boolean_data.dart';
part 'src/envy/data/source/boolean/boolean_source.dart';

// Data - Sources - Color
part 'src/envy/data/source/color/color_data.dart';
part 'src/envy/data/source/color/color_source.dart';
part 'src/envy/data/source/color/color_rgb.dart';

// Data - Sources - CSS
part 'src/envy/data/source/css/css_style_data.dart';
part 'src/envy/data/source/css/css_style_source.dart';

// Data - Sources - Drawing Style
part 'src/envy/data/source/drawing_style/drawing_style_data.dart';
part 'src/envy/data/source/drawing_style/drawing_style_source.dart';

// Data - Sources - Extrapolations
part 'src/envy/data/source/extrapolate/cycle_values.dart';
part 'src/envy/data/source/extrapolate/extrapolation.dart';
part 'src/envy/data/source/extrapolate/default_value.dart';
part 'src/envy/data/source/extrapolate/duplicate_first.dart';
part 'src/envy/data/source/extrapolate/duplicate_last.dart';
part 'src/envy/data/source/extrapolate/random_sample.dart';

// Data - Sources - Font
part 'src/envy/data/source/font/font_data.dart';
part 'src/envy/data/source/font/font_source.dart';

// Data - Sources - Number
part 'src/envy/data/source/number/number_data.dart';
part 'src/envy/data/source/number/number_source.dart';
part 'src/envy/data/source/number/random_number.dart';

// Data - Sources - Drawing Style
part 'src/envy/data/source/path_interpolation2d/path_interpolation2d_data.dart';
part 'src/envy/data/source/path_interpolation2d/path_interpolation2d_source.dart';

// Data - Sources - PointList
part 'src/envy/data/source/point_list/point_list_data.dart';
part 'src/envy/data/source/point_list/point_list_source.dart';

// Data - Sources - Strings
part 'src/envy/data/source/string/string_data.dart';
part 'src/envy/data/source/string/string_source.dart';

// Data - Sources - Text Align 2D
part 'src/envy/data/source/text_align2d/text_align2d_data.dart';
part 'src/envy/data/source/text_align2d/text_align2d_source.dart';

// Data - Sources - Text Baseline 2D
part 'src/envy/data/source/text_baseline2d/text_baseline2d_data.dart';
part 'src/envy/data/source/text_baseline2d/text_baseline2d_source.dart';

// Graphics
part 'src/envy/graphic/graphic_node.dart';

// Graphics - 2D
part 'src/envy/graphic/twod/anchor2d.dart';
part 'src/envy/graphic/twod/bar2d.dart';
part 'src/envy/graphic/twod/annular_section2d.dart';
part 'src/envy/graphic/twod/circle2d.dart';
part 'src/envy/graphic/twod/cross2d.dart';
part 'src/envy/graphic/twod/diamond2d.dart';
part 'src/envy/graphic/twod/drawing_style2d.dart';
part 'src/envy/graphic/twod/ellipse2d.dart';
part 'src/envy/graphic/twod/gradient2d.dart';
part 'src/envy/graphic/twod/graphic2d_node.dart';
part 'src/envy/graphic/twod/image2d.dart';
part 'src/envy/graphic/twod/line2d.dart';
part 'src/envy/graphic/twod/path2d.dart';
part 'src/envy/graphic/twod/pattern2d.dart';
part 'src/envy/graphic/twod/point2d.dart';
part 'src/envy/graphic/twod/point_list.dart';
part 'src/envy/graphic/twod/rect2d.dart';
part 'src/envy/graphic/twod/regular_polygon2d.dart';
part 'src/envy/graphic/twod/star2d.dart';
part 'src/envy/graphic/twod/text2d.dart';
part 'src/envy/graphic/twod/triangle2d.dart';
part 'src/envy/graphic/twod/transform2d_group.dart';

// Graphics - 2D - Enumerations
part 'src/envy/graphic/twod/enum/anchor_mode2d.dart';
part 'src/envy/graphic/twod/enum/composite_operation2d.dart';
part 'src/envy/graphic/twod/enum/line_cap2d.dart';
part 'src/envy/graphic/twod/enum/line_join2d.dart';
part 'src/envy/graphic/twod/enum/path_interpolation2d.dart';
part 'src/envy/graphic/twod/enum/text_align2d.dart';
part 'src/envy/graphic/twod/enum/text_baseline2d.dart';

// Graphics - 3D
part 'src/envy/graphic/threed/graphic3d_node.dart';

// Html
part 'src/envy/html/canvas_image_source_node.dart';
part 'src/envy/html/canvas_node.dart';
part 'src/envy/html/div_node.dart';
part 'src/envy/html/html_node.dart';
part 'src/envy/html/image_node.dart';
part 'src/envy/html/media_node.dart';
part 'src/envy/html/video_node.dart';

// Html - Enum
part 'src/envy/html/enum/cross_origin.dart';
part 'src/envy/html/enum/dir_attribute.dart';
part 'src/envy/html/enum/population_mode.dart';

// Html - Population
part 'src/envy/html/population/independent_population_strategy.dart';
part 'src/envy/html/population/population_strategy.dart';

// Interpolation
part 'src/envy/interpolate/anchor2d_interpolator.dart';
part 'src/envy/interpolate/angle_interpolator.dart';
part 'src/envy/interpolate/binary_interpolator.dart';
part 'src/envy/interpolate/color_interpolator.dart';
part 'src/envy/interpolate/css_style_interpolator.dart';
part 'src/envy/interpolate/drawing_style2d_interpolator.dart';
part 'src/envy/interpolate/envy_interpolator.dart';
part 'src/envy/interpolate/font_interpolator.dart';
part 'src/envy/interpolate/gradient2d_interpolator.dart';
part 'src/envy/interpolate/number_interpolator.dart';
part 'src/envy/interpolate/pattern2d_interpolator.dart';
part 'src/envy/interpolate/point_interpolator.dart';
part 'src/envy/interpolate/point_list_interpolator.dart';
part 'src/envy/interpolate/vector2_interpolator.dart';

// Multiplicity
part 'src/envy/multiplicity/multiplicity.dart';
part 'src/envy/multiplicity/fixed_size.dart';
part 'src/envy/multiplicity/smallest_size.dart';
part 'src/envy/multiplicity/largest_size.dart';

// Text/Font
part 'src/envy/text/font.dart';

// Utilities
part 'src/envy/util/css_util.dart';
part 'src/envy/util/enumeration.dart';

Logger _LOG = new Logger("envy");
