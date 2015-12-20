import 'dart:html';

import 'package:envy/envy.dart';
import 'package:envy/wc/envy_div.dart';
import 'package:polymer/polymer.dart';
import 'package:quantity/quantity.dart';

main() async {
  await initPolymer();
  _init();
}


void _init() {
  testBasic();
  testGeoJson();
}

void testBasic() {
  EnvyDiv e = querySelector("#geo-basic") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 100);
  esg.attachToRoot(canvas);

  var latitudes = [10, 20, 30, 20, -10, 10];
  var longitudes = [-120, -60, 0, 60, 10, -120];

  var coordData = [
    {
      "lats": latitudes,
      "longs": longitudes
    }
  ];


  // Path
  Path2d s = new Path2d();
  canvas.addDataset("coords", list: coordData);
  canvas.attach(s);

  var projSource = new ProjectionConstant(new Equirectangular(new Angle(deg: 45)));
  var latSource = new NumberListData("coords", canvas, prop: "lats");
  var longSource = new NumberListData("coords", canvas, prop: "longs");

  s.points.enter = new GeoPointListDegrees(projSource, latListSource: latSource, longListSource: longSource);
  s.x.enter = new NumberConstant.array([200, 500, 800]);
  s.y.enter = new NumberConstant(100);
  s.lineWidth.enter = new NumberConstant(3);
  s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.gray999));
  s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
  s.fill.enter = new BooleanConstant.array([true, true, false]);
  s.stroke.enter = new BooleanConstant.array([true, false, true]);
  s.interpolation.enter = new PathInterpolation2dConstant(PathInterpolation2d.LINEAR_CLOSED);

  esg.updateGraph();
}


void testGeoJson() {
  EnvyDiv e = querySelector("#geo-json") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 100);
  esg.attachToRoot(canvas);

  var geoJson = new GeoJson.map(nevada);

  var coordData = [];
  for (var feature in geoJson.featureCollection.features) {
    if (feature.geometry is GeoJsonPolygon) {
      var rings = [feature.geometry.exteriorRing];
      rings.addAll(feature.geometry.interiorRings);
      for (var ring in rings) {
        var latitudes = [];
        var longitudes = [];
        for (var coord in ring.coordinates) {
          longitudes.add(coord.longitude);
          latitudes.add(coord.latitude);
          coordData.add({
            "lats": latitudes,
            "longs": longitudes
          });
        }
      }
    }
  }

  // Path
  Path2d s = new Path2d();
  canvas.addDataset("coords", list: coordData);
  canvas.attach(s);

  var projSource = new ProjectionConstant(new Equirectangular(new Angle(deg: 45)));
  var latSource = new NumberListData("coords", canvas, prop: "lats");
  var longSource = new NumberListData("coords", canvas, prop: "longs");

  s.points.enter = new GeoPointListDegrees(projSource, latListSource: latSource, longListSource: longSource);
  s.x.enter = new NumberConstant(200);
  s.y.enter = new NumberConstant(100);
  s.lineWidth.enter = new NumberConstant(3);
  s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.gray999));
  s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
  s.fill.enter = BooleanConstant.TRUE;
  s.stroke.enter = BooleanConstant.TRUE;
  s.interpolation.enter = new PathInterpolation2dConstant(PathInterpolation2d.LINEAR_CLOSED);

  esg.updateGraph();
}


