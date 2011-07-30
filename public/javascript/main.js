$(function () {

  var center = { x : 150, y : 150 }, radius = 110;

  var rads = function(degs) {
    return (Math.PI/180) * degs;
  },
  percentToPosition = function (percent) {
    var anglePercentage = percent * Math.PI + Math.PI;
    return {
      x : center.x + radius * Math.cos(anglePercentage),
      y : center.y + radius * Math.sin(anglePercentage)
    };
  },
  getBodyPosition = function(isday, sunrise, sunset, hour) {
    var range, arcPercent;
    if(isday) {
      range = sunset - sunrise;
      arcPercent = ((hour-sunrise) / range);
    }
    else {
      range = (sunrise+24) - sunset;
      arcPercent = ((hour - sunset) / range);
    }

    return percentToPosition(arcPercent);
  };

  var draw = function(idx, canvas) {
    var $canvas = $(canvas),
        ctx = canvas.getContext('2d'),
        hour = parseInt($canvas.data('hour'), 10),
        sunrise = 6, sunset = 18,
        day = '#7ad3fc', night = '#025075',
        moon = '#919191', sun = '#facd40',
        isday = hour > sunrise && hour < sunset ? true  : false,
        skyColor = isday ? day : night,
        bodyColor = isday ? sun : moon,
        p = getBodyPosition(isday, sunrise, sunset, hour);

    ctx.beginPath();
    ctx.lineWidth = 40;
    ctx.strokeStyle = skyColor;
    ctx.arc(center.x, center.y, radius, 0, Math.PI, true);
    ctx.stroke();
    ctx.closePath();

    ctx.beginPath();
    ctx.fillStyle = bodyColor;
    ctx.arc(p.x, p.y, 50, 0, Math.PI*2, true);
    ctx.fill();
  };

  $('canvas').each(draw);
});
