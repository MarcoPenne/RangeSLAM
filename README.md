# Range Only 2D SLAM
## 0. How to run
```bash
$ cd path/to/the/repo
$ octave

octave:1> run main.m
```

## 1. What it does

* Load datasets (initial guess and ground truth)
* Initialize landmarks with LS, checking if the landmark is enough constrained (e.g. at least 3 observations that are not too similar)
* Solve ICP using measurement constrains and odometry constrains (information matrices depend on the iteration, exponential decay)
* At the end, we transformate all the elements according to a common reference, so to have beautiful plots
