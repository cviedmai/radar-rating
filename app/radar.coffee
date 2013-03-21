axisName = ['Effort', 'Skills', 'Charisma']

data = [
  {key: 'cris', value: 37, area: 0},
  {key: 'cris', value: 13, area: 1},
  {key: 'cris', value: 51, area: 2},
  {key: 'karl', value: 34, area: 0},
  {key: 'karl', value: 45, area: 1},
  {key: 'karl', value: -20, area: 2}
]

width = 960
height = 500
outerRadius = height / 2 - 10
innerRadius = 50
angle = d3.time.scale().range([0, 2 * Math.PI])
colors = d3.scale.category20c()
radius = d3.scale.linear().range([innerRadius, outerRadius])
stack = d3.layout.stack().offset("zero").values((d) -> d.values)
  .x((d) -> d.area).y((d) -> d.value)
nest = d3.nest().key((d) -> d.key )
layers = stack(nest.entries(data))
# Extend the domain slightly to match the range of [0, 2π].
angle.domain [0, d3.max(data, (d) -> d.area + 1)]
radius.domain [0, d3.max(data, (d) -> d.y0 + d.y)]

line = d3.svg.line.radial().interpolate("cardinal-closed").angle((d) ->angle d.area)
  .radius((d) -> radius d.y0 + d.y)

area = d3.svg.area.radial().interpolate("cardinal-closed").angle((d) -> angle d.area)
  .innerRadius((d) -> radius d.y0).outerRadius((d) -> radius d.y0 + d.y)

svg = d3.select("body").append("svg").attr("width", width).attr("height", height)
  .append("g").attr("transform", "translate(#{width / 2}, #{height / 2})")

svg.selectAll(".layer").data(layers).enter().append("path").attr("class", "layer")
  .attr("d", (d) -> area d.values).style("fill", (d, i) -> colors(i))

svg.selectAll(".axis").data(d3.range(angle.domain()[1])).enter().append("g")
  .attr("class", "axis").attr("transform", (d) -> "rotate(#{angle(d) * 180 / Math.PI})")
  .call(d3.svg.axis().scale(radius.copy().range([-innerRadius, -outerRadius])).orient("left"))
  .append("text").attr("y", -innerRadius + 6).attr("dy", ".71em").attr("text-anchor", "middle")
  .text (d) -> axisName[d]

