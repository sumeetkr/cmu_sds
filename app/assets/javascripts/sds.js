var SDS = SDS || {};

SDS.chart = function() {

    var me = this;

    $("#submit").click(function() {
        me.drawChart();
    });
};

SDS.chart.prototype = {

    drawChart: function() {
        var startDate = $("#start_date").val();
        var endDate = $("#end_date").val();
        var me = this;
        $("#chart").empty();

        var startDateVal = $("#start_date").val().split("/");
        if (startDateVal.length == 3) {
            var startDate = new Date(startDateVal[2], startDateVal[0] - 1, startDateVal[1]).valueOf();
        }

        var endDateVal = $("#end_date").val().split("/");
        if (endDateVal.length == 3) {
            var endDate = new Date(endDateVal[2], endDateVal[0] - 1, endDateVal[1]).valueOf();
        }

        var parts = this.sensorName.split(".");
        if (parts.length > 0) {
            var sensorId = parts[0];
        }
        else {
            var sensorId = 1;
        }

        var url = "/sensor_readings/" + sensorId + "?1=1";
        if (startDate) {
            url += "&startTime=" + startDate;
        }
        if (endDate) {
            url += "&endTime=" + endDate;
        }

        $.ajax({
            url: url,
            success: function(data) {
                var rawData = data;
                me._drawChart(rawData);
            }
        });
    },

    setSensorName: function(name) {
        this.sensorName = name;
    },

    _drawLineChart: function(rawData) {
        var data = [];
        var startDateVal = $("#start_date").val().split("/");
        if (startDateVal.length == 3) {
            var startDate = new Date(startDateVal[2], startDateVal[0] - 1, startDateVal[1]).valueOf();
        }

        var endDateVal = $("#end_date").val().split("/");
        if (endDateVal.length == 3) {
            var endDate = new Date(endDateVal[2], endDateVal[0] - 1, endDateVal[1]).valueOf();
        }

        for (var i = 0; i < rawData.length; i++) {
            var element = rawData[i];
            var date = new Date(parseFloat(element["timestamp"]));
            var temp = element["temp"];
            var newElement = [];
            newElement.push(date);
            newElement.push(temp);
            data.push(newElement);
        }
        var me = this;
        var plot = $.jqplot('chart', [data], {
            title: "Data of " + me.sensorName + ":",
            series: [{
                neighborThreshold: 0
            }],
            axes: {
                xaxis: {
                    renderer:$.jqplot.DateAxisRenderer,
                    min: startDate ? startDate : 'Nov 20, 2012 12:00:00',
                    max: endDate ? endDate : 'Nov 20, 2012 14:00:00',
                    numberTicks: 12,
                    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                    tickOptions:{formatString:"%#m-%#d %#H:%#M", angle: -40}
                },
                yaxis: {
                    renderer: $.jqplot.LogAxisRenderer,
                    tickOptions:{prefix: 'f'}
                }
            },

            cursor: {
                zoom: true,
                looseZoom: true
            }
        });
    },

    _drawPieChart: function(rawData) {

        var below300 = 0;
        var between300and400 = 0;
        var between400and500 = 0;
        var between500and600 = 0;
        var above600 = 0;

        for (var i = 0; i < rawData.length; i++) {
            var element = rawData[i];
            var temp = parseInt(element["temp"]);
            if (temp < 60) {
                below300++;
            }
            else if (temp >= 60 && temp < 70) {
                between300and400++;
            }
            else if (temp >= 70 && temp < 80) {
                between400and500++;
            }
            else if (temp >= 80 && temp < 90) {
                between500and600++;
            }
            else {
                above600++;
            }
        }

        var data = [
            ['< 60', below300],['60 - 70', between300and400], ['70 - 80', between400and500],
            ['80 - 90', between500and600],['> 90', above600]
        ];
        var plot1 = jQuery.jqplot ('chart', [data],
            {
                seriesDefaults: {
                    // Make this a pie chart.
                    renderer: jQuery.jqplot.PieRenderer,
                    rendererOptions: {
                        // Put data labels on the pie slices.
                        // By default, labels show the percentage of the slice.
                        showDataLabels: true
                    }
                },
                legend: { show:true, location: 'e' }
            }
        );
    },

    _drawChart: function(rawData) {
        var chartType = $("#chartType").find("option:selected").val();
        if (chartType === "Line") {
            this._drawLineChart(rawData);
        }
        else {
            this._drawPieChart(rawData);
        }
    }
};

SDS.loadSensor = function() {
    $.ajax({
        url: "/devices.json",
        success: function(rawData) {
            var data = [];
            for (var i = 0; i < rawData.length; i++) {
                var element = rawData[i];
                var device = {
                    label: element.uri,
                    children: []
                };
                for (var j = 0; j < element.sensors.length; j++) {
                    var sensorElement = element.sensors[j];
                    var sensor = {
                        label: sensorElement.uri
                    };
                    device.children.push(sensor);
                }
                data.push(device);
            }

            $('#sensor-tree').tree({
                data: data,
                selectable: true
            });
        }
    });
};

(function($) {
    var pathname = window.location.pathname;
    if (pathname == "/dashboard") {
        $(".left-part").removeClass("hidden");
        SDS.loadSensor();
    }
    else {
        $(".left-part").addClass("hidden");
    }

    $(".datepicker").datepicker();
    $.jqplot.config.enablePlugins = true;

    var chart = new SDS.chart();

    $('#sensor-tree').bind('tree.select', function(event) {
        var node = event.node;
        chart.setSensorName(node.name);
    });

}(jQuery));