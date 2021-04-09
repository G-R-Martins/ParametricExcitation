# **ParametricExcitation**
Source code of a parametric excitation research developed at `Universidade de São Paulo`.

## Introduction
This is a simple script that allows evaluating the dynamics of a vertical beam under parametric excitation. 
- Assumptions about the model:
  1. Bernoulli-Euler beam formulation
  2. Linearity (both geometric and physic)
  3. Temporal-spatial separation of the response using three modes
  4. Galerkin's method with three sinusoidal shape functions

The comparisons were made with a FEM-solver, also developed at `Universidade de São Paulo`, called `Giraffe` (Generic Interface For Finite Element - http://sites.poli.usp.br/p/alfredo.gay/) and these models were construct with a preprocessor tool for the solver, called `GiraffeMoor`. 

