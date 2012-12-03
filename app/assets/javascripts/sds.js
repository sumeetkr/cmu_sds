var SDS = SDS || {};

SDS.treeData = [
    {
        label: 'Building23',
        children: [
            {
                label: '129A',
                children: [
                    {
                        label: 'Fire Fly'
                    },
                    {
                        label: 'Super Bug'
                    }
                ]
            },
            { label: 'Noisy boy' }
        ]
    },
    {
        label: 'Building19',
        children: [
            {
                label: '1055',
                children: [
                    {
                        label: 'Fire Fly'
                    },
                    {
                        label: 'Super Bug'
                    }
                ]
            }
        ]
    }
];


SDS.chart = function() {

    var me = this;

    $("#submit").click(function() {
        me.drawChart();
    });
};

SDS.chart.prototype = {

    drawChart: function() {
        var startDate = $("#statDate").val();
        var endDate = $("#endDate").val();
        var me = this;
        $("#chart").empty();

        var startDateVal = $("#startDate").val().split("/");
        if (startDateVal.length == 3) {
            var startDate = new Date(startDateVal[2], startDateVal[0], startDateVal[1]).valueOf();
        }

        var endDateVal = $("#endDate").val().split("/");
        if (endDateVal.length == 3) {
            var endDate = new Date(endDateVal[2], endDateVal[0], endDateVal[1]).valueOf();
        }

        var url = "/sensor_readings/1?1=1";
        if (startDate) {
            url += "&startTime=" + startDate;
        }
        if (endDate) {
            url += "&endTime=" + endDate;
        }

        $.ajax({
            url: url,
            success: function(data) {
                var rawData = eval(data);
                me._drawChart(rawData);
            }
        });
    },

    setSensorName: function(name) {
        this.sensorName = name;
    },

    _drawLineChart: function(rawData) {
        var data = [];
        for (var i = 0; i < rawData.length; i++) {
            var element = rawData[i];
            var date = new Date(parseFloat(element["timestamp"]));
            console.log(date);
            var temp = parseInt(element["temp"]) / 10 - 30;
            console.log(temp);
            var newElement = [];
            newElement.push(date);
            newElement.push(temp);
            data.push(newElement);
        }
        var me = this;
        var plot1 = $.jqplot('chart', [data], {
            title: "Data of " + me.sensorName + ":",
            series: [{
                neighborThreshold: 0
            }],
            axes: {
                xaxis: {
                    renderer:$.jqplot.DateAxisRenderer,
                    min:'Nov 20, 2012 12:00:00',
                    tickInterval: "1 minutes",
                    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                    tickOptions:{formatString:"%#H:%#M", angle: -40}
                },
                yaxis: {
                    renderer: $.jqplot.LogAxisRenderer,
                    tickOptions:{prefix: '℃'}
                }
            },

            cursor: {
                show: true,
                zoom: false,
                looseZoom: false,
                showTooltip: true
            }
        });
    },

    _drawPieChart: function() {
        var data = [
            ['0 ℃ - 8℃', 12],['9℃ - 16 ℃', 9], ['17℃ - 24℃', 14],
            ['25℃ - 32℃', 16],['33℃ - 40℃', 7], ["< 0 ℃", 9]
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

(function($) {
    var pathname = window.location.pathname;
    if (pathname == "" || pathname == "/") {
        $(".left-part").removeClass("hidden");
    }
    else {
        $(".left-part").addClass("hidden");
    }

    $(".datepicker").datepicker();
    $.jqplot.config.enablePlugins = true;

    var chart = new SDS.chart();

    $('#sensor-tree').tree({
        data: SDS.treeData,
        selectable: true
    });

    $('#sensor-tree').bind('tree.select', function(event) {
        var node = event.node;
        chart.setSensorName(node.name);
    });

}(jQuery));