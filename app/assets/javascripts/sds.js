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
        $.ajax({
            url: '/',
            success: function() {
                var data = eval("[{'id':'1','temp':'510','timestamp':'1353441771000.0'},{'id':'1','temp':'520','timestamp':'1353441831000.0'},{'id':'1','temp':'530','timestamp':'1353441891000.0'},{'id':'1','temp':'540','timestamp':'1353441951000.0'},{'id':'1','temp':'550','timestamp':'1353442011000.0'},{'id':'1','temp':'560','timestamp':'1353442071000.0'},{'id':'1','temp':'570','timestamp':'1353442131000.0'},{'id':'1','temp':'580','timestamp':'1353442191000.0'},{'id':'1','temp':'590','timestamp':'1353442251000.0'},{'id':'1','temp':'600','timestamp':'1353442311000.0'},{'id':'1','temp':'610','timestamp':'1353442371000.0'},{'id':'1','temp':'620','timestamp':'1353442431000.0'},{'id':'1','temp':'630','timestamp':'1353442491000.0'},{'id':'1','temp':'640','timestamp':'1353442551000.0'},{'id':'1','temp':'650','timestamp':'1353442611000.0'},{'id':'1','temp':'660','timestamp':'1353442671000.0'},{'id':'1','temp':'670','timestamp':'1353442731000.0'},{'id':'1','temp':'680','timestamp':'1353442791000.0'},{'id':'1','temp':'690','timestamp':'1353442851000.0'},{'id':'1','temp':'700','timestamp':'1353442911000.0'},{'id':'1','temp':'710','timestamp':'1353442971000.0'},{'id':'1','temp':'720','timestamp':'1353443031000.0'},{'id':'1','temp':'730','timestamp':'1353443091000.0'},{'id':'1','temp':'740','timestamp':'1353443151000.0'},{'id':'1','temp':'750','timestamp':'1353443211000.0'},{'id':'1','temp':'750','timestamp':'1353443271000.0'},{'id':'1','temp':'740','timestamp':'1353443331000.0'},{'id':'1','temp':'730','timestamp':'1353443391000.0'},{'id':'1','temp':'720','timestamp':'1353443451000.0'},{'id':'1','temp':'710','timestamp':'1353443511000.0'},{'id':'1','temp':'700','timestamp':'1353443571000.0'},{'id':'1','temp':'690','timestamp':'1353443631000.0'},{'id':'1','temp':'680','timestamp':'1353443691000.0'},{'id':'1','temp':'670','timestamp':'1353443751000.0'},{'id':'1','temp':'660','timestamp':'1353443811000.0'},{'id':'1','temp':'650','timestamp':'1353443871000.0'},{'id':'1','temp':'640','timestamp':'1353443931000.0'},{'id':'1','temp':'630','timestamp':'1353443991000.0'},{'id':'1','temp':'620','timestamp':'1353444051000.0'},{'id':'1','temp':'610','timestamp':'1353444111000.0'},{'id':'1','temp':'600','timestamp':'1353444171000.0'},{'id':'1','temp':'590','timestamp':'1353444231000.0'},{'id':'1','temp':'580','timestamp':'1353444291000.0'},{'id':'1','temp':'570','timestamp':'1353444351000.0'},{'id':'1','temp':'560','timestamp':'1353444411000.0'},{'id':'1','temp':'550','timestamp':'1353444471000.0'},{'id':'1','temp':'540','timestamp':'1353444531000.0'},{'id':'1','temp':'530','timestamp':'1353444591000.0'},{'id':'1','temp':'520','timestamp':'1353444651000.0'},{'id':'1','temp':'510','timestamp':'1353444711000.0'}]");
                me._drawChart(data);
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