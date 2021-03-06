[Mesh]
  type = FileMesh
  file = ex_hdr2.msh
[]

[GlobalParams]
  fp_UO = water_uo
  output_Pe_Cr_numbers = true
[]

[Modules]
  [./FluidProperties]
    [./water_uo]
      type = SimpleFluidProperties
      density0 = 1000
      viscosity = 0.0002
      cp = 4200
      thermal_conductivity = 0.65
      bulk_modulus = 2.5e+09
    [../]
  [../]
[]

[UserObjects]
  [./matrix_uo1]
    type =  TigerPermeabilityConst
    permeability_type = isotropic
    k0 = '1.0e-15'
  [../]
  [./fracture_uo1]
    type =  TigerPermeabilityConst
    permeability_type = isotropic
    k0 = '8.3333e-10'
  [../]
[]

[Materials]
  [./matrix_h]
    type = TigerRockMaterialH
    kf_UO = matrix_uo1
    scaling_factor = 100 #height of the unit
    porosity = 0.1
    compressibility = 1.0e-10
    block = 'unit'
  [../]
  [./matrix_t]
    type = TigerCoupledThermalMaterialTH
    porosity = 0.1
    scaling_factor = 1.0
    conductivity_type = isotropic
    mean_calculation_type = geometric
    lambda = 3
    density = 2600
    specific_heat = 950
    pressure = pressure
    has_supg = false
    block = 'unit'
  [../]
  [./fracure_h]
    type = TigerRockMaterialH
    kf_UO = fracture_uo1
    scaling_factor = 0.01 #area of the fracture
    porosity = 1.0
    compressibility = 4.0e-10
    block = 'frac1 frac2'
  [../]
  [./fracture_t]
    type = TigerCoupledThermalMaterialTH
    porosity = 1.0
    conductivity_type = isotropic
    mean_calculation_type = geometric
    lambda = 3
    scaling_factor = 0.0001
    density = 2600
    specific_heat = 950
    pressure = pressure
    has_supg = false
    block = 'frac1 frac2'
  [../]
[]

[BCs]
  [./whole_h]
    type = DirichletBC
    variable = pressure
    boundary = circum
    value = 1e7
  [../]
  [./whole_t]
    type =  DirichletBC
    variable = temperature
    boundary = circum
    value = 150
  [../]
  [./well_t]
    type =  DirichletBC
    variable = temperature
    boundary = inject
    value = 70
  [../]
[]

[AuxVariables]
  [./vx]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./vy]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./pe]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./cr]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[AuxKernels]
  [./vx_ker]
    type = TigerDarcyVelocityComponent
    gradient_variable = pressure
    variable =  vx
    component = x
  [../]
  [./vy_ker]
    type = TigerDarcyVelocityComponent
    gradient_variable = pressure
    variable =  vy
    component = y
  [../]
  [./pe_ker]
    type = MaterialRealAux
    property = 'peclet_number'
    variable = pe
  [../]
  [./cr_ker]
    type = MaterialRealAux
    property = 'courant_number'
    variable = cr
  [../]
[]

[Variables]
  [./pressure]
    initial_condition = 1e7
    scaling = 1e9
  [../]
  [./temperature]
    initial_condition = 150
    #scaling = 1e2
  [../]
[]

[DiracKernels]
  [./pump_in]
    type = TigerPointSourceH
    point = '150.0 250.0 0.0'
    mass_flux = 3.0
    variable = pressure
  [../]
  [./pump_out]
    type = TigerPointSourceH
    point = '350.0 250.0 0.0'
    mass_flux = -3.0
    variable = pressure
  [../]
[]

[Kernels]
  [./H_diff]
    type = TigerKernelH
    variable = pressure
  [../]
  [./H_time]
    type = TigerTimeDerivativeH
    variable = pressure
  [../]
  [./T_advect]
    type = TigerAdvectionKernelTH
    variable = temperature
    pressure_varible = pressure
  [../]
  [./T_diff]
    type = TigerDiffusionKernelT
    variable = temperature
  [../]
  [./T_time]
    type = TigerTimeDerivativeT
    variable = temperature
  [../]
[]

[Preconditioning]
  active = 'p2'
  [./p1]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_hypre_type -ksp_rtol -ksp_atol -ksp_max_it -snes_rtol -snes_atol'
    petsc_options_value = 'hypre boomeramg 1e-12 1e-10 20 1e-8 1e-10'
  [../]
  [./p2]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -sub_pc_type -ksp_rtol -ksp_atol -ksp_max_it -snes_rtol -snes_atol -sub_pc_factor_shift_type'
    petsc_options_value = 'asm lu 1e-12 1e-10 20 1e-8 1e-10 NONZERO'
  [../]
  [./p3]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -ksp_type -sub_pc_type -pc_asm_overlap -ksp_rtol -ksp_atol -ksp_max_it -snes_rtol -snes_atol -sub_pc_factor_shift_type'
    petsc_options_value = 'asm gmres lu 2 1e-12 1e-10 20 1e-8 1e-10 NONZERO'
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 600
  end_time = 1892160000
  solve_type = NEWTON
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
[]
