# Progress

Simple circular progress bar with animating progress with percentage with pulsating animation also. 


# How to use


```ios
///Create a IBOutlet instance of circular progress bar OR create local instance to use it programatically instead of .xib
@IBOutlet weak var progressBar: CircularProgressBar!
progressBar.labelSize = 30
progressBar.safePercent = 100
// Set progress value which you want to set. Progress is from 0.0 to 1.0
progressBar.setProgress(to: progress, withAnimation: true)
```
