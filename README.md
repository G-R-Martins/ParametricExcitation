# **Parametric Excitation**
Source code of a parametric excitation research developed at `Universidade de São Paulo`.

## Reduced order model (ROM)
The [main code](https://github.com/G-R-Martins/ParametricExcitation/tree/main/Matlab) (write in [Matlab](https://www.mathworks.com/products/matlab.html)) is a simple tool to evaluate the dynamics of a vertical slender beam under parametric excitation. This code also can do a comparison with some numerical simulations (in the present case, an in-house FEM solver was used, called **Giraffe**).

- Assumptions about the model:
  1. Bernoulli-Euler beam formulation;
  2. Considering small strain hypothesis, but large displacement;
  3. Temporal-spatial separation of the response using three modes;
  4. Galerkin's method with three sinusoidal shape functions.

### Mathematical formulation
Obtaining the ROM can be a laborious task, thus to help with this, a [Wolfram Mathematica](https://www.wolfram.com/mathematica/) script is provided [here](https://github.com/G-R-Martins/ParametricExcitation/blob/main/Mathematica/NonDim-Eqs.nb). With this script one can obtain and check the nondimensional equations of the ROM and easily perform some different postprocessing.

## FEM solver - Giraffe
The **Giraffe** (Generic Interface For Finite Element) code was used to evaluate numerically the beam. It is a FEM-based solver, also developed at `Universidade de São Paulo` by prof. [Alfredo Gay Neto](http://sites.poli.usp.br/p/alfredo.gay/) and his research group. In this study, we are using the Giraffe Timoshenko's geometrically exact beam formulation.
