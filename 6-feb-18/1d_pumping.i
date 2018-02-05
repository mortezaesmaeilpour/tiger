[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = ???
  nx = 100
[]

[UserObjects]
  [./water_uo]
    type = TigerFluidConst
  [../]
  [./rock_uo1]
    type =  TigerPermeabilityConst
    permeability_type = isotropic
    k0 = ???
  [../]
[]

[Materials]
  [./rock_h1]
    type = TigerRockMaterialH
    fp_UO = water_uo
    porosity = 0.0
    compressibility = ???
    kf_UO = rock_uo1
  [../]
[]

[BCs]
  [./right]
    type = DirichletBC
    variable = pressure
    boundary = right
    value = ???
  [../]
[]

[Functions]
  [./analytical_function]
    type = ParsedFunction
    vars = 'Q T R'
    vals = '0.04 2.3e-3 250'
    value = '1.818e5-1e4*Q/(2*3.14*T)*log(R/x)'
  [../]
[]

[AuxVariables]
  [./vx]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./analytical_solution]
    family = LAGRANGE
    order = FIRST
  [../]
[]

[AuxKernels]
  [./vx_ker]
    type = TigerDarcyVelocityComponent
    gradient_variable = pressure
    variable =  vx
    component = x
  [../]
  [./a_ker]
    type = FunctionAux
    function = analytical_function
    variable = analytical_solution
    execute_on = initial
  [../]
[]

[Variables]
  [./pressure]
    initial_condition = ???
  [../]
[]

[DiracKernels]
  [./pumpout]
    type = TigerPointSourceH
    point = '0.0 0.0 0.0'
    mass_flux = ???
    variable = pressure
  [../]
[]


[Kernels]
  [./diff]
    type = TigerKernelH
    variable = pressure
  [../]
  [./time]
    type = TigerTimeDerivativeH
    variable = pressure
  [../]
[]

[Preconditioning]
  [./pre]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -snes_type -pc_type -pc_factor_shift_type -pc_factor_shift_amount -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = '  gmres     newtontr     asm          NONZERO               1E-12               1E-10       1E-15       250     '
  [../]
[]

[Executioner]
  #type = Steady
  type = Transient
  num_steps = ???
  end_time = ???
  solve_type = NEWTON
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
[]