Map nevada = {
  "features":[
    {
      "code":32013,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-119.305165, 40.953176],
          [-119.324018, 40.952833],
          [-119.317604, 41.240692],
          [-119.297469, 41.241508],
          [-119.295843, 41.416764],
          [-119.313643, 41.417809],
          [-119.317869, 41.862736],
          [-119.311109, 41.863312],
          [-119.310942, 41.989135],
          [-118.185317, 41.996637],
          [-117.018864, 41.994794],
          [-116.992313, 41.994795],
          [-117.007029, 40.99352],
          [-117.010626, 40.642874],
          [-117.24323, 40.64264],
          [-117.294248, 40.52915],
          [-117.296089, 40.679717],
          [-117.633679, 40.681208],
          [-117.636419, 40.852203],
          [-118.784141, 40.852181],
          [-118.785432, 40.95153],
          [-119.305165, 40.953176]
        ]
        ]
      }
    },
    {
      "code":32007,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-115.822196, 40.126751],
          [-115.98998, 40.127752],
          [-116.154872, 40.679979],
          [-116.150521, 40.993863],
          [-116.583952, 40.994198],
          [-117.007029, 40.99352],
          [-116.992313, 41.994795],
          [-115.947545, 41.994599],
          [-115.024863, 41.996506],
          [-114.269472, 41.995924],
          [-114.039073, 41.995391],
          [-114.038151, 40.997687],
          [-114.038108, 40.111047],
          [-115.822196, 40.126751]
        ]
        ]
      }
    },
    {
      "code":32031,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-119.995304, 39.311545],
          [-119.996011, 39.443501],
          [-119.996165, 39.720611],
          [-119.996325, 41.177566],
          [-119.993459, 41.989205],
          [-119.351692, 41.988853],
          [-119.310942, 41.989135],
          [-119.311109, 41.863312],
          [-119.317869, 41.862736],
          [-119.313643, 41.417809],
          [-119.295843, 41.416764],
          [-119.297469, 41.241508],
          [-119.317604, 41.240692],
          [-119.324018, 40.952833],
          [-119.305165, 40.953176],
          [-119.318514, 40.003897],
          [-119.208593, 40.003154],
          [-119.196622, 39.945312],
          [-119.211484, 39.921471],
          [-119.187747, 39.870641],
          [-119.210048, 39.835786],
          [-119.199206, 39.814211],
          [-119.16984, 39.793863],
          [-119.155579, 39.717479],
          [-119.187806, 39.675655],
          [-119.191369, 39.635689],
          [-119.2203, 39.624298],
          [-119.267017, 39.628449],
          [-119.361464, 39.593601],
          [-119.444949, 39.590183],
          [-119.467243, 39.56118],
          [-119.508474, 39.562626],
          [-119.524946, 39.572723],
          [-119.549155, 39.548199],
          [-119.58223, 39.538448],
          [-119.613557, 39.513767],
          [-119.637713, 39.50555],
          [-119.654948, 39.503822],
          [-119.684002, 39.515449],
          [-119.679714, 39.480167],
          [-119.686634, 39.457798],
          [-119.655359, 39.433979],
          [-119.649552, 39.405533],
          [-119.657326, 39.374081],
          [-119.642897, 39.353981],
          [-119.658324, 39.336422],
          [-119.659331, 39.315086],
          [-119.682524, 39.282848],
          [-119.688162, 39.258693],
          [-119.692755, 39.238189],
          [-119.747452, 39.238806],
          [-119.748314, 39.230173],
          [-119.794481, 39.225519],
          [-119.795175, 39.212804],
          [-119.814799, 39.213269],
          [-119.814486, 39.205113],
          [-119.838237, 39.205029],
          [-119.838213, 39.189156],
          [-119.852488, 39.189736],
          [-119.85406, 39.169297],
          [-119.876041, 39.169697],
          [-119.877444, 39.160141],
          [-119.995527, 39.158713],
          [-119.995304, 39.311545]
        ]
        ]
      }
    },
    {
      "code":32015,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-116.583191, 39.159171],
          [-117.343877, 39.157582],
          [-117.765675, 39.093152],
          [-117.781454, 39.127503],
          [-117.772932, 39.162457],
          [-117.760617, 39.176586],
          [-117.731632, 39.186275],
          [-117.706554, 39.23175],
          [-117.741393, 39.328093],
          [-117.741188, 39.366175],
          [-117.730552, 39.373942],
          [-117.700765, 39.370486],
          [-117.67764, 39.379226],
          [-117.670712, 39.402835],
          [-117.632732, 39.416633],
          [-117.626903, 39.43162],
          [-117.641476, 39.463278],
          [-117.585108, 39.492568],
          [-117.5758, 39.52162],
          [-117.554902, 39.518088],
          [-117.508437, 39.525088],
          [-117.48512, 39.516566],
          [-117.458547, 39.557917],
          [-117.464117, 39.589174],
          [-117.447004, 39.620061],
          [-117.465049, 39.640397],
          [-117.456993, 39.688931],
          [-117.466302, 39.742393],
          [-117.488649, 39.774039],
          [-117.481272, 39.83346],
          [-117.462305, 39.864809],
          [-117.463153, 39.903799],
          [-117.473606, 39.94275],
          [-117.494832, 39.97667],
          [-117.534606, 39.998272],
          [-117.294248, 40.52915],
          [-117.24323, 40.64264],
          [-117.010626, 40.642874],
          [-117.007029, 40.99352],
          [-116.583952, 40.994198],
          [-116.583191, 39.159171]
        ]
        ]
      }
    },
    {
      "code":32011,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-115.899573, 39.161796],
          [-116.583191, 39.159171],
          [-116.583952, 40.994198],
          [-116.150521, 40.993863],
          [-116.154872, 40.679979],
          [-115.98998, 40.127752],
          [-115.822196, 40.126751],
          [-115.818281, 40.036027],
          [-115.826292, 40.023858],
          [-115.815449, 39.952569],
          [-115.782984, 39.850697],
          [-115.79854, 39.815934],
          [-115.798929, 39.756997],
          [-115.823458, 39.720505],
          [-115.809143, 39.609754],
          [-115.808319, 39.587076],
          [-115.82486, 39.560937],
          [-115.816253, 39.540003],
          [-115.862756, 39.466089],
          [-115.897303, 39.42832],
          [-115.899573, 39.161796]
        ]
        ]
      }
    },
    {
      "code":32027,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-117.534606, 39.998272],
          [-118.670365, 39.994215],
          [-119.208593, 40.003154],
          [-119.318514, 40.003897],
          [-119.305165, 40.953176],
          [-118.785432, 40.95153],
          [-118.784141, 40.852181],
          [-117.636419, 40.852203],
          [-117.633679, 40.681208],
          [-117.296089, 40.679717],
          [-117.294248, 40.52915],
          [-117.534606, 39.998272]
        ]
        ]
      }
    },
    {
      "code":32033,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-114.994171, 38.680836],
          [-115.900252, 39.15591],
          [-115.899573, 39.161796],
          [-115.897303, 39.42832],
          [-115.862756, 39.466089],
          [-115.816253, 39.540003],
          [-115.82486, 39.560937],
          [-115.808319, 39.587076],
          [-115.809143, 39.609754],
          [-115.823458, 39.720505],
          [-115.798929, 39.756997],
          [-115.79854, 39.815934],
          [-115.782984, 39.850697],
          [-115.815449, 39.952569],
          [-115.826292, 40.023858],
          [-115.818281, 40.036027],
          [-115.822196, 40.126751],
          [-114.038108, 40.111047],
          [-114.039845, 39.908779],
          [-114.040105, 39.538685],
          [-114.044268, 38.678996],
          [-114.994171, 38.680836]
        ]
        ]
      }
    },
    {
      "code":32001,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-118.733468, 39.077077],
          [-118.735109, 39.12103],
          [-118.781955, 39.120366],
          [-118.783313, 39.151623],
          [-118.80885, 39.152615],
          [-118.809285, 39.169838],
          [-118.834821, 39.170372],
          [-118.835768, 39.18441],
          [-118.853552, 39.183239],
          [-118.854644, 39.202717],
          [-118.87358, 39.200169],
          [-118.873466, 39.218758],
          [-118.894829, 39.21798],
          [-118.896035, 39.241535],
          [-118.909089, 39.240883],
          [-118.91015, 39.258549],
          [-118.925013, 39.258774],
          [-118.925364, 39.271915],
          [-118.946765, 39.272037],
          [-118.949001, 39.288776],
          [-118.964451, 39.288532],
          [-118.966031, 39.303016],
          [-118.984433, 39.301818],
          [-118.984769, 39.314055],
          [-119.002569, 39.312407],
          [-119.004248, 39.330061],
          [-119.017264, 39.327586],
          [-119.0195, 39.343874],
          [-119.036773, 39.3445],
          [-119.035934, 39.356752],
          [-119.049003, 39.356085],
          [-119.047668, 39.371976],
          [-119.071503, 39.372941],
          [-119.071938, 39.387898],
          [-119.087998, 39.387627],
          [-119.088365, 39.400319],
          [-119.108614, 39.400429],
          [-119.111501, 39.519625],
          [-119.078709, 39.520174],
          [-119.08093, 39.638481],
          [-119.070218, 39.640019],
          [-119.071119, 39.733863],
          [-119.113852, 39.701862],
          [-119.116332, 39.684589],
          [-119.132438, 39.68341],
          [-119.163536, 39.663833],
          [-119.167755, 39.645168],
          [-119.191369, 39.635689],
          [-119.187806, 39.675655],
          [-119.155579, 39.717479],
          [-119.16984, 39.793863],
          [-119.199206, 39.814211],
          [-119.210048, 39.835786],
          [-119.187747, 39.870641],
          [-119.211484, 39.921471],
          [-119.196622, 39.945312],
          [-119.208593, 40.003154],
          [-118.670365, 39.994215],
          [-117.534606, 39.998272],
          [-117.494832, 39.97667],
          [-117.473606, 39.94275],
          [-117.463153, 39.903799],
          [-117.462305, 39.864809],
          [-117.481272, 39.83346],
          [-117.488649, 39.774039],
          [-117.466302, 39.742393],
          [-117.456993, 39.688931],
          [-117.465049, 39.640397],
          [-117.447004, 39.620061],
          [-117.464117, 39.589174],
          [-117.458547, 39.557917],
          [-117.48512, 39.516566],
          [-117.508437, 39.525088],
          [-117.554902, 39.518088],
          [-117.5758, 39.52162],
          [-117.585108, 39.492568],
          [-117.641476, 39.463278],
          [-117.626903, 39.43162],
          [-117.632732, 39.416633],
          [-117.670712, 39.402835],
          [-117.67764, 39.379226],
          [-117.700765, 39.370486],
          [-117.730552, 39.373942],
          [-117.741188, 39.366175],
          [-117.741393, 39.328093],
          [-117.706554, 39.23175],
          [-117.731632, 39.186275],
          [-117.760617, 39.176586],
          [-117.772932, 39.162457],
          [-117.781454, 39.127503],
          [-117.765675, 39.093152],
          [-117.849061, 39.075387],
          [-118.733468, 39.077077]
        ]
        ]
      }
    },
    {
      "code":32019,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-119.318825, 38.527109],
          [-119.320153, 38.661732],
          [-119.34263, 38.664028],
          [-119.345705, 38.741496],
          [-119.376971, 38.74135],
          [-119.377841, 38.731814],
          [-119.400875, 38.732275],
          [-119.398242, 38.813937],
          [-119.405887, 38.81288],
          [-119.40337, 38.826075],
          [-119.41106, 38.82638],
          [-119.409023, 38.854076],
          [-119.42442, 38.855136],
          [-119.423977, 38.877364],
          [-119.408557, 38.87585],
          [-119.40887, 38.957002],
          [-119.391733, 38.957788],
          [-119.391871, 38.980001],
          [-119.334449, 38.980185],
          [-119.336509, 38.989215],
          [-119.316954, 38.988677],
          [-119.317024, 39.083885],
          [-119.528017, 39.081131],
          [-119.561536, 39.140297],
          [-119.55367, 39.186708],
          [-119.643992, 39.188449],
          [-119.673313, 39.210494],
          [-119.688162, 39.258693],
          [-119.62202, 39.270535],
          [-119.587671, 39.29075],
          [-119.468534, 39.337153],
          [-119.267017, 39.628449],
          [-119.2203, 39.624298],
          [-119.191369, 39.635689],
          [-119.167755, 39.645168],
          [-119.163536, 39.663833],
          [-119.132438, 39.68341],
          [-119.116332, 39.684589],
          [-119.113852, 39.701862],
          [-119.071119, 39.733863],
          [-119.070218, 39.640019],
          [-119.08093, 39.638481],
          [-119.078709, 39.520174],
          [-119.111501, 39.519625],
          [-119.108614, 39.400429],
          [-119.088365, 39.400319],
          [-119.087998, 39.387627],
          [-119.071938, 39.387898],
          [-119.071503, 39.372941],
          [-119.047668, 39.371976],
          [-119.049003, 39.356085],
          [-119.035934, 39.356752],
          [-119.036773, 39.3445],
          [-119.0195, 39.343874],
          [-119.017264, 39.327586],
          [-119.004248, 39.330061],
          [-119.002569, 39.312407],
          [-118.984769, 39.314055],
          [-118.984433, 39.301818],
          [-118.966031, 39.303016],
          [-118.964451, 39.288532],
          [-118.949001, 39.288776],
          [-118.946765, 39.272037],
          [-118.925364, 39.271915],
          [-118.925013, 39.258774],
          [-118.91015, 39.258549],
          [-118.909089, 39.240883],
          [-118.896035, 39.241535],
          [-118.894829, 39.21798],
          [-118.873466, 39.218758],
          [-118.87358, 39.200169],
          [-118.854644, 39.202717],
          [-118.853552, 39.183239],
          [-118.835768, 39.18441],
          [-118.834821, 39.170372],
          [-118.809285, 39.169838],
          [-118.80885, 39.152615],
          [-118.783313, 39.151623],
          [-118.781955, 39.120366],
          [-118.735109, 39.12103],
          [-118.733468, 39.077077],
          [-118.919562, 39.075249],
          [-119.007339, 38.948283],
          [-119.003035, 38.856325],
          [-118.896022, 38.854834],
          [-118.892748, 38.774191],
          [-118.902186, 38.774046],
          [-118.891576, 38.410194],
          [-119.15245, 38.411801],
          [-119.318825, 38.527109]
        ]
        ]
      }
    },
    {
      "code":32029,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-119.688162, 39.258693],
          [-119.682524, 39.282848],
          [-119.659331, 39.315086],
          [-119.658324, 39.336422],
          [-119.642897, 39.353981],
          [-119.657326, 39.374081],
          [-119.649552, 39.405533],
          [-119.655359, 39.433979],
          [-119.686634, 39.457798],
          [-119.679714, 39.480167],
          [-119.684002, 39.515449],
          [-119.654948, 39.503822],
          [-119.637713, 39.50555],
          [-119.613557, 39.513767],
          [-119.58223, 39.538448],
          [-119.549155, 39.548199],
          [-119.524946, 39.572723],
          [-119.508474, 39.562626],
          [-119.467243, 39.56118],
          [-119.444949, 39.590183],
          [-119.361464, 39.593601],
          [-119.267017, 39.628449],
          [-119.468534, 39.337153],
          [-119.587671, 39.29075],
          [-119.62202, 39.270535],
          [-119.688162, 39.258693]
        ]
        ]
      }
    },
    {
      "code":32510,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-119.528017, 39.081131],
          [-119.736852, 39.083958],
          [-119.736654, 39.094395],
          [-119.753904, 39.095826],
          [-119.75379, 39.108525],
          [-119.994541, 39.106132],
          [-119.995527, 39.158713],
          [-119.877444, 39.160141],
          [-119.876041, 39.169697],
          [-119.85406, 39.169297],
          [-119.852488, 39.189736],
          [-119.838213, 39.189156],
          [-119.838237, 39.205029],
          [-119.814486, 39.205113],
          [-119.814799, 39.213269],
          [-119.795175, 39.212804],
          [-119.794481, 39.225519],
          [-119.748314, 39.230173],
          [-119.747452, 39.238806],
          [-119.692755, 39.238189],
          [-119.688162, 39.258693],
          [-119.673313, 39.210494],
          [-119.643992, 39.188449],
          [-119.55367, 39.186708],
          [-119.561536, 39.140297],
          [-119.528017, 39.081131]
        ]
        ]
      }
    },
    {
      "code":32023,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-115.88137, 36.838899],
          [-115.885769, 36.001226],
          [-117.160424, 36.959594],
          [-117.155079, 37.992236],
          [-117.208358, 38.041559],
          [-117.232323, 38.042875],
          [-117.232376, 38.060552],
          [-117.681458, 38.457277],
          [-118.182828, 38.897237],
          [-118.180937, 38.999701],
          [-117.849061, 39.075387],
          [-117.765675, 39.093152],
          [-117.343877, 39.157582],
          [-116.583191, 39.159171],
          [-115.899573, 39.161796],
          [-115.900252, 39.15591],
          [-114.994171, 38.680836],
          [-114.995666, 38.046203],
          [-115.884105, 38.044806],
          [-115.88137, 36.838899]
        ]
        ]
      }
    },
    {
      "code":32005,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-119.575687, 38.70291],
          [-119.889342, 38.922252],
          [-119.995255, 38.994106],
          [-119.99515, 39.063491],
          [-119.994541, 39.106132],
          [-119.75379, 39.108525],
          [-119.753904, 39.095826],
          [-119.736654, 39.094395],
          [-119.736852, 39.083958],
          [-119.528017, 39.081131],
          [-119.317024, 39.083885],
          [-119.316954, 38.988677],
          [-119.336509, 38.989215],
          [-119.334449, 38.980185],
          [-119.391871, 38.980001],
          [-119.391733, 38.957788],
          [-119.40887, 38.957002],
          [-119.408557, 38.87585],
          [-119.423977, 38.877364],
          [-119.42442, 38.855136],
          [-119.409023, 38.854076],
          [-119.41106, 38.82638],
          [-119.40337, 38.826075],
          [-119.405887, 38.81288],
          [-119.398242, 38.813937],
          [-119.400875, 38.732275],
          [-119.377841, 38.731814],
          [-119.376971, 38.74135],
          [-119.345705, 38.741496],
          [-119.34263, 38.664028],
          [-119.320153, 38.661732],
          [-119.318825, 38.527109],
          [-119.575687, 38.70291]
        ]
        ]
      }
    },
    {
      "code":32021,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-118.41742, 37.886677],
          [-119.15245, 38.411801],
          [-118.891576, 38.410194],
          [-118.902186, 38.774046],
          [-118.892748, 38.774191],
          [-118.896022, 38.854834],
          [-119.003035, 38.856325],
          [-119.007339, 38.948283],
          [-118.919562, 39.075249],
          [-118.733468, 39.077077],
          [-117.849061, 39.075387],
          [-118.180937, 38.999701],
          [-118.182828, 38.897237],
          [-117.681458, 38.457277],
          [-118.340414, 37.88573],
          [-118.41742, 37.886677]
        ]
        ]
      }
    },
    {
      "code":32017,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-114.043716, 36.841849],
          [-114.870837, 36.843424],
          [-114.871722, 36.852965],
          [-114.895855, 36.853842],
          [-115.730457, 36.853729],
          [-115.73067, 36.841487],
          [-115.88137, 36.838899],
          [-115.884105, 38.044806],
          [-114.995666, 38.046203],
          [-114.994171, 38.680836],
          [-114.044268, 38.678996],
          [-114.04509, 38.571095],
          [-114.047273, 38.137652],
          [-114.047261, 37.598478],
          [-114.043939, 36.996538],
          [-114.043716, 36.841849]
        ]
        ]
      }
    },
    {
      "code":32009,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-117.160424, 36.959594],
          [-117.838686, 37.457298],
          [-118.41742, 37.886677],
          [-118.340414, 37.88573],
          [-117.681458, 38.457277],
          [-117.232376, 38.060552],
          [-117.232323, 38.042875],
          [-117.208358, 38.041559],
          [-117.155079, 37.992236],
          [-117.160424, 36.959594]
        ]
        ]
      }
    },
    {
      "code":32003,
      "type":"Feature",
      "geometry":{
        "type":"Polygon",
        "coordinates":[[
          [-114.621069, 34.998914],
          [-115.626197, 35.795698],
          [-115.885769, 36.001226],
          [-115.88137, 36.838899],
          [-115.73067, 36.841487],
          [-115.730457, 36.853729],
          [-114.895855, 36.853842],
          [-114.871722, 36.852965],
          [-114.870837, 36.843424],
          [-114.043716, 36.841849],
          [-114.037392, 36.216023],
          [-114.045106, 36.193978],
          [-114.107775, 36.121091],
          [-114.129023, 36.04173],
          [-114.206769, 36.017255],
          [-114.233473, 36.018331],
          [-114.307588, 36.062233],
          [-114.303857, 36.087108],
          [-114.316095, 36.111438],
          [-114.344234, 36.13748],
          [-114.380803, 36.150991],
          [-114.443946, 36.121053],
          [-114.466613, 36.124711],
          [-114.530574, 36.15509],
          [-114.598935, 36.138335],
          [-114.621611, 36.141967],
          [-114.712762, 36.105181],
          [-114.72815, 36.085963],
          [-114.728966, 36.058753],
          [-114.717674, 36.036758],
          [-114.736213, 35.987648],
          [-114.699276, 35.911612],
          [-114.6616, 35.880474],
          [-114.662462, 35.87096],
          [-114.689867, 35.847442],
          [-114.68274, 35.764703],
          [-114.68882, 35.732596],
          [-114.665091, 35.693099],
          [-114.668486, 35.656399],
          [-114.654066, 35.646584],
          [-114.639867, 35.611349],
          [-114.653134, 35.584833],
          [-114.649792, 35.546637],
          [-114.672215, 35.515754],
          [-114.645396, 35.450761],
          [-114.589584, 35.358379],
          [-114.58789, 35.304768],
          [-114.559583, 35.220183],
          [-114.56104, 35.174346],
          [-114.572255, 35.140068],
          [-114.582616, 35.13256],
          [-114.626441, 35.133907],
          [-114.635909, 35.118656],
          [-114.595632, 35.076058],
          [-114.63378, 35.041863],
          [-114.621069, 34.998914]
        ]
        ]
      }
    }
  ],
  "type":"FeatureCollection"
};
