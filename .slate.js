// this does nothing...
// @TODO do something

// Configs
S.cfga({
  "defaultToCurrentScreen" : true,
  "secondsBetweenRepeat" : 0.1,
  "checkDefaultsOnLoad" : true,
  "focusCheckWidthMax" : 3000
});


// Monitors
var monBig = "2560x1440";
var monRight = "1680x1050";
var monLeft = "1920x1080";

// 2 monitor layout
var twoMonitorLayout = S.lay("twoMonitor", {
  },
});

// 1 monitor layout
var oneMonitorLayout = S.lay("oneMonitor", {
});

// Defaults
S.def([monRight, monLeft], twoMonitorLayout);
S.def([monBig], oneMonitorLayout);

// Layout Operations
var twoMonitor = S.op("layout", { "name" : twoMonitorLayout });
var oneMonitor = S.op("layout", { "name" : oneMonitorLayout });
var universalLayout = function() {
  // Should probably make sure the resolutions match but w/e
  if (S.screenCount() === 2) {
    twoMonitor.run();
  } else if (S.screenCount() === 1) {
    oneMonitor.run();
  }
};


// Batch bind everything. Less typing.
S.bnda({
  // Grid
  "esc:ctrl" : S.op("grid")
});
