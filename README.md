# GHKT Energy

MATLAB code for adapting the GHKT integrated assessment model of the energy
transition (Golosov, Hassler, Krusell and Tsyvinski, 2014, *Econometrica*) to
study how limited substitutability in the energy transition affects welfare.
The adaptation replaces the Cobb-Douglas production function with an
exergy-based CD-in-CES production function.

This is a work in progress.

## Requirements

* MATLAB R2025a
* Optimization Toolbox (the model is solved with `fmincon`)

## Run the baseline model

From `src/ghkt_replication`:

```matlab
p = LoadParams();   % all baseline parameters in one struct
GHKT_Main           % solves the model and saves the results
GHKT_Figures        % makes the figures, one section at a time
```

`LoadParams` returns every baseline parameter, including derived ones, and
any input can be overridden by name, for example `LoadParams(T = 20)`.
`GHKT_Main` starts from the saved optimum `x_ghkt_v1.mat`.

The reorganised baseline reproduces the earlier replication (kept in
`src/archive`): the saved results and all baseline figures are identical.

## Repository structure

```
src/
├── archive/            Old model versions and experiments
├── ghkt_original/      Original code of the GHKT authors (unchanged)
├── ghkt_replication/   Baseline replication, reorganised: parameters
│                       (LoadParams), model run (GHKT_Main) and figures
│                       (GHKT_Figures) are separate
├── ghkt_cd_in_ces/     GHKT with a CD-in-CES production function
└── newces/             CES-in-CD formulation in energy-based units
```