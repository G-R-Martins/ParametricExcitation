# **ParametricExcitation**
Source code of a parametric excitation research developed at `Universidade de São Paulo`.

## Introduction
This is a simple script that allows evaluating the dynamics of a vertical beam under parametric excitation. 
- Assumptions about the model:
  1. Bernoulli-Euler beam formulation;
  2. Considering small strain hypothesis;
  3. Temporal-spatial separation of the response using three modes;
  4. Galerkin's method with three sinusoidal shape functions.

The `Giraffe` (Generic Interface For Finite Element) code was used to evaluate numerically the beam. It is a FEM-based solver, also developed at `Universidade de São Paulo` by prof. Alfredo Gay Neto and his research group. Giraffe uses a geometrically exact beam formulation and a updated-lagrangian approach to solve the nonlinear equations. For more details see <http://sites.poli.usp.br/p/alfredo.gay/>;

The nondimensional equations of the ROM was calculated with Wolfram Mathematica (see <https://www.wolfram.com/mathematica/>), which code is also available - in the folder 'Mathematica'.